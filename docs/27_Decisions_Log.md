# 27 — Decisions Log

> The agent and the user record every important decision, tuning change, deviation from the spec, and milestone report here, newest at the top. Format:
>
> `YYYY-MM-DD — [Area] Decision — Why — Files changed — Who decided`

## M0/M1 implementation plan — 2026-10-07

**Goal:** A verified project foundation followed by a playable three-booth gray-box loop; stop at the M1 friend playtest gate.
**Architecture:** Typed Luau services/controllers with init/start; server-owned run, jar and booth state; shared pure rules tested by Lune; Rojo sync; plain UI component modules. Existing `docs/` is the director-approved design. The director explicitly requests execution through M1 without another design approval gate.
**Spec:** `18`, `23` M0/M1, `03`, `04`, `05_Booths/00`, `03`, `05`, `14`, `16`, `24`.

### Decisions and rulings
- 2026-10-07 — [DEV confirmed] Owner confirms the renamed private experience `Pay the Clown [DEV]`, PlaceId `100356893013946`. MCP rechecked GameId `10769806964`. These are the only allowed DEV identifiers; all other places fail closed. IDs live only in `Config/Environment.luau`; other IDs remain 0. No LIVE changes authorized — Owner.
- 2026-10-07 — [UI] Use plain component modules with shared theme and localization. This keeps the small prototype straightforward to inspect in Studio and avoids a second UI lifecycle while preserving reusable components — Agent.
- 2026-10-07 — [Sync] Use Rojo for code, projects and tracked models. One combined DEV project allows early tests without teleports, while hub and tower manifests preserve the later split — Agent.
- 2026-10-07 — [Pie Sweeper] `05/14` places hidden pies after commitment, conflicting with AGENTS §2.2. Generate a fixed board before GO around a selected safe opening, show its pie layout for a 2-second pre-stake preview, then hide unrevealed tiles after lock; no later random placement. Keep deduction, cascades, payout formula and server authority. Public preview information can be retained by clients, like Gem Recall; accept that limitation. Correct the booth spec and anti-exploit wording — Agent. Cost if revised: one setup/preview flow.
- 2026-10-07 — [M1 scope] The specific M1 roadmap defines the repeated-night prototype; M3 owns items/bat/tutorial, M4 persistence/teleports, M6 endings/events. M1 uses a single gray floor, F1 stakes, F1 Reels/Block difficulty and F3 Pie difficulty; later nights still scale quota. Represent later states in shared types but keep those features disabled — Agent.
- 2026-10-07 — [Authority] `EconomyService` is the currency mutation primitive; `JarService` is its run-specific interface so both the one-door rule and M1 naming are satisfied — Agent.
- 2026-10-07 — [Tools] Saved user PATH contains Rokit. Restarting Codex should refresh it; use `C:\Users\YaBoy\.rokit\bin\rokit.exe` now. Blender deferred to M5; API key to M4. Ignore the existing Studio settings-plugin diagnostic unless it affects project scripts — Owner + agent verification.

Additional implementation rulings:
- Numeric literals used as arithmetic identities (0/1), array indices, vector axes and type/schema structure are not tuning values; every gameplay duration, limit, payout and geometry value belongs in Config. M1 geometry and previously unspecified technical defaults are recorded in `04` — Agent.
- Some future Dare/badge titles contradict the forbidden-word list ("Roll the Odds", "Poker Face", "Full House"). Config uses neutral internal identifiers; player-facing localization will use "Roll the Meter", "Carnival Face", "Full Crew", "Royal Waddles" and "No Splats". No forbidden titles are shown — Agent.
- Dependencies checked: ProfileStore 1.0.3 Apache-2.0; Signal 2.0.3 MIT; Trove 1.8.0 MIT. Packages remain restored via Wally, with their upstream notices preserved — Agent.

### Build and verification steps
- [x] M0 foundation: pinned toolchain, Wally packages, all Config modules, project manifests, lint/type/format configuration, CI, human README, bootstrap, Net skeleton, logger/retry/cleanup utilities and a Lune smoke test. Local verification: 2/2 tests, no Selene warnings/errors, no type errors, format and all three builds pass.
- [ ] M0 Studio: start Rojo, connect to the confirmed DEV place, run server/client bootstrap without project errors; push and check CI. Send five-line summary and proceed.
- [ ] M1 pure rules: Quota, Stakes, Approval, Payout, JarLedger, Reels, Block result rules, Pie board/cascade/multiplier, input validation. Write failing behavior tests, implement, run Lune suite, lint/format/typecheck, commit.
- [ ] M1 runtime: audited jar, run transitions, readiness, quotas/timers/grace/closing/cannon/restart, state snapshots/diffs, validated remotes, three booth adapters and gray-box models. DEV admin commands gated by exact environment plus Studio/owner identity. Verify server tests, commit.
- [ ] M1 client: localized HUD, crew strip, rule cards, keypad, approval toasts, timestamped reel controls, aim/power/spin, Pie preview/flags/push/bank, camera and input controls. Verify through input tools and screenshots, commit.
- [ ] M1 QA: several nights including pass/fail, all booths, replay/invalid/stale inputs, simultaneous spending, connection cleanup; multi-client if available, otherwise exact manual steps. Independent final review, fix material findings, push/check CI, report with screenshots and stop for director playtest.

### Review focus
Concurrent stake requests cannot overdraw; stale approval windows cannot spend a changed jar without revalidation; closing must settle once; disconnects cannot duplicate payouts; hidden state cannot leak beyond the documented preview.

### M0 verification — 2026-10-07
- Rojo 7.7.1 installed through the pinned CLI. Reopening the confirmed DEV place loaded the plugin; the combined DEV project synced successfully on localhost:34872. Original baseplate was preserved.
- MCP Play test: server and client bootstrap both print ready. Output contains zero errors/warnings. Relative Luau module paths work in Studio and Lune. Hub/tower manifests build successfully; their shared bootstrap is exercised together in DEV as requested for early milestones.
- Local check script passes: 2/2 tests, Selene 0 errors/0 warnings, formatting, type analysis and three place builds. Luau-lsp's standalone CLI reports its own file-watcher capability notice; it is unrelated to project code.
- Work stays in the current checkout on a codex branch, preserving the existing source-only repository and the active Rojo connection. No third-party game files accessed, no publication performed.

## M0 — connection preflight (2026-10-07)

- 2026-10-07 — [Connection checks] Repo root confirmed at `C:\Users\YaBoy\Documents\paytheclown`; `AGENTS.md` and `docs/` exist; `main` was clean and tracking `origin/main` before this log entry — Agent.
- 2026-10-07 — [Studio] MCP listing, state inspection, harmless Edit-mode print, and console readback passed. Connected window: `bqlrqj's Place: 10082026_2`; place ID `100356893013946`; universe ID `10769806964`; runtime name `Place3`. No DEV place ID is recorded in the repo, so DEV identity requires the owner's confirmation before implementation or Studio changes. No place content or settings changed — Agent.
- 2026-10-07 — [Tools] Git `2.55.0.windows.5`, GitHub CLI `2.102.0`, and Rokit `1.2.0` respond. Rokit is installed at `C:\Users\YaBoy\.rokit\bin\rokit.exe` but is absent from this session's PATH; use its absolute path or a process-local PATH addition. Reinstallation is unnecessary — Agent.
- 2026-10-07 — [Optional connections] No callable Blender MCP tools are exposed in this session, so scene connectivity could not be tested; needed at M5. `ROBLOX_API_KEY` is absent from this process environment; no secret value was read or printed; needed at M4 — Agent.
- 2026-10-07 — [Output] The connection marker appeared in Studio's console. Existing output also contains a Roblox GameSettingsPlugin "Failed to parse secrets: Can't parse JSON" message. It is not a project-script error; no project scripts have been created or playtested — Agent.

### Preflight report

- Built: Connection checks only; no implementation yet.
- Screenshots: None; no gameplay playtest yet.
- Tests: Studio MCP command/readback passed; Git, GitHub CLI, and Rokit version checks passed. Unit and gameplay tests have not begun.
- Please playtest: Not ready. First confirm that place `100356893013946` is the DEV sandbox, or open the intended DEV place.
- Known issues: DEV identity unconfirmed; Blender MCP unavailable; API key missing; Rokit missing from the session PATH; existing Studio plugin diagnostic noted above.
- Decisions: Use the installed Rokit executable; pause at the user's Step 1 identity check without changing the place.
- Next: Once DEV is confirmed, finish reading every Pass 1 file, record the implementation plan, build and verify M0, then proceed directly to M1 as the kickoff explicitly authorizes. Stop at the M1 playtest gate.
- Question for owner: Is place `100356893013946` the DEV sandbox for Pay the Clown!?

## Open questions (decide during playtests)
1. Is 5:00 the right default night length for younger players, or 7:00? (Save rule allows both; default may change.)
2. Pawn payouts (8/6/10 Tokens): tempting but rare? Track pawn rate in analytics.
3. Should Quick Play crews share Tokens exactly like friend crews? (Current: yes.)
4. Bill on Normal: keep 1,000,000 or tune after simulation (see `04` §11)?
5. UI implementation: React (react-lua) or plain component modules? Decide in M0.
6. Rojo vs. Studio Script Sync: Rojo recommended; confirm in M0.
7. Does Big-Stake Approval default OFF in friends crews feel too chaotic or just right?
8. Floor events: keep all three, or remove any that feel unfair?

## Decisions already made (from the design phase, 2026-10-07)
- 2026-10-07 — [Concept] Re-theme Gamble With Your Friends as a carnival co-op with skill booths — Roblox allows only unplayable gambling; skill keeps losses funny and fair — `01`, `25` — User + design.
- 2026-10-07 — [Avatars] Players use their own R15 Roblox avatars — identity and cosmetic sales — `09` — User + design.
- 2026-10-07 — [Monetization] Robux never buys Tickets, Tokens, items or outcomes; only Keep the Lights On is gameplay-adjacent and flags runs Assisted — fairness and retention — `15` — Design.
- 2026-10-07 — [Places] Two places: public hub (Midway Gates) and private reserved Tower servers — matches the original's friends-only runs while giving Roblox a social hub — `08` — Design.
- 2026-10-07 — [Original files] The agent never accesses the installed original game's files — Steam terms and copyright — `25`, `AGENTS.md` — Design.
- 2026-10-07 — [Tooling] Build with an AI coding agent connected to Roblox Studio (built-in MCP) and Blender (Blender MCP) — user's choice — `SETUP_CONNECTIONS.md` — User.

## Milestone reports
(Agent adds a report at the end of each milestone: what was built, screenshots, test results, known issues, next steps.)

## Tuning changes
(Agent adds every economy/booth tuning change here with before/after values and the reason.)
