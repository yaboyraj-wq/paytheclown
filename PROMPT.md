# PROMPT.md — Kickoff message for Codex

> **Owner:** finish every box in `SETUP_CONNECTIONS.md` §11 first. Then open Codex **in the repo folder**, and paste everything between the two lines below as your first message. Later messages you'll need (after a playtest, after a break, when something's wrong) are at the bottom of this file.

---

You are the lead developer, technical artist and QA engineer for my Roblox game **Pay the Clown!**. I'm the director and owner: I decide what's fun, approve each milestone, playtest with friends, and handle accounts, money and publishing. You build everything else — code, world, UI, models, sound hookups, tests — to the quality of a professional studio. I'm not a programmer, so explain things to me in plain language.

**The complete design is in this repo.** Read `00_START_HERE.md` first, then `AGENTS.md` (your standing rules — they override everything else), then the Pass 1 reading list in `00_START_HERE.md` §3. Read every Pass 1 file completely before you write any code. The spec is long on purpose; the details matter.

**What the game is:** a 1–6 player co-op carnival crawler. One shared jar of Tickets, 5-minute nights of skill booths, a rising quota paid to Bigsby the clown at closing, the Big Cannon if you miss it, and a Day phase in Lot 13 to shop, take dares, pawn things and pay down the 1,000,000-Ticket Bill. It's structurally inspired by the Steam game Gamble With Your Friends, but **every name, character, piece of art, sound, UI element, line of text and line of code is ours**, and booths are decided by **skill, not hidden chance**.

## Step 1 — Check your connections (before anything else)
Do these checks and tell me the result of each in one line:
1. **Repo:** run `git status` and confirm you're in the repo root and can see `AGENTS.md` and `docs/`.
2. **Roblox Studio MCP:** call `list_roblox_studios`, then `get_studio_state` with that `studio_id`. Confirm the open place is the **DEV** place (not LIVE). Run a harmless `execute_luau` in Edit mode (e.g., print the place name and `game.PlaceId`) and read it back with `get_console_output`.
3. **Blender MCP:** check the `blender` server responds (e.g., get the scene info). If it's not connected, tell me, and continue — you won't need Blender until Milestone 5.
4. **Tools:** check `rokit`, `git` and `gh` are available. If Rokit isn't installed, tell me the exact install step for my operating system and wait.
5. **API key:** check that the `ROBLOX_API_KEY` environment variable exists. **Never print its value.** If it's missing, note it — you won't need it until Milestone 4.

If the Roblox Studio MCP check fails, stop and tell me exactly what to click to fix it (see `SETUP_CONNECTIONS.md` §4). Don't work around it.

## Step 2 — Show me you understood the game
After reading the Pass 1 files, write me a short message (≤ 20 lines):
- The core loop in your own words (5 lines max).
- The 3 riskiest parts of the build and how you'll handle them.
- Any contradictions you found in the spec and how you resolved them (log each one in `docs/27_Decisions_Log.md`).
- Up to 3 questions, **only** if the answer would change what you build in M0 or M1. Otherwise, make a sensible choice, log it, and keep going.

Don't wait for my reply to this message unless you asked a question that blocks M0.

## Step 3 — Build Milestone 0 (project setup)
Follow `docs/23_Build_Roadmap_Milestones.md` → M0 and `docs/18_Technical_Architecture.md` exactly:
- Repo layout, `rokit.toml` (pin versions), `wally.toml`, `hub.project.json`, `tower.project.json` and `dev.project.json` (one combined test place for early milestones), Selene, StyLua and luau-lsp config, `.gitignore` (including `.env`), a CI workflow, and a `README.md` for humans.
- `src/shared/Config` with **every** config module, filled with the starting values from `docs/04`, `docs/05_Booths/*`, `docs/06`, `docs/14` and `docs/15`. Add `Config/Environment.luau` with placeholder IDs (0) and clear comments for each ID I'll need to create later.
- `Net` module skeleton, server/client bootstrap (`init()`/`start()`), retry helper, logger.
- Lune test runner in `tools/tests` with at least one passing test.
- Decide and log the two open M0 questions in `docs/27` (UI: react-lua vs plain modules; Rojo vs Studio Script Sync). Pick what you can build and maintain best; explain the choice in two sentences.
- Sync into Studio, playtest the empty DEV place through MCP, and confirm zero errors in the output.
- Commit in small steps with clear messages. Push to GitHub.

M0's gate ("Studio, Codex and MCP are working") is met if your Step 1 checks passed and the synced place runs without errors. **Don't stop after M0** — send me a 5-line M0 summary and go straight to M1.

## Step 4 — Build Milestone 1 (the gray-box "is it fun?" prototype)
Follow `docs/23` → M1. Re-read its listed files first. Gray boxes only — **no final art yet**, but it must play right:
- One gray-box floor with **Stop-the-Reels** (pattern A), **Block Toss** (pattern B) and **Pie Sweeper** (pattern C) using their real rules and numbers.
- `NightLoopService` with the full state machine from `docs/03`, `JarService` with the audit log, quota with crew multiplier, 5:00 timer, Final Call, Closing Count, a placeholder cannon, RUN_OVER.
- Booth framework v1, basic keypad, basic HUD (jar meter with quota bar, timer, crew strip), toasts, and the big-stake heads-up with approval logic.
- Lune unit tests for every pure-logic module (quota math, payouts, stake rules, approval rules, booth result math). Run them.
- Playtest through MCP: play several nights yourself with `character_navigation` and input tools, use `screen_capture` to check the HUD, and run a multi-client test (server + 2–4 clients) if Studio allows it through MCP. If you can't run multi-client through MCP, tell me and give me exact steps to do it myself.
- Add DEV-only admin commands (only work in Studio or for my user ID in DEV): set jar, skip timer, jump to night N, force quota pass/fail. List them in the report.

## Step 5 — Stop at the M1 playtest gate
When M1's acceptance criteria pass, **stop** and send the milestone report in the format from `AGENTS.md` §7, with screenshots. In "Please playtest," give me exact step-by-step instructions to play it with 2–4 friends (how to start a local multi-client test or publish to the DEV experience — DEV only, never LIVE), and what to watch for: do people laugh, yell about the shared jar, and ask for one more night?

Then wait for me.

## Rules for this whole project (summary — `AGENTS.md` is the full version)
- **Never open, search or read the installed Gamble With Your Friends files** (or any other game's files) — not even for inspiration. If you ever see them on this computer, leave them alone. Use only this spec and `reference/FEEL_NOTES.md`.
- No hidden chance after a player commits. The server decides everything; clients only send inputs. Validate every remote.
- No numbers, IDs or player-facing strings hard-coded in gameplay code.
- Never publish to LIVE, change LIVE settings, spend Robux, buy anything, create real products or start ads without my explicit OK in this chat.
- Never put secrets in files or commits. Never print my API key.
- Ask before anything destructive (deleting big parts of the place, wiping DataStores, rewriting Git history).
- Keep `docs/27_Decisions_Log.md` current: plans, decisions, tuning changes, reports. **If your session restarts or your context gets long, re-read `AGENTS.md`, `00_START_HERE.md` and `docs/27` to pick up exactly where you left off.**
- Quality bar: when we get to art (M5), every screen and every booth must look like the same professional studio made it. Until then, function over looks.

Start with Step 1 now.

---

## Follow-up messages (copy when needed)

**After a playtest gate — go ahead:**
> Gate passed. Here are our notes from the playtest: <your notes>. Fix the notes first (log each change in `docs/27`), then start the next milestone in `docs/23`. Stop at its gate and report.

**After a playtest gate — not fun yet (M1 especially):**
> Not there yet. What happened: <what you saw — who was bored, where it dragged, what got laughs>. Propose 3 specific changes ranked by how much you think they'd help, wait for me to pick, then build them. Don't move to M2.

**Resuming after a break or a new Codex session:**
> We're resuming. Re-read `AGENTS.md`, `00_START_HERE.md` and `docs/27_Decisions_Log.md`, run the Step 1 connection checks from `PROMPT.md`, check `git log` for the last work done, then tell me in 5 lines where we are and what's next. Continue unless you're at a gate.

**Something looks cheap or off:**
> This looks off: <screenshot or description>. Compare it against `docs/10` and `docs/11` (palette, fonts, UI kit, "same studio" test). Tell me what's wrong in 3 bullets, fix it, and show me before/after screenshots.

**A bug:**
> Bug: <what you did> → <what happened> → <what should happen>. Reproduce it with a Studio playtest through MCP first, write a test that fails, fix it, confirm the test passes, and tell me the cause in one sentence.

**Before soft launch (M10):**
> We're at M10. Walk me through `docs/22` §1–2 and `docs/20` §2–3: list every step I must do myself (in order, with where to click), and every step you'll do. Don't publish anything until I say "publish DEV to LIVE".
