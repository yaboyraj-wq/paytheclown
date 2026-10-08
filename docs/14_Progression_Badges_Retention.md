# 14 — Progression, Badges and Retention

> Roblox ranks games by how well they keep players over 28 days, whether friends play together, and whether players spend (see `21_Roblox_Success_Research.md`). This file defines every system that gives players a reason to come back **today, tomorrow and next week** — built in from the first version, not added later.

## 1. Reasons to return (the retention map)

| Time scale | Hook | System |
| --- | --- | --- |
| Next 5 minutes | "One more night" | 5-minute nights, one-button continue (`03`) |
| Later today | Saved crew, daily first win, daily tasks not finished | Crew saves, Daily Tasks (§3), first-win bonus |
| Tomorrow | Login calendar, new featured costumes, fresh daily tasks | Daily calendar (§2), Thrift Tent rotation (`07` §6) |
| This week | Weekly crew leaderboard reset, Carnival Pass progress, event weekends | Leaderboards (§7), Pass (§5), events (`22`) |
| This month+ | Season pass, new booths/floors, seasonal re-skins, badges | Live ops (`22`), badges (§6) |

## 2. Daily login calendar
- A 7-day "wheel" calendar in the hub (not random; it advances one slice per day you log in).
- Rewards (Stars): Day 1: 20 · Day 2: 30 · Day 3: 40 · Day 4: 50 · Day 5: 60 · Day 6: 80 · Day 7: 150 + a free cosmetic from a rotating "Week 7 gift" list (e.g., a hat). Then repeats.
- Missing a day resets to Day 1 unless the player owns Carnival Club (one free "streak saver" per month).
- Claim pops a celebration; unclaimed reward glows on the hub HUD.

## 3. Daily Tasks (personal)
- 3 tasks per day per player, reset at 00:00 UTC. Shown in the hub and the run HUD menu.
- Pool examples: "Win 5 plays at any booth" (40 Stars), "Survive 2 nights" (50), "Bank a push at 3x+" (50), "Use 2 items" (40), "Play with a friend" (60, needs a Roblox friend in your crew), "Win at Duck Derby" (40), "Pawn something" (30), "Finish a Dare" (60).
- One free reroll per day; Carnival Club gets 2.
- Completing all 3: bonus 50 Stars + 1 Pass tier progress boost.

## 4. Showbiz Level (player level)
- XP from: night survived 100, win 5 each (cap 100/night), dare 150, ending 1,000, daily task 200.
- Levels 1–100 with a smooth curve: `xpForLevel(n) = 250 + 75 × n`.
- Rewards: every level +25 Stars; every 5 levels a **title** for the name tag ("Rookie Roustabout," "Ticket Taker," "Midway Menace," "Ringmaster-in-Training," …); levels 10/25/50/100 give exclusive cosmetics.
- Level shows on the name tag and portrait ring.

## 5. Carnival Pass (season, ~6 weeks)
- 40 tiers. Tier progress from **Pass XP** = Showbiz XP earned during the season.
- **Free track:** Stars (every 2nd tier), 4 cosmetics (hat, emote, jar skin, name tag), a cannon style at tier 40.
- **Premium track (Robux pass per season; price in `15`):** a cosmetic on every tier (costumes, emotes, cannon styles, karaoke songs, jar skins, Mascot Suit color variant), plus +500 Stars spread across tiers. **Nothing that affects booths, Tickets, Tokens or items.**
- Season theme matches the live-ops calendar (e.g., Season 1 "Grand Opening," Season 2 "Haunted Midway").
- Late joiners can catch up: XP needed per tier is flat (no exponential walls); tier skips **are not sold** (keeps it fair and avoids pressure tactics).

## 6. Badges (Roblox badges)
Create badges in Creator Hub (Roblox limits free badge creation per day; check current rules). Award with `BadgeService:AwardBadge` on the server, with retry. Show an in-game toast with the badge art too.

### 6.1 Progress (14)
| Badge | Requirement |
| --- | --- |
| Welcome to the Midway | Finish your first night |
| Act II | Reach Night 4 (Neon Arcade) |
| Act III | Reach Night 7 (Funhouse) |
| Act IV | Reach Night 10 (Big Top) |
| Survivor | Survive Night 12 |
| Paid in Full | Get the Paid in Full ending |
| Ringmasters | Get the Ringmasters ending |
| Part of the Act | Get the Part of the Act ending |
| Hard Hat | Get any ending on Hard |
| Bill Buster | Deposit 250,000 Tickets into the Bill Box in one run |
| Endless 15 / 20 / 25 | Survive Endless Night 15 / 20 / 25 |
| Human Cannonball | Get launched out of the Big Cannon |

### 6.2 Tickets milestones (5) — Tickets won by crews you were part of, lifetime
Pocket Change (10,000) · Big Pockets (1,000,000) · Ticket Tycoon (100,000,000) · Ticket Titan (10,000,000,000) · Carnival Legend (100,000,000,000).
(Mirrors the original's lifetime money milestones; ours count across Endless runs too.)

### 6.3 Booth badges (17)
Bullseye Wheel · Perfect 21 · Royal Quack · Duck Royalty · Home Run · Ten Out of Ten · Gold Splat · Cold Feet · Photographic Memory · To The Moon · Needle Master · Edge Master · Top of the Funhouse · Pie Proof · Four of a Kind · Gutter Genius · Juggle Legend. (Requirements in each booth file §12.)

### 6.4 Social and fun (9)
| Badge | Requirement |
| --- | --- |
| Full House | Play a night in a crew of 6 |
| Best Friends | Survive 10 nights with the same Roblox friend in your crew |
| MVP | Be Night MVP |
| Professional Loser | Be Biggest Loser 5 times |
| Nothing Left to Pawn | Pawn all 3 pieces in one run |
| Duck Hunter | Find Sir Waddles in Lot 13 10 times |
| Gadget Collector | Use every item at least once (lifetime) |
| Shutterbug | Take 10 Snapshot photos of winning teammates |
| Batter Up | Change a Block Toss result with the Foam Bat |

## 7. Leaderboards
- **Weekly Crew Score** (resets Monday 00:00 UTC): best ending score per crew, default rules only, not Assisted. Shows the crew's members.
- **Endless Nights** (weekly + all-time): most nights survived.
- **Lifetime Stars** (all-time).
- Implementation: OrderedDataStore keys per week (e.g., `CrewScore_2026W41`). Show the top 50 in the hub tower and the player's own rank if available. Leaderboard entries include crew name and member userIds (render names client-side).
- Anti-abuse: scores only submitted by Tower servers at an ending; validated against the run's audit log (`16`).

## 8. Collection Book
- A hub/HUD panel showing: badges earned, booths mastered (Bronze/Silver/Gold per booth at 10/50/200 lifetime wins, each tier +100 Stars), items used, cosmetics owned, Sir Waddles finds, photos.
- Completion percentage drives "one more" behavior.

## 9. Notifications (opt-in)
- Use Roblox **Experience Notifications** (opt-in prompt shown only after a player's first successful night — never on first join). Allowed types to use: "Your daily calendar reward is ready," "Your crew [name] is playing — join them!", "New season started." Respect Roblox's limits; never spam.
- Check the current Experience Notifications API and policy in Roblox docs before building.

## 10. Social retention
- Crew saves: friends come back to *their* run.
- Rejoin and friend-join buttons in the hub (`08`).
- "Play with a friend" daily task.
- Share link: an in-game "Invite" button uses Roblox's invite prompt; the experience's share link is used in all marketing (it also feeds Roblox's Audience Expansion rewards; see `15`).

## 11. Cosmetic catalog at launch (≈ 60 items)
| Category | Count | Examples (names are ours) |
| --- | --- | --- |
| Hats | 14 | Ringmaster Top Hat, Popcorn Bucket Hat, Duck Float Hat, Propeller Beanie, Jester Cap, Cotton Candy Wig, Traffic Cone (Penguin Crossing), Pie Tin Hat |
| Costumes | 8 | Ringmaster Suit, Strongman Leotard, Mascot Suit (red/blue/gold), Clown Overalls, Neon Racer Jumpsuit, Funhouse Ghost Sheet (cute) |
| Emotes | 10 | Juggle, Tiny Bow, Duck Waddle Dance, Ticket Rain Dance, Strongman Flex, Facepalm Honk |
| Jar Skins | 8 | Classic Glass, Golden Jar, Neon Jar, Pumpkin Jar, Snow Globe Jar, Duck Jar, Treasure Chest, Piggy Bank |
| Cannon Launch Styles | 8 | Confetti (default), Rocket Trail, Rainbow, Pie Splat, Firework Burst, Duck Floatie, Glitter Bomb, Bubble |
| Name Tag Styles | 6 | Bulb Border, Ticket Stub, Neon, Gold Leaf, Funhouse Wobble, Big Top Banner |
| Karaoke Songs | 6 | Original jingles only |

Jar skin rule: each player's **HUD jar** uses their own equipped skin; the **3D jar props** in the crew's run (Lot 13, floor stands, Closing Count) use the host's equipped skin, so everyone sees the host's choice in the world.
