# 00 — START HERE: Pay the Clown! game spec

> **For the AI developer:** this folder is the complete design for the game you're building. Read this file first, then `AGENTS.md`, then the files in the reading order below. Every number, rule and screen is written down somewhere in here. If something is missing, follow the pillars in `docs/01`, decide, and log it in `docs/27`.
>
> **For the owner (Balraj):** do `SETUP_CONNECTIONS.md` first, then paste `PROMPT.md` into Codex.

## 1. The game in 30 seconds
**Pay the Clown!** is a 1–6 player co-op **carnival crawler** on Roblox. Your crew wandered into **Bigsby's Midnight Midway**, leaned on the wrong rope, and let **Bigsby the clown's** Grand Balloon float away. Now the crew owes him a **Bill** of 1,000,000 Tickets. Every **night** (5 minutes) the crew plays **skill booths** on a tower floor to grow one **shared jar** of Tickets. At closing, Bigsby takes a rising **quota**. Miss it and the whole crew is fired out of the **Big Cannon** — run over. Between nights, in **Lot 13**, the crew buys gadgets, accepts dares, pawns their shades for Tokens, and pays down the Bill. Survive 12 nights across 4 floors, then pay the Bill or risk it all in the **Showdown**.

It keeps the **structure** of the Steam game Gamble With Your Friends (shared bank, shared debt, timed rounds, rising quota, shop between rounds, challenges, body-part economy, 4 floors, items, 3 endings, Endless) with **all-new lore, art, code, names and characters**, and **skill booths instead of games of chance** (Roblox only allows unplayable gambling, and skill keeps losses funny and fair).

## 2. Folder map
```
PayTheClown_GameSpec/
├── 00_START_HERE.md            ← you are here
├── AGENTS.md                   ← standing rules for the AI developer (Codex reads this automatically)
├── PROMPT.md                   ← the kickoff message the owner pastes into Codex
├── SETUP_CONNECTIONS.md        ← what the owner installs/connects before starting
├── reference/
│   ├── README.md               ← what may and may not go in this folder
│   └── FEEL_NOTES.md           ← owner's own written notes on how the original feels
└── docs/
    ├── 01_Vision_and_Pillars.md
    ├── 02_Lore_World_Characters.md
    ├── 03_Core_Loop_and_Run_Structure.md
    ├── 04_Economy_and_Balancing.md        ← ALL numbers live here
    ├── 05_Booths/00_Booth_Framework.md    ← rules every booth follows
    ├── 05_Booths/01 … 17_*.md             ← one file per booth
    ├── 06_Items.md
    ├── 07_Lot13_Stations.md
    ├── 08_Hub_Matchmaking_Networking.md
    ├── 09_Characters_Avatars_Animation.md
    ├── 10_UI_UX_Spec.md
    ├── 11_Art_Direction_and_Assets.md
    ├── 12_Audio.md
    ├── 13_VFX_and_Game_Feel.md
    ├── 14_Progression_Badges_Retention.md
    ├── 15_Monetization.md
    ├── 16_Anti_Exploit_and_Abuse_Rules.md
    ├── 17_Data_and_Saves.md
    ├── 18_Technical_Architecture.md
    ├── 19_Analytics_and_KPIs.md
    ├── 20_Roblox_Compliance_and_Safety.md
    ├── 21_Roblox_Success_Research.md
    ├── 22_Launch_Marketing_Ads_LiveOps.md
    ├── 23_Build_Roadmap_Milestones.md     ← the order you build things in
    ├── 24_Testing_QA.md
    ├── 25_Original_Game_Reference_Policy.md ← what we take from the original and what we don't
    ├── 26_Glossary.md                     ← exact words for code, UI and docs
    └── 27_Decisions_Log.md                ← where decisions, plans and reports go
```

## 3. Reading order (for the AI developer)
**Pass 1 — understand the game (read fully before writing code):**
1. `AGENTS.md` — hard rules and how to work.
2. `docs/01` — vision, pillars, audience, targets.
3. `docs/02` — lore, tone, forbidden words, characters.
4. `docs/03` — the full run: states, nights, days, endings, disconnects.
5. `docs/04` — every number.
6. `docs/05_Booths/00` — the booth framework (authority patterns A/B/C, lifecycle, item hooks).
7. `docs/26` — glossary (use these names in code).
8. `docs/25` — what we never take from the original.
9. `docs/23` — milestones and gates.
10. `docs/18` — architecture, repo layout, coding standards.

**Pass 2 — read per milestone:** each milestone in `docs/23` lists the files to re-read before starting it. Read them again even if you read them before; details matter.

**Reference anytime:** `docs/16` (anti-exploit) before writing any remote; `docs/17` before touching saves; `docs/15` before touching anything with Robux; `docs/20` before anything players can see publicly (name, thumbnails, chat, text).

## 4. When files disagree
1. `AGENTS.md`
2. `docs/04_Economy_and_Balancing.md` (numbers)
3. The specific system file (e.g., the booth's own file)
4. `docs/03_Core_Loop_and_Run_Structure.md` (flow)
5. Everything else

Fix the lower-priority file to match, and log the fix in `docs/27`.

## 5. The non-negotiables (short version of `AGENTS.md` §2)
- Never touch the installed original game's files. Never copy its names, art, audio, UI, text or code.
- No hidden chance after a player commits; skill decides outcomes.
- The server owns all money and results; clients only send inputs.
- Robux never buys Tickets, Tokens, items or outcomes.
- No hard-coded numbers, IDs or player-facing strings.
- Never publish LIVE, spend Robux, buy things or start ads without the owner's explicit OK.
- Never commit secrets.
- Kid-safe content: no gambling words or imagery, no blood, no horror.

## 6. How the work flows
```
Owner: SETUP_CONNECTIONS.md  →  pastes PROMPT.md into Codex
Agent: reads spec → verifies connections → M0 setup → M1 gray-box loop → STOP (playtest gate)
Owner: playtests with friends → replies "go" or gives notes
Agent: fixes notes → next milestone → STOP at its gate → …
… M10: soft launch (16+), evaluation, all-ages launch, weekly updates, ads once metrics prove out
```
The **M1 gate is the most important moment in the project**: if friends don't laugh, yell about the jar, and ask for one more night with gray boxes, art won't save it. Iterate there.

## 7. What "done" looks like
- A full 12-night run is playable by 1–6 players, with all 17 booths, 16 items, Lot 13 stations, 3 endings and Endless.
- A public hub with crews, Quick Play, friend joins and saves that survive anything.
- Every area passes the "same studio" art test (`docs/11` §4.1) and the game-feel checklist (`docs/13` §6).
- Monetization is fair (`docs/15`), analytics are live (`docs/19`), compliance is done (`docs/20`), and the release checklist (`docs/24` §7) is green.
- Launch follows `docs/22`: closed playtest → 16+ soft launch → all ages → weekly updates → ads when D1 ≥ 13.5% and sessions ≥ 19 min.
