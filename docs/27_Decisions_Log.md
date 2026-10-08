# 27 — Decisions Log

> The agent and the user record every important decision, tuning change, deviation from the spec, and milestone report here, newest at the top. Format:
>
> `YYYY-MM-DD — [Area] Decision — Why — Files changed — Who decided`

## M1 pre-playtest fixes — 2026-10-07

Director requests three changes, then another stop at the M1 friend gate.
Plan: (1) regress the cascade opening and replace it with one tile per pick;
(2) create a fresh server-owned world seed per run and deterministic setup streams;
(3) add visible world-space reels and reduce their side panel to payouts; verify
with Lune, lint/types/builds and actual DEV input/screenshots, then commit and push.

- Pie uses the reciprocal-survival formula from `reference/ORIGINAL_STUDY.md` §5.10,
  conditioned on the guaranteed opening: with `k` successful picks including it,
  `mult(k) = product(i=1..k-1, (25-i)/(25-pies-i))`, rounded to two decimals and capped
  at the existing 50x. Opening is 1x; no cascade and no 0.92 factor. Keep the 2-second
  visible setup and existing opening/neighbor protection. This supersedes earlier
  cascade and factor rulings. Direction: owner; conditional formula detail: agent.
- Reels show starting symbols directly on the machine before GO; the side panel
  contains only payouts. All spinning visuals will share the server's deterministic
  timeline. No new randomness after GO. Direction: owner.
- Generate worldSeed once per run on the server, keep it through nights/admin night
  jumps, and derive separate streams for night strips, play offsets and Pie setups.
  Do not replicate the master seed; replicate only each permitted setup preview.
  Block Toss retains its fixed physical starting pose and input-driven physics.
  Direction: owner; stream separation and seed visibility: agent.
- Verification so far: cascade and payout regressions failed against the old rules,
  then passed after the fix. Seed tests also went red-to-green. DEV server checks
  exercised eight fresh run seeds, seed retention across nights, different night/run
  setups, the two-second Pie preview, one-tile 1x opening and one extra pick banking
  11 Tickets from a 10-Ticket stake. 23/23 tests, lint/types/format and builds pass.


## M0/M1 implementation plan — 2026-10-07

**Goal:** A verified project foundation followed by a playable three-booth gray-box loop; stop at the M1 friend playtest gate.
**Architecture:** Typed Luau services/controllers with init/start; server-owned run, jar and booth state; shared pure rules tested by Lune; Rojo sync; plain UI component modules. Existing `docs/` is the director-approved design. The director explicitly requests execution through M1 without another design approval gate.
**Spec:** `18`, `23` M0/M1, `03`, `04`, `05_Booths/00`, `03`, `05`, `14`, `16`, `24`.

### Decisions and rulings
- 2026-10-07 — [Original files] Owner authorized a separate reference study of the original game — User.
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
- [x] M0 Studio: Rojo sync, server/client playtest without errors, pushed foundation `1505537`; GitHub Actions run `37711632982` passed. Five-line summary sent; proceeding directly to M1 as authorized.
- [x] M1 pure rules: Quota, Stakes, Approval, Payout, JarLedger, Reels, Block result rules, Pie board/cascade/multiplier, input validation and readiness. Initial missing-feature run: 14 failing new tests; implementation: 16/16 tests pass, lint/format/types and three builds pass.
- [x] M1 runtime: audited jar, run transitions, readiness, quotas/timers/grace/closing/cannon/restart, state snapshots, validated remotes, three booth adapters and gray-box models. DEV admin commands gated by exact environment plus Studio/owner identity. Server tests pass; committed in `bca96b1`.
- [x] M1 client: localized HUD, crew strip, rule cards, keypad, approval toasts, timestamped reel controls, aim/power/spin, Pie preview/flags/push/bank, camera and input controls. Verified through actual input tools and screenshots; committed in `bf5ac3b`, then clarified exact Reels starting slots after review.
- [x] M1 QA: repeated pass/fail/replay, all booths, invalid/stale inputs, simultaneous spending, disconnect settlement and host transfer; two real local clients. Independent review finding fixed. Final local checks: 21/21 unit tests, lint/types/format and all builds pass. QA scripts, screenshots and friend guide saved. GitHub CI result is linked in the milestone handoff after push.

### Review focus
Concurrent stake requests cannot overdraw; stale approval windows cannot spend a changed jar without revalidation; closing must settle once; disconnects cannot duplicate payouts; hidden state cannot leak beyond the documented preview.

### M0 verification — 2026-10-07
- Rojo 7.7.1 installed through the pinned CLI. Reopening the confirmed DEV place loaded the plugin; the combined DEV project synced successfully on localhost:34872. Original baseplate was preserved.
- MCP Play test: server and client bootstrap both print ready. Output contains zero errors/warnings. Relative Luau module paths work in Studio and Lune. Hub/tower manifests build successfully; their shared bootstrap is exercised together in DEV as requested for early milestones.
- Local check script passes: 2/2 tests, Selene 0 errors/0 warnings, formatting, type analysis and three place builds. Luau-lsp's standalone CLI reports its own file-watcher capability notice; it is unrelated to project code.
- Work stays in the current checkout on a codex branch, preserving the existing source-only repository and the active Rojo connection. No third-party game files accessed, no publication performed.

### M1 rule implementation — 2026-10-07
- Pie multiplier removes the guaranteed opening tile from both populations: product starts at i=1, with k equal to total revealed safe tiles. A lone opening is 1x; cascade extras count. The original approximate examples were not exact; the formula and explicit first-tile exclusion govern. Cost if revised: formula plus its tests.
- Input packets accept only bounded scalar fields (64-character strings, at most 8 fields); each action also checks its exact schema, controller, phase and distance. No client payout/result fields are accepted.
- Economy mutations are synchronous and deduplicated per run; each accepted mutation records actual before/after balances, including capped credits. Audit display retains 2,048 entries; operation IDs remain remembered for the run.

### M1 runtime and input verification — 2026-10-08
- Owner admin ID `3068993386` was verified against this DEV experience's user CreatorId and the signed-in test player. The gate requires both exact DEV IDs, then Studio or that owner ID; no other environment is permitted.
- Server smoke test exercised readiness, crew-scaled quota, duplicate payout rejection, quota payment exactly once, next Day, forced failure, cannon and host replay. It passed in the running server Script context. MCP command execution has a separate module cache, so tracked QA scripts are injected temporarily during Play to test the actual services.
- A regression test exposed duplicate quota IDs when `/ptc night` revisited a paid night. A per-departure attempt number now distinguishes separate nights while retaining idempotence within one night. The same Studio test changed from failure to PASS. Packet field-name bounds also changed from a failing unit test to green; suite now 17/17.
- Block Toss repeated the same server-owned throw 20 times at aim 0, power 0.5, spin 0: all 20 returned 12. This verifies one learned throw, not every possible trajectory. Actual GUI aiming/charging/release also ran without script diagnostics.
- MCP movement and real input tools exercised Reels' preview, GO and three stops; Block Toss; Pie's 8-pie setup, PUSH, safe reveal, BANK (10 staked → 13 returned), and a pie loss. A full natural 5-minute night reached Final Call. Screenshots are in `docs/screenshots/`.
- **Balance risk for the director:** the specified 3-pie protected opening cascaded to 21 safe tiles and auto-banked 50x. This is the written formula/cascade behavior, not a client-authority bug. Retain the specified values for M1; discuss the opening/cascade economy at the playtest gate before broader booth rollout.
- **Ruling:** Reels offsets must be shown before GO, not first shown during spinning; this follows AGENTS' commitment rule. Closing grace auto-banks an existing PUSH/BANK decision per the higher-priority booth framework; other unfinished plays lose. Lower-priority wording was corrected.
- M1 uses English source strings in a Roblox LocalizationTable and original gray-box models. Final animation, audio, loss gags, item/bat hooks, tutorial, full device matrix, persistence and endings stay in their roadmap milestones. No claim of full release readiness under `24` §6 is made.
- Independent whole-branch review (`e552bb1..bf5ac3b`): no Critical findings or deferred minors. One Important finding: repeated Reels symbols made the starting offset ambiguous. The preview now includes the exact one-based slot as well as its symbol. A test with two STAR occurrences failed before this change and passes after it; 18/18 unit tests pass.
- Review rulings: retain the documented Pie economy for the director's decision (formula and tests are inexpensive to revise); defer items/bat/tutorial, saves/teleports, final art/audio, endings and production device/performance coverage to their explicit milestones. These are scope decisions, not claims those features are complete. Multiplayer must be verified before the M1 handoff.
- Local Studio **Server and Clients** successfully retained both authorized DEV IDs. Two actual clients used READY and saw quota 400 and the same jar. Player2's GUI NO WAY veto blocked Player1's 500-Ticket request without debiting. Server integration checks with those actual players passed simultaneous 700/700 requests against a 1,000 jar, refreshed approval after a balance reduction, requester/stale/double-vote rejection, friends heads-up-only behavior, and wrong-controller rejection.
- Actual host-client closure during a pending Pie decision banked the 10-Ticket value exactly once, transferred host to Player2, and preserved the locked two-person quota. Player2 then reached RUN_OVER and used the real PLAY AGAIN button to return to Lot 13 with 1,000 Tickets.
- Final fresh single-client DEV run on the latest source: TextChatCommand `/ptc jar 1234` changed the actual server jar and HUD. Malformed packets and 1,000-packet bursts on each inbound channel left the jar unchanged; rejection logs were bounded to one per channel/window. Console contained zero warnings/errors. Updated Reels preview screenshot confirms distinct starting slots before GO. Temporary QA scripts disappeared when Play stopped.
- Final spec audit found the fixed-window limiter was missing `16`'s token-bucket and sustained-spam kick requirements. Added pure `RateLimit`, smooth token refill, three consecutive windows strictly above 5x rate, bounded logging and a localized generic disconnect. Three new tests first failed for the missing module, then passed; suite now 21/21. Isolated bursts and idle gaps explicitly cannot trigger a kick. Full release anti-exploit/device coverage remains in later milestones; prototype evidence is not a green release checklist.
- Friend access instructions use Roblox's current Limited → Playtesters audience. Its publishing page has conflicting older introductory Private wording; the dedicated audience/private sections govern the guide. The owner handles eligibility, verification, questionnaire, publication and access changes; the agent made none.
- Token-bucket Studio verification: a 1,000-packet isolated burst on each inbound channel was dropped without disconnecting or changing the jar. Sustained 100/s Action spam produced the generic kick after the configured observation windows; the actual PlayerRemoving event verified unchanged currency. A fresh normal playtest and complete server smoke passed afterward. Separate reference-policy edits appeared during QA; they were preserved and excluded from implementation commits.

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
5. Resolved M0: plain UI component modules; see the UI ruling above.
6. Resolved M0: Rojo; see the Sync ruling above.
7. Does Big-Stake Approval default OFF in friends crews feel too chaotic or just right?
8. Floor events: keep all three, or remove any that feel unfair?

## Decisions already made (from the design phase, 2026-10-07)
- 2026-10-07 — [Concept] Re-theme Gamble With Your Friends as a carnival co-op with skill booths — Roblox allows only unplayable gambling; skill keeps losses funny and fair — `01`, `25` — User + design.
- 2026-10-07 — [Avatars] Players use their own R15 Roblox avatars — identity and cosmetic sales — `09` — User + design.
- 2026-10-07 — [Monetization] Robux never buys Tickets, Tokens, items or outcomes; only Keep the Lights On is gameplay-adjacent and flags runs Assisted — fairness and retention — `15` — Design.
- 2026-10-07 — [Places] Two places: public hub (Midway Gates) and private reserved Tower servers — matches the original's friends-only runs while giving Roblox a social hub — `08` — Design.
- 2026-10-07 — [Original files] Superseded by the owner-authorized separate reference study recorded above; building agents use only reference/ORIGINAL_STUDY.md — User.
- 2026-10-07 — [Tooling] Build with an AI coding agent connected to Roblox Studio (built-in MCP) and Blender (Blender MCP) — user's choice — `SETUP_CONNECTIONS.md` — User.

## Milestone reports

### Milestone 1 report — 2026-10-07 (Pacific)

**Built:**
- M0 toolchain, configuration, CI and guarded DEV setup.
- One original gray floor and Lot 13 with three playable skill booths.
- Shared audited jar, crew quota, five-minute nights, Final Call, closing, cannon and replay.
- HUD, keypad, warnings/approvals, mouse/keyboard controls, touch/controller input paths and DEV commands.

**Screenshots:** [Reels preview](screenshots/m1-reels-preview.png),
[two-player stake warning](screenshots/m1-multiplayer-approval.png),
[Pie BANK](screenshots/m1-pie-bank.png), [Final Call](screenshots/m1-final-call.png).

**Tests:** 21/21 Lune tests; Selene zero errors/warnings; StyLua and Luau type checks;
hub/tower/dev builds. Actual Studio input tests covered all three booths and natural
Final Call. Server tests covered repeated nights, quota/payout deduplication,
admin night revisits, invalid remotes and extreme spam. Two real local clients
verified the same jar, vetoes, concurrent spending, host departure and replay.
Block Toss's repeated reference throw matched 20/20 times. Latest normal server/client
run had zero script warnings/errors. One independent review finding fixed.

**Please playtest:** Follow [M1_PLAYTEST.md](M1_PLAYTEST.md). Use the local
Server/Add Clients steps first, then the owner-controlled DEV publishing and
tester access steps for friends on separate computers. Play three sessions and
watch for laughter, jar arguments and requests for another night.

**Known issues:** Low-pie openings can immediately auto-bank 50x under the current
formula. Actual tests covered one and two players, not four concurrent clients.
Tablet emulation and desktop were inspected; physical phone/controller/performance
coverage is pending. This milestone has no saves, shops, items, final art/audio or
endings. No published DEV friend session has yet been performed.

**Decisions I made:** See the rulings and verification entries above: plain UI
modules, Rojo, exact DEV guards, public Pie setup, explicit Reels starting slots,
and preserving the specified Pie numbers for the fun gate.

**Next:** Stop here. Address the director's M1 feedback, then start M2 only after
the three-session gate and explicit go-ahead.

**Questions for you:** After playing, what was the best moment, what was most
confusing, and did the crew ask for another night?

## Tuning changes
(Agent adds every economy/booth tuning change here with before/after values and the reason.)
