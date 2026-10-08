# 25 — Original Game Reference Policy (what we take, what we don't, and how to use the original legally)

> Pay the Clown! is inspired by Gamble With Your Friends (TEAM GWYF / TENSTACK). We may follow its **ideas and structure**. We may not copy its **expression**: code, art, models, textures, animations, audio, UI, text, names, characters, logo, or world. This file is binding for the AI agent.

## 1. The rule for the installed game on the user's PC

**The AI agent must never open, read, search, decompile, extract, or copy anything from the installed Gamble With Your Friends folder** (or any other game's files), even "just for inspiration."

Why:
1. **The Steam Subscriber Agreement prohibits it.** It says subscribers may not copy, reproduce, reverse engineer, derive source code from, modify, disassemble, decompile, or create derivative works based on Steam content without Valve's written consent. Games' own EULAs usually say the same.
2. **Copyright risk.** Code, models, textures, sounds and animations are protected expression. Even "rewriting" extracted code or tracing extracted assets can create a derivative work. If the original's makers found their code structure or assets in our game, the game could be taken down and the account put at risk.
3. **We don't need it.** The game's rules are publicly documented in guides and the store page (that's what this spec is built from), and Roblox's engine works completely differently from the original's engine anyway — its code wouldn't transfer.

Put this line in the agent's instructions (it is in `AGENTS.md`): *Do not access the Gamble With Your Friends installation or any third-party game files.*

## 2. How the user CAN use the original (legally and usefully)
- **Play it** with friends and notice what feels good: pacing, tension, how fast decisions happen, what makes people laugh.
- **Record your own gameplay sessions** for personal study, and write **your own notes in your own words** in `reference/FEEL_NOTES.md` (e.g., "the shared money number is always visible and moves fast — that's where the tension comes from"; "the day timer felt about right at 5 minutes"; "everyone screams when someone goes all-in").
- The agent may read `reference/FEEL_NOTES.md` and the user's **written** observations. The agent should **not** be given screenshots or video of the original to imitate visually (risk of copying UI layouts and art). Feel notes in words are enough.
- Public guides and the store page (already summarized in this spec) are fine as sources of *rules and facts*, never as sources of text to paste.

## 3. What we take vs. what we change (complete table)

| Element | Original game | Pay the Clown! | Relationship |
| --- | --- | --- | --- |
| Core concept | Co-op "casino crawler," shared bank, shared debt | Co-op carnival crawler, shared jar, shared bill | **Idea kept**, expression new |
| Players | 1–6, friends-only Steam invites | 1–6, Roblox crews (friends, invites, Quick Play, parties) | Kept + adapted |
| Day length | 5-minute days, adjustable per save | 5-minute nights, adjustable per save | Kept |
| Quota | Daily quota to the loan shark | Nightly quota to Bigsby | Kept, re-themed |
| Failure | Punishment scene, run ends | Big Cannon launch, run ends | Idea kept, new scene |
| Floors | 4 themed casino floors, randomized games | 4 themed carnival floors, randomized booths | Kept, new themes |
| Games | 16–17 games of chance | 17 **skill** booths, each mapping one original game's risk shape | **Mechanics changed** (chance → skill) |
| Items | 15+ items bought with tickets | 16 items bought with Tokens; same jobs, our designs | Functions mirrored, effects re-designed, all names/art new |
| Item costs | 3–8 tickets | 3–8 Tokens | Starting balance numbers kept |
| Body parts | Sell eyes/mouth/legs at the Body Shredder | Pawn Shades/Voice Box/Shoes at the Pawn Clamp (slapstick penalties) | Idea kept, kid-safe re-design |
| Quota Gun | Shoots off body parts for 33% of quota | Pawn Popper, consensual, 33% of quota | Mirrored with consent rule |
| Baseball bat | Bat by the elevator; carry it in; hit a craps die to nudge it to a number | Foam Bat on each floor's lift; a teammate bonks one block one face during a 1.5 s window after it settles; also works at 7 other booths with our own rules | **Similar purpose, our own implementation and limits** — not the same mechanic code or animation |
| Time Machine | Rolls back time (reported up to 60 s) | Rewind Remote: 45 s (60 s Hyped), only when all booths idle | Idea kept, our rules |
| Loan-shark challenges | Accept before play; rerolls cost | Honk's Dare Board, same flow | Kept, our dares and names |
| Shop rerolls | First reroll 2 tickets, rising | First reroll 2 Tokens, rising | Kept |
| Cosmetics | Secondhand store; host-owned | Gert's Thrift Tent; **player-owned** | Changed (better for Roblox) |
| Spawn | Cardboard box, press E | Prize crate pops | Idea kept, new |
| Transport | Elevator/limo | Clown Car + tower lift | New |
| Endings | Pay off debt / double-or-nothing coin flip (win or lose) | Pay the Clown / Showdown skill challenge (win or lose) | Structure kept, coin flip replaced by skill |
| Endless | Endless Mode after V1.0.30 | Endless Nights after any ending | Kept |
| Save rules | Timer, difficulty, starting money/tickets per save | Same four + approval + privacy | Kept + extended |
| Achievements | 55 Steam achievements | ~45 Roblox badges with our names and conditions | Patterns (floor goals, streaks, money milestones, joke losses) kept; names/conditions ours |
| Characters | Loan shark/boss (Jeff Booth's Paradise), vendors | Bigsby, Honk, Sal, Gert, Pawn Clamp, Sir Waddles | **All new** |
| Player bodies | Blob mascot characters | Players' own Roblox avatars | **Not taken** |
| Animations | Theirs | All authored by us | **Not taken** |
| Item effects/VFX | Theirs | All authored by us | **Not taken** |
| UI layout and art | Theirs | Our Carnival Poster kit | **Not taken** |
| Audio/music | Theirs | Licensed Roblox library / commercially licensed AI audio / original | **Not taken** |
| Logo, name, setting | "Gamble With Your Friends," "Jeff Booth's Paradise," casino tower | "Pay the Clown!," Bigsby's Midnight Midway, carnival tower | **Not taken** |
| Text, tooltips, descriptions | Theirs | All written fresh | **Not taken** |
| Code | Theirs (different engine) | Written from scratch in Luau | **Not taken** |

## 4. Additions that are ours (not in the original)
Bill Box, Crew Trailer, kick votes and anti-grief rules, Big-stake approval, quick-chat wheel, Showdown skill rounds, floor events, Bigsby Walks the Floor, Sir Waddles, Easy Assist tutorial, Carnival Pass, daily systems, crew saves owned by host but cosmetics owned by players, Foam Bat uses beyond Block Toss, Big Top Juggle booth, Hype Battery item rules, Fix-It Wrench design.

## 5. Ownership records (AI-made content)
In the U.S., content generated purely by AI from a prompt isn't copyrightable; human selection, arrangement and modification can be. Keep `art/ASSET_LOG.md` and `docs/27_Decisions_Log.md` up to date with the human creative decisions (what was chosen, rejected, edited, and why). This is general information, not legal advice; talk to a lawyer before taking investment or if the game earns significant money.
