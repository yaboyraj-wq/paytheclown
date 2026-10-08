# 27 — Decisions Log

> The agent and the user record every important decision, tuning change, deviation from the spec, and milestone report here, newest at the top. Format:
>
> `YYYY-MM-DD — [Area] Decision — Why — Files changed — Who decided`

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
