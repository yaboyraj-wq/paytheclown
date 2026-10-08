# 01 — Vision and Pillars

> Read this file first after `00_START_HERE.md`. Every decision in every other file must serve the pillars below. If a feature fights a pillar, the pillar wins.

## 1. The game in one sentence

**Pay the Clown!** is a 1–6 player co-op carnival crawler on Roblox: your crew shares one jar of Tickets and one giant debt to a greedy clown, and every night you have 5 minutes to win enough Tickets at skill booths to pay his quota — or get fired out of a cannon.

## 2. The game in one paragraph

Your crew broke Bigsby the Clown's prized Grand Balloon and now owes him 1,000,000 Tickets. You live in his trailer park, Lot 13. Every day you plan, shop for sketchy gadgets, and maybe pawn your shoes for quick cash. Every night you ride the Clown Car up a four-floor carnival tower and play skill booths — throwing, timing, memory, nerve — staking Tickets from one shared jar that everyone can see and everyone can spend. At closing time Bigsby takes his nightly quota. Miss it and the whole crew gets launched out of the Big Cannon. Survive 12 nights and you face the final choice: pay the bill and go home, or risk everything in the Showdown.

## 3. Where this comes from

This game is a Roblox-native, kid-friendly reinvention of **Gamble With Your Friends** (TEAM GWYF / TENSTACK, Steam, May 2026). That game sold over 2 million copies in its first weeks. We keep its *structure* (shared bank, shared debt, timed days, rising quota, lobby shop, challenges, body-part economy, four floors, items, three endings). We replace *everything expressive* (names, art, world, characters, story) and we replace every *game of chance* with a *game of skill*, because Roblox only allows gambling content that cannot actually be played. See `25_Original_Game_Reference_Policy.md` for exactly what we keep and what we do not.

## 4. Target audience

| Segment | Age | What they want | How we serve them |
| --- | --- | --- | --- |
| Core | 9–15 (Roblox Select) | Play with friends, laugh, show off, feel clever | Shared jar drama, funny failures, costumes, quick nights |
| Secondary | 16+ (standard Roblox) | Same as above, plus mastery and leaderboards | Hard mode, Endless Nights, weekly crew leaderboards |
| Youngest | 5–8 (Roblox Kids) | Simple, bright, safe | Readable booths, no text walls, Minimal/Mild rating |

**Important launch fact (2026):** a new game is first shown only to age-checked 16+ players during its evaluation trial. It must reach 250 unique plays from highly engaged age-checked players within 60 days before Roblox opens it to Kids and Select accounts (under 16). So the first audience will be teens and adults. The game must be fun for a 17-year-old, not just a 10-year-old. See `20_Roblox_Compliance_and_Safety.md`.

## 5. The five pillars

### Pillar 1 — One jar, one crew, one fate
Every Ticket belongs to everyone. Every stake is visible to everyone. The fun is the social pressure: cheering a friend's big win, groaning at a friend's big loss, yelling "DON'T DO IT" at a friend about to push a 4x streak. **Rule of thumb:** if a feature lets a player ignore their crew, it is wrong.

### Pillar 2 — Skill, not chance
No outcome is decided by a hidden random roll after the player commits. Randomness is allowed only in setup that the player can see before staking (a target's position, a gem layout shown for 2 seconds, which booths appear tonight). Everything after the stake is decided by player input and fixed physics. This keeps us inside Roblox's rules and makes losses feel like *your* fault in a funny way, which keeps players coming back to get better.

### Pillar 3 — Every failure is a joke
Losses are slapstick: sad trombones, pie splats, deflating balloons, and the Big Cannon. Nothing in this game ever makes a player feel stupid or punished for real. A missed quota is the funniest moment of the run, not the saddest.

### Pillar 4 — Five-minute nights, one-more-night loop
Each night is 5 minutes of play plus about 1–2 minutes of planning. A run is up to 12 nights (about 60–80 minutes if the crew survives). Every night ends with a clear result and a one-button path to the next night. Players can stop after any night and continue later from a save.

### Pillar 5 — Looks like thousands of dollars were spent
Cohesive art, juicy feedback on every action, clean mobile-first UI, and sound on everything. One consistent style across every asset. See `11_Art_Direction_and_Assets.md`, `10_UI_UX_Spec.md`, `12_Audio.md`, `13_VFX_and_Game_Feel.md`.

## 6. Experience goals (how a player should feel)

| Moment | Feeling | How we get it |
| --- | --- | --- |
| Pressing Play | "I'm in with my friends right away" | Crew formed and running in under 60 seconds |
| First booth | "Oh, I get it, and I'm good at it" | First booth on Night 1 is forgiving; Honk shows the rule in one card |
| A friend stakes big | "NO NO NO… YESSS" | Big-stake heads-up on every screen, camera and music build-up |
| Last 60 seconds | Panic and laughter | Music speeds up, lights flash, Bigsby's voice counts down |
| Missing quota | Laughing out loud | The Big Cannon slow-motion launch over the Ferris wheel |
| Surviving Night 12 | "We actually did it" | The final choice, crowd, fireworks |
| Logging off | "Tomorrow we beat Night 9" | Saved crew, daily dares, Stars progress, leaderboard |

## 7. What success looks like (targets)

These are design targets for the first public version. See `19_Analytics_and_KPIs.md` for how they are measured.

| Metric | Target | Why |
| --- | --- | --- |
| Average session length | 19+ minutes | Roblox games with 19+ minute sessions sit in the "hit" tier of the GameAnalytics 2025 benchmark |
| Day-1 retention | 13.5%+ | Top quarter of 19–24 minute games in the same benchmark |
| Day-7 retention | 2.8%+ | Top quarter of the same tier |
| Sessions per user per day | 2+ | Median for hit-tier games |
| Share of sessions with 2+ friends in a crew | 50%+ | Co-play is a named Roblox discovery signal |
| New players in a crew within 60 seconds | 90%+ | Players who don't find the fun in the first two minutes leave |

## 8. What this game is NOT

- Not a casino. No cards-and-chips casino theme, no slot imagery as gambling, no "bet" wording in the UI (we use "stake", "push", "bank", "cash out").
- Not pay-to-win. Robux never buys Tickets, Tokens, items, or booth results. See `15_Monetization.md`.
- Not horror. The Funhouse floor is spooky-silly at most.
- Not a copy. No names, art, audio, code, UI layouts or characters from Gamble With Your Friends.
- Not a solo game that tolerates friends. It is a friends game that tolerates solo.

## 9. Glossary pointer

All game terms (Jar, Bill, Quota, Night, Day, Crew, Booth, Stake, Push, Bank, Tokens, Stars, Pawn, Dare) are defined in `26_Glossary.md`. Use those exact words in code, UI and docs.
