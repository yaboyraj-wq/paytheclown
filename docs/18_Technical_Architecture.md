# 18 — Technical Architecture

> Write code like a professional Roblox studio: files in Git, typed Luau, server-authoritative services, pure logic modules with tests, one config source of truth, and two environments (DEV and LIVE).

## 1. Toolchain
| Tool | Purpose |
| --- | --- |
| Roblox Studio (latest) with the built-in **Studio MCP server** enabled | Building, playtesting, AI agent control |
| **Rojo** | Syncs code and models between the file system and Studio (Roblox's built-in **Script Sync** is an acceptable alternative for scripts only; pick one and stick with it — Rojo recommended for two-place projects) |
| **Rokit** | Installs and pins tool versions (`rokit.toml`) |
| **Wally** | Package manager for Luau libraries |
| **Selene** | Linter |
| **StyLua** | Formatter |
| **luau-lsp** | Type checking in the editor / CI (`--!strict` everywhere) |
| **Lune** | Runs pure Luau modules and tests outside Roblox (economy simulator, logic tests) |
| **Git + GitHub** | Version control, history, backups, CI |
| **Blender** (+ Blender MCP) | NPC models, hero props, rigs |
| Open Cloud API key (stored as an environment variable, never in the repo) | Publishing places, uploading assets, DataStore backups |

## 2. Environments
- **DEV experience:** "Pay the Clown [DEV]" — private, used for all testing, its own DataStores and product IDs.
- **LIVE experience:** the public game.
- `Shared/Config/Environment.luau` maps `game.GameId` → environment and holds place IDs, product IDs, badge IDs, and feature flags for each. Code never hard-codes IDs elsewhere.
- Publishing: Studio "Publish to Roblox" for the first versions; later automate with Open Cloud place publishing (e.g., the `rbxcloud` CLI) from CI after tests pass.

## 3. Repository layout
```
paytheclown/
  AGENTS.md                      # agent rules (copied from the spec folder)
  docs/                          # this spec folder (source of truth)
  rokit.toml  wally.toml  selene.toml  stylua.toml  .luaurc
  hub.project.json               # Rojo project for Midway Gates
  tower.project.json             # Rojo project for The Tower
  src/
    shared/                      # → ReplicatedStorage.Shared (both places)
      Config/                    # Economy, Booths, Items, Dares, Cosmetics, Badges, Products, UITheme,
                                 #   LightingPresets, Environment, Strings keys
      Logic/                     # PURE modules (no Roblox services): Quota, Stakes, Payout, Bonuses,
                                 #   BoothLogic/<Booth>.luau, PieSweeperLogic, RNG, Format, Schema
      Net/                       # Remote definitions + schemas + rate limits
      Types/                     # Shared type definitions
      Util/                      # Signal, Trove/Janitor wrapper, Retry, Promise helpers
    server/
      common/                    # → ServerScriptService.Common (both places)
        ProfileService.luau      # wraps ProfileStore (player profiles)
        EconomyService.luau      # the ONLY place currencies change (Stars here; Tickets/Tokens in run)
        MonetizationService.luau # receipts, passes, subscriptions, prices
        TelemetryService.luau    # AnalyticsService wrapper
        BadgeAwardService.luau
        ModerationService.luau
        TeleportHelper.luau
        DailyService.luau        # calendar, daily tasks
      hub/                       # → ServerScriptService.Hub (hub place only)
        CrewLobbyService.luau  MatchmakingService.luau  LeaderboardService.luau
        PracticeBoothService.luau  CodesService.luau
      tower/                     # → ServerScriptService.Tower (tower place only)
        NightLoopService.luau    # run state machine (03 §3); not called "RunService" to avoid clashing with Roblox's RunService
        CrewSaveService.luau  JarService.luau  QuotaService.luau
        BoothService.luau  booths/<Booth>Server.luau
        ItemService.luau  StationService.luau (Dare, Shop, Pawn, BillBox, Trailer)
        VoteService.luau  ShowdownService.luau  CutsceneService.luau
    client/
      common/  hub/  tower/
        Controllers/ (UIController, InputController, CameraController, AudioController, VFXController,
                      BoothClient, ItemClient, HUDController, ToastController, CutsceneClient)
        UI/ (components from the UI kit; screens)
    first/                       # → ReplicatedFirst (loading screen)
  assets/                        # .rbxm models synced by Rojo (booth prefabs, NPC rigs, VFX templates)
  art/                           # Blender sources, exports, textures, UI art, ASSET_LOG.md
  tools/
    economy_sim/                 # Lune economy simulator (04 §11)
    tests/                       # Lune test runner for shared/Logic
  .github/workflows/ci.yml       # selene, stylua --check, luau-lsp analyze, lune tests
```

## 4. Core runtime architecture

### 4.1 Services and controllers
- Each server service is a ModuleScript with `init()` (set up, no yielding across services) and `start()` (connect events, begin loops). A bootstrap script requires all services, calls all `init`, then all `start`.
- Each client controller follows the same pattern.
- Services talk through direct module calls (server side) and typed Signals. No `_G`, no `shared`.

### 4.2 Run state replication
- The Tower server keeps the authoritative `RunState` (state, night, floor, timer end time in server time, quota, jar, bill, tokens, crew list, dare progress).
- Replicate with a small `StateReplicator`: the server sends full state on join and **diffs** on change through one RemoteEvent; clients keep a read-only store and fire Signals for UI. Timers replicate as end timestamps (`workspace:GetServerTimeNow()` base), not ticking numbers.
- Booth states replicate per booth (state, controller, stake, public result data) the same way.

### 4.3 Networking
- `Net` module: declares every remote with name, direction, argument schema, and rate limit. Generates RemoteEvents at startup in `ReplicatedStorage.Net`. Server handlers get validated, typed arguments.
- Use `UnreliableRemoteEvent` for cosmetic high-frequency data (steering prediction echoes, cosmetic reactions); never for state or currency.

### 4.4 Determinism and seeds
- `Logic/RNG.luau` wraps `Random.new(seed)`; every random choice uses a named stream (`booths`, `dares`, `shop`, `wheelLayout`) derived from `runSeed`, night, and a counter, so saves reproduce the same Day content.
- Shared motion functions (reels, needle, wheel spin, rocket multiplier, beat clocks) live in `Logic/BoothLogic/*` and are used by both client (render) and server (evaluate).

### 4.5 Booth framework in code
- `BoothService` owns booth instances: spawn on pads, state machine, Controller claim, stake keypad validation, stake lock through `JarService`, item hooks through `ItemService`, payout through `JarService`, telemetry.
- Each booth implements an interface:
```lua
export type BoothModule = {
  id: string,
  pattern: "A" | "B" | "C",
  setupRound: (ctx: BoothContext) -> RoundSetup,          -- visible randomness, sent to clients
  onInput: (ctx: BoothContext, player: Player, input: any) -> (),
  isResolved: (ctx: BoothContext) -> boolean,
  getResult: (ctx: BoothContext) -> { multiplier: number, details: any },
  getDoOverState: (ctx: BoothContext) -> RoundSetup,
  getDoubleDareChallenge: (ctx: BoothContext) -> RoundSetup,
  difficulty: { [string]: any },                           -- floor rows from Config/Booths
}
```
- Booth prefabs (models) are authored in Studio/Blender and stored as `.rbxm` in `assets/booths/` with named attachment points (`ControlPad`, `WatchZone`, `CameraPlay`, `CameraWatch`, `RuleCardAnchor`).

### 4.6 Streaming and places
- Enable `Workspace.StreamingEnabled` in The Tower. Floors not in use are kept far apart; set `Model.ModelStreamingMode` to `Persistent` only for small critical models (booth control parts in the active floor).
- Lot 13 and each floor are separate Models under `Workspace.Areas`; non-active areas can have their decorative parts parented to `ServerStorage` and moved in on demand if memory is tight.

## 5. Libraries (via Wally; check licenses)
- **ProfileStore** (session-locked player data).
- **React** + **ReactRoblox** (jsdotlua) for UI — or plain component modules if simpler; choose once in `27_Decisions_Log.md`.
- A Signal library (e.g., GoodSignal-style) and a cleanup helper (Trove or Janitor).
- No large frameworks are required (Knit-style frameworks are optional; a simple init/start bootstrap is enough).

## 6. Coding standards
- `--!strict` at the top of every script; exported types for shared data.
- Names: `PascalCase` modules and types, `camelCase` functions/variables, `SCREAMING_SNAKE` constants and IDs.
- Use the `task` library (`task.wait`, `task.spawn`, `task.delay`); never `wait()`/`spawn()`/`delay()`.
- Wrap every Roblox web call (DataStore, MemoryStore, Teleport, Marketplace, Badge, Text, Policy) in a `Retry` helper with backoff and logging.
- No magic numbers in gameplay code — read from `Config`.
- Every player-visible string from the localization table.
- Clean up connections (Trove/Janitor) on booth despawn, player leave, and area change.
- Comments explain *why*, not *what*.

## 7. Performance targets
| Target | Value |
| --- | --- |
| Server heartbeat | Stays near 60 Hz with 6 players; no frame > 30 ms of script time |
| Client FPS | 60 on PC; 30+ on the baseline phone |
| Network | < 50 KB/s per client average during nights |
| Memory | see `11` §5.1 |
| Join to playable (hub) | < 8 s on a mid phone |
| Teleport hub → Lot 13 playable | < 12 s |

Use the MicroProfiler and the Performance Stats overlay every milestone (`24`).

## 8. Error handling and logging
- Server errors are caught per service call (`xpcall` with traceback) and reported through `TelemetryService` (custom error events, rate-limited) and Roblox's built-in error reports in Creator Hub analytics.
- A player-facing error never shows a stack trace; show friendly messages (`08` §9).

## 9. Feature flags
- `Config/Flags.luau` per environment: e.g., `ENABLE_REWARDED_ADS`, `ENABLE_FLOOR_EVENTS`, `ENABLE_ENDLESS`, `SEASON_ID`, `EVENT_THEME`. Allows shipping code dark and turning features on without a full redeploy of logic (still requires a publish for script changes; for live toggles without publishing, read a small JSON from a DataStore key `LiveConfig` cached for 60 s).
