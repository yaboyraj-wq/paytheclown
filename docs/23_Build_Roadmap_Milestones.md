# 23 — Build Roadmap and Milestones (for the AI agent)

> Build the fun first, then the plumbing, then the polish. Each milestone ends with **acceptance criteria** (the agent checks) and a **playtest gate** (the human checks). Don't start the next milestone until both pass. Report progress to the user at the end of every milestone with screenshots (Studio MCP `screen_capture`) and a short summary.

## How the agent works inside every milestone
1. Re-read the spec files listed for the milestone.
2. Write a short plan (tasks, files to touch, risks) in `docs/27_Decisions_Log.md` under the milestone heading.
3. Implement in small steps; commit after each working step (`git commit` with clear messages).
4. Write/extend unit tests for pure logic (Lune) and run them.
5. Playtest in Studio through MCP (`start_stop_play`, `character_navigation`, `user_keyboard_input`/`user_mouse_input`, `get_console_output`, `screen_capture`). For multiplayer, use Studio's multi-client test (Server + 2–4 clients) when possible.
6. Fix every error in the output log. Zero errors, zero warnings from our code.
7. Update docs if behavior changed (and log why).
8. Report to the user: what's done, screenshots, what to playtest, known issues.

---

## M0 — Project setup
**Read:** `18`, `AGENTS.md`, `SETUP_CONNECTIONS.md`
- Create the repo layout (`18` §3), `rokit.toml` (rojo, wally, selene, stylua, lune, luau-lsp pinned), `wally.toml` (ProfileStore, UI library choice, Signal, Trove/Janitor), lint/format configs, CI workflow.
- `hub.project.json` and `tower.project.json`; for early milestones also a `dev.project.json` that builds **one combined test place** (hub + tower content) so teleports can be mocked in Studio.
- `Config` skeleton with every config module from `04`, `05`, `06`, `14`, `15` filled with the documented starting values.
- `Net` module skeleton, bootstrap (init/start) for server and client.
**Acceptance:** `rojo serve` syncs into Studio; both places run with no errors; CI passes; Studio MCP connection verified (agent can read the game tree and run a playtest).
**Gate:** user confirms Studio, Codex and MCP are working.

## M1 — Gray-box core loop (the "is it fun?" prototype)
**Read:** `01`, `03`, `04`, `05_Booths/00`, `05_Booths/03` (Stop-the-Reels, pattern A), `05_Booths/05` (Block Toss, pattern B), `05_Booths/14` (Pie Sweeper, pattern C)
- One gray-box floor with 3 booths built with simple parts (no final art), a gray-box Lot 13 with just a READY pad.
- `NightLoopService` with states DAY → DEPARTING (short) → NIGHT_INTRO → NIGHT → CLOSING → RESULT_SUCCESS / RESULT_FAIL → CANNON (placeholder: players launched with a simple impulse) → RUN_OVER.
- `JarService` (shared jar, stake lock, payouts, audit log), quota from config with crew multiplier, 5:00 timer, Final Call.
- Booth framework v1 (state machine, claim, keypad UI basic, patterns A/B/C) and the 3 booths with their real rules.
- Basic HUD: jar meter with quota bar, timer, crew strip; basic toasts; big-stake heads-up toast (approval logic).
**Acceptance:** 1–4 players can play repeated nights; quotas and payouts follow `04`; all logic modules have tests; no client authority over outcomes.
**Gate (most important gate in the project):** a real friend group plays 3 sessions. Do they laugh, yell about the shared jar, and ask for one more night? If not, iterate here before anything else.

## M2 — All Floor 1 booths + economy simulator
**Read:** `05_Booths/01`–`06`, `04` §5 and §11
- Remaining Floor 1 booths (Hoop Wheel, Ring Stack 21, Duck Derby, Strongman Spinner) in gray-box with full rules, difficulty rows, Easy Assist, Showdown mode stubs.
- Full stake keypad UI, push/bank UI, result popups with win tiers, loss gags (placeholder art).
- `tools/economy_sim` v1 producing the `04` §11.1 report.
**Acceptance:** all 6 F1 booths playable and tested; simulator runs and its report is saved in `docs/27`.
**Gate:** friends rate each booth 1–5 for fun; any booth under 3 gets redesigned (log the change).

## M3 — Lot 13 stations, items, Foam Bat, tutorial
**Read:** `06`, `07`, `03` §11
- Prize crate spawn, Day Card, Dare Board (pool, acceptance, rerolls, tracking), Sal's Trailer (stock, buy, reroll, stash, pickup), Pawn Clamp (penalties, buy-back), Bill Box, Bouncy Lot (simple), Crew Trailer (rules, crew list, leave, invite, kick vote), Clown Car ready logic + departure cutscene placeholder.
- ItemService with all **Floor 1 items** first (Do-Over, Double Dare, Fix-It, Surprise Crate, Golden Ticket, Zap Wand, Fizz Pop, Bubble Wrap), then the rest as their floors arrive. Foam Bat with Block Toss + Strongman hooks.
- Tutorial flow for new players.
**Acceptance:** a full Day → Night loop with shopping, dares and pawning works with 1–6 players; all item rules from `06` §1 enforced.
**Gate:** a brand-new player (who has never seen the game) finishes Night 1 without help.

## M4 — Hub, crews, teleports, saves (two real places)
**Read:** `08`, `17`, `16`
- Midway Gates hub (gray-box), PLAY menu (New Crew, Continue, Quick Play), crew booths, friends panel, party grouping.
- MemoryStore crew directory; reserved-server teleports with retries; Rejoin; friend join; Quick Play fill; kick vote integration.
- ProfileStore player profiles; crew saves with locks, checkpoints and mid-night quit rule; `BindToClose`.
**Acceptance:** published DEV experience: create crew → teleport → play nights → leave → Continue later; rejoin works; Quick Play fills open seats; saves survive server shutdowns.
**Gate:** 2–3 friend groups play from separate homes on the DEV experience without help.

## M5 — Vertical slice: Floor 1 at final quality
**Read:** `10`, `11`, `12`, `13`, `09`
- Build the **style lock**: palettes, lighting presets, UI kit (all components), fonts, icon style, logo v1, loading screen, teleport screen.
- Take **one booth (Hoop Wheel or Block Toss)** to final art, sound, VFX and feel. It becomes the quality template.
- Then bring all of Floor 1, Lot 13 and the hub up to the same standard. NPCs v1 (Bigsby, Honk, Sal, Gert, Pawn Clamp) from Blender.
- The Big Cannon sequence at final quality.
**Acceptance:** every Floor 1 booth passes the per-booth game-feel checklist (`13` §6) and definition of done (`24`); performance budgets met on the baseline phone.
**Gate:** user compares screenshots with top Roblox games; "would I click this thumbnail?" Friends' reactions to the cannon.

## M6 — Floors 2–4, Showdown, endings, Endless
**Read:** `05_Booths/07`–`17`, `03` §3.10–3.12 and §10, `06`
- Floor 2 booths + F2 items; Floor 3 booths + F3 items; Floor 4 booths; each floor at gray-box first, then the M5 quality bar.
- Floor events (Spotlight, Ticket Rain, Rush Hour), Bigsby Walks the Floor.
- Final Choice, Showdown, 3 endings with cutscenes, Endless Nights.
**Acceptance:** a full 12-night run is completable; all endings reachable (add a DEV-only admin command to jump to any night for testing); simulator re-run with all booths.
**Gate:** two full runs by a friend crew; their notes on pacing and difficulty are addressed.

## M7 — Progression, cosmetics, monetization
**Read:** `14`, `15`, `19`
- Stars economy, Thrift Tent (catalog, try-on, equip), launch cosmetics (≈60), Showbiz Level, daily calendar, daily tasks, Carnival Pass Season 1, badges, leaderboards, Collection Book, codes kiosk.
- Game passes, developer products, subscription, private servers, receipts (idempotent), dynamic prices, PolicyService checks, rewarded video (behind a flag).
**Acceptance:** all purchases work in DEV with test products; receipts are idempotent (tested by simulating duplicate receipts); no purchase affects outcomes.
**Gate:** user reviews the store and offers for anything that feels pushy.

## M8 — Full presentation pass
- Art, audio and VFX for every area; all NPC animations; all cutscenes; seasonal-ready material swaps; final thumbnails and icon.
**Acceptance:** "same studio" test passes for every area; every screen in `10` §5 exists and matches the kit.

## M9 — Quality, performance, analytics, compliance, localization
**Read:** `16`, `18` §7, `19`, `20`, `24`, `10` §7
- Analytics funnels and events complete; exploiter simulation checklist; device matrix testing; memory and draw-call budgets; localization table complete; accessibility settings; admin tools; Right to Erasure procedure.
**Acceptance:** release checklist (`24` §7) fully green.
**Gate:** the user completes the account and compliance steps in `22` §1–2.

## M10 — Soft launch → launch → live ops
**Read:** `22`
- Phase A closed playtest → Phase B public 16+ soft launch → evaluation → Phase C all ages → weekly updates.
- Weekly analytics review (`19` §7) drives each update.
**Acceptance:** launch gates met (D1 ≥ 13.5%, session ≥ 19 min, crash < 0.5%) before scaling ads.

---

## Feature freeze rules
- Don't add features outside this spec without the user's approval and a `27` log entry.
- Bugs and feel issues in shipped features beat new features, always.
