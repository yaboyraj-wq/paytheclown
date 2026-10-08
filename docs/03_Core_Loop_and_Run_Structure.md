# 03 — Core Loop and Run Structure

> This file defines the exact flow of a run: what happens, in what order, for how long, and what the rules are at every step. Numbers referenced here (quotas, stake caps, payouts) live in `04_Economy_and_Balancing.md`. If a number here ever disagrees with `04`, `04` wins.

## 1. Vocabulary (short version; full list in `26_Glossary.md`)

- **Run** — one save's journey from Night 1 to an ending or a cannon launch.
- **Day** — the planning phase in Lot 13 before each night. Untimed (with an AFK safeguard).
- **Night** — the 5-minute play phase on a tower floor.
- **Jar** — the crew's shared Tickets for this run.
- **Bill** — final payment of the entire jar at Final Choice; presentation awaits M6 redesign. The fixed 1,000,000 Bill is retired.
- **Quota** — the minimum jar balance needed to survive Closing Count; no Tickets are taken.
- **Crew** — the 1–6 players in this run's private server.

## 2. The loop at three zoom levels

| Zoom | Loop | Length |
| --- | --- | --- |
| Moment | Pick a booth → stake → play → result → cheer or groan | 10–40 s |
| Night | Day in Lot 13 → Clown Car → 5-minute night → Closing Count → result | 6–8 min |
| Run | Night 1 → … → Night 12 → Final Choice → Ending (or Cannon at any night) | 30–80 min |
| Meta | Earn Stars → unlock costumes, badges, Carnival Pass tiers, leaderboards, Endless Nights | Days–weeks |

## 3. Run state machine

The server for a run (a reserved server of **The Tower** place) runs exactly one run at a time. Its top-level state is one of:

```
LOADING → DAY → DEPARTING → NIGHT_INTRO → NIGHT → CLOSING → (RESULT_SUCCESS → DAY)
                                                            → (RESULT_FAIL → CANNON → RUN_OVER)
After Night 12 RESULT_SUCCESS → FINAL_CHOICE → (PAY → ENDING) or (SHOWDOWN → ENDING)
ENDING → RUN_OVER (or → DAY of Endless Night 13 if the crew chooses to continue)
```

Every state change is server-authoritative, replicated to all clients through one `RunState` value (see `18_Technical_Architecture.md`). Clients never advance state.

### 3.1 `LOADING` (max 20 s)
- Server loads the crew save (or creates a new run from the chosen rules).
- Players arriving by teleport see the Clown Car teleport screen until their character spawns (see `10_UI_UX_Spec.md`, Loading).
- When all expected players have loaded, or 20 s pass, go to `DAY`. Late arrivals join wherever the state is.

### 3.2 `DAY` (untimed, with safeguards)
What happens:
1. Each player pops out of the **prize crate** (2 s animation, press/tap to skip).
2. A **Day Card** slides in: "Day 4 — Tonight: Neon Arcade — Quota: 3,000" (3 s, then shrinks to the HUD).
3. Players can use the active stations in Lot 13 (`07_Lot13_Stations.md`): Dare Board, Sal's Trailer, Thrift Tent, Pawn Clamp, Bouncy Lot, Crew Trailer. Bill Box deposits are retired; its role awaits M6 redesign.
4. To start the night, players get in the **Clown Car** (walk into the seats or press **READY** on the HUD).

Departure rules:
- **All present players ready** → 5-second countdown → `DEPARTING`.
- **More than half ready** → a 60-second "Car leaves in…" timer starts, shown on everyone's HUD. When it ends → `DEPARTING`.
- **Solo** → departs immediately on READY (with a 3-second countdown).
- **AFK safeguard** → if nobody presses READY for 5 minutes, show "Still there?" to all. After 2 more minutes of no input from anyone, save and return everyone to the hub.
- Players who are not in the car at departure are teleported into it automatically. Nobody is left behind.

### 3.3 `DEPARTING` (8 s, skippable by nobody)
- The Clown Car drives to the tower and enters the lift. This cutscene hides the stream-in of the floor.
- During this time the server spawns tonight's booths (chosen at the start of the Day; see section 5), resets the Foam Bat, and locks the crew size for quota scaling (section 8).

### 3.4 `NIGHT_INTRO` (4 s)
- Players spawn at the floor's lift. Lights flicker on in sequence. Bigsby's voice: a night-start line.
- Big centered countdown "3 – 2 – 1 – OPEN!" with a carnival horn.

### 3.5 `NIGHT` (default 5:00; save rule can set 3:00, 5:00, 7:00 or 10:00)
- Booths are playable. The jar, the quota bar, and the timer are always on screen.
- **Final Call** at 1:00 left: music switches to the fast variant, floor lights pulse, Bigsby line, timer turns red.
- **Last 10 seconds:** a spoken countdown and a ticking sound.
- **At 0:00:** the Closing Bell rings. No new stakes can start. Any booth play already in progress gets a **5-second grace period** to resolve. After that, a play already waiting at PUSH/BANK auto-banks its current value; other unresolved plays lose their stake (framework §2 takes precedence). Then → `CLOSING`.

Special events during `NIGHT`:
- **Bigsby Walks the Floor:** if the jar drops below 50% of tonight's quota at any time after the first 60 seconds, Bigsby appears and walks between booths for 45 seconds, taunting. While he is out, every booth's minimum stake rises by 25% (pressure, not punishment). He leaves early if the jar climbs back above the quota. Max once per night. Pure drama: cannot cause a loss on its own.
- **Floor Event (Nights 4+, once per night, random time between 1:30 and 3:30 elapsed):** one of: "Spotlight Booth" (one random booth pays +25% for 30 s, shown with a spotlight), "Ticket Rain" (for 20 s, 10 glowing ticket bundles drop at random open spots on the floor; touching one adds 1% of tonight's quota to the jar — a scramble that rewards moving fast, max 10% of quota total), "Rush Hour" (all booth rounds are 20% faster for 30 s, payouts +10%). Events must be visible to everyone and announced 3 s ahead. Tune or remove in playtests.

### 3.6 `CLOSING` (about 12 s)
1. Camera cuts to Bigsby at a giant counting machine. He counts the jar without taking any Tickets.
2. The counter compares the settled jar balance with tonight's quota bar.
3. **If jar ≥ quota:** the crew survives and keeps the whole jar. Award the completed floor's base Tokens plus its highest reached surplus-ratio reward, once. Advance the successful-night count and compute the next quota from this retained jar (`04` §§3, 7). Bigsby grumbles. → `RESULT_SUCCESS`.
4. **If jar < quota:** the counter stalls, sirens, Bigsby gasps then grins. → `RESULT_FAIL`.

### 3.7 `RESULT_SUCCESS` (about 15 s, skippable after 3 s by majority vote)
Night summary card (see `10_UI_UX_Spec.md`):
- Quota met, jar kept, Tickets won and lost tonight, best single win (with player name), biggest single loss (with player name), Dare result.
- Awards: **MVP** (most net Tickets won), **Biggest Loser** (most net Tickets lost — funny, with a trombone), **Daredevil** (biggest single push).
- Tokens earned (crew) and Stars earned (personal). See `04`.
- Autosave. → next `DAY` (Night counter +1). After Night 12 → `FINAL_CHOICE`.

### 3.8 `RESULT_FAIL` → `CANNON` (about 15 s, not skippable the first 2 times a player sees it, then skippable)
- Honk loads the whole crew into the Big Cannon (comedy). Slow motion launch over the Ferris wheel. Players ragdoll. Each player's **cannon launch style** cosmetic plays (see `15_Monetization.md`).
- Summary: nights survived, best night, total Tickets won, Stars earned this run (Stars are always kept).
- **Keep the Lights On** offer (see `15_Monetization.md`): once per run, any one crew member may buy one more chance. If bought, tonight's quota is waived, the jar keeps whatever it had (nothing is taken), and the run continues at the next Day. The run is flagged **Assisted** (no leaderboards, no ending badges; endings still play).
- If not bought within 10 s → `RUN_OVER`.

### 3.9 `RUN_OVER`
- The save is marked finished (kept in history; the slot frees up).
- Buttons: **Play Again** (same crew, new run, same rules — creates a new run in the same server), **Back to Gates** (teleport everyone to the hub together). Default after 30 s of no input: Back to Gates.

### 3.10 `FINAL_CHOICE` (after Night 12 succeeds)
- **M6 redesign required:** the fixed lifetime Bill and Bill Box deposits no longer apply. Snapshot the whole jar at Final Choice as the final payment amount. Completing PAY transfers that whole amount and leaves the live jar at zero.
- PAY is available after surviving Night 12; there is no separate remaining-debt affordability test and no forced Showdown caused by one.
- The Center Ring presentation, crew vote, payment interaction and optional Showdown are to be redesigned in M6. No final-choice gameplay ships in M1. This ruling supersedes older Bill-based lore, UI, save fields and ending conditions elsewhere in the spec.

### 3.11 `SHOWDOWN` (about 2 minutes)
- 3 rounds. Each round is one booth from the set the crew played most this run (at least 3 different booths; fill from Floor 4 pool if needed), at **Showdown difficulty** (see each booth file).
- Before each round the crew picks a **Performer** by tapping their portrait (most votes; tie → least recently performed; solo → the player). Each player can perform at most 2 rounds if the crew has 2+ players.
- A round is won if the Performer reaches the booth's Showdown target (defined per booth).
- **Win 2 of 3 rounds** → `RINGMASTERS` ending. Otherwise → `PART_OF_THE_ACT` ending.
- Items cannot be used in the Showdown. The Foam Bat is not available. Pure skill.
- **M6 redesign:** Showdown stakes and scoring must account for the whole-jar final payment. The old optional-versus-forced Bill branches are retired; do not implement them.

### 3.12 `ENDING`
- Ending cutscene (see `02`), ending badge, Stars bonus (see `04`), crew photo moment (a posed group shot players can screenshot).
- **M6 redesign:** define ending score and Endless starting balance separately from the live jar, which PAY empties. Leaderboard eligibility still requires an unassisted default-rule run (section 9).
- Options: **Endless Nights** (continue this run from Night 13 with quotas continuing to grow; see section 10), **Play Again**, **Back to Gates**.

## 4. Floors and night schedule

| Nights | Floor | Notes |
| --- | --- | --- |
| 1–3 | F1 The Midway | Night 1 is the tutorial night for new players (section 11). |
| 4–6 | F2 Neon Arcade | New booths appear. Floor intro cutscene plays the first time. |
| 7–9 | F3 Funhouse of Mirrors | New booths appear. Mild spooky ambience. |
| 10–12 | F4 The Big Top | Biggest stakes and quotas. |
| 13+ | Endless: rotates F2 → F3 → F4 → F4… | Only after an ending. |

Each new floor plays a 6-second "Act" intro the first time a crew reaches it in a run ("ACT II: NEON ARCADE!"), skippable.

## 5. Booth spawning per night

- Each floor has **7 booth pads** (Floor 1 has 5, so its 6 booths rotate). A pad is a fixed spot in the level art.
- At the **start of each Day**, the server chooses tonight's booths (so the Day Card and Dare Board can show them) and spawns them at `DEPARTING`. It fills pads from the **booth pool** for that floor (booth pools in `04`, section 6) using a seeded random generator (`Random.new(runSeed + nightNumber)`), with these rules:
  1. At least 3 booths are from the current floor's **new** booths (if the floor has fewer new booths, use all of them).
  2. No duplicate booths on the same night.
  3. At least one **physical** booth (Hoop Wheel, Block Toss, Pinball Drop, Splat Wheel, Bowl to Nine) per night.
  4. A booth that appeared on all of the last 2 nights is skipped if any alternative exists (variety).
  5. If tonight's Dare requires a specific booth, that booth is guaranteed to spawn (see Dares in `07`).
- The seed is saved with the run so reloading a save gives the same booths for the same night. Rerolling the night is not allowed.

## 6. Who can do what during a night

- Any crew member can use any free booth.
- A booth is used by one **Controller** at a time, except booths marked "multi-seat" (Duck Derby up to 4, Big Top Juggle up to 3).
- Watching: any number of players can stand in a booth's **watch zone** to get the close-up camera option and see the rule card.
- **Claiming a booth:** walk onto the booth's control pad (or tap the booth's "PLAY" prompt). The booth is claimed until the play resolves or the Controller walks away for 5 s before staking.
- A player can be the Controller at only one booth at a time.

## 7. Stake rules (apply to every booth)

### 7.1 Basics
- Stake is chosen on the booth's **stake keypad** UI (big buttons: −, +, MIN, ½ JAR-CAP, MAX, and quick chips).
- Stake must be between the booth's **min stake** and **max stake** for the floor (see `04`), and never more than the current jar.
- The stake is removed from the jar the moment the play starts ("locked"). Everyone sees it fly from the jar to the booth.
- Payout is added to the jar when the result is decided. Payout = stake × multiplier (rounded down to whole Tickets). A multiplier of 0 means the stake is lost.

### 7.2 Big stakes and approval
- A stake is **Big** if it is more than 30% of the jar *and* more than 10 × the floor's minimum stake.
- When a Big stake is about to lock, every other crew member gets a 5-second **heads-up toast**: "[Name] is staking 40% of the jar at Rocket Ride!" with **Approve** and **No way** buttons.
- **If Big-Stake Approval is ON** (save rule; default ON for Public/Quick Play crews, OFF for Friends/Invite crews): the stake is blocked only if more than half of the *responding* teammates press **No way**. Silence counts as approval. This stops a single griefer from vetoing everything and stops a single griefer from draining the jar unchallenged.
- **If OFF:** the toast still appears (drama), but nothing can block the stake.
- Blocked stakes show a funny "Crew said NO WAY" animation; the Controller can lower the stake and try again. A player who gets 3 blocks in one night gets a 30-second cooldown on Big stakes.

### 7.3 New-player protection (anti-grief in public crews)
- A player who joined this run through Quick Play and has played fewer than 1 full night in this run is a **Rookie**. Rookies cannot stake more than 10% of the jar per play.
- Friends/Invite crews do not have this limit.

### 7.4 Pushes (streak booths)
- Some booths allow **Push** (keep going for a higher multiplier) or **Bank** (cash out now). Each booth file defines its ladder.
- Pushing never requires approval (the stake was already approved). The heads-up toast reappears when a push would put more than 30% of the jar at risk.

### 7.5 The jar can't go below zero
- The jar can never be negative. Stakes larger than the jar are impossible.

## 8. Quota rules

- Tonight's quota is set at `DEPARTING` and never changes during the night.
- Starting quota is 1,200 times difficulty and crew multiplier, rounded to two significant digits. Each success moves the quota 75% toward the retained closing jar, then applies the next study multiplier and difficulty before rounding (`04` §3).
- Keep the pending next quota anchored to the prior departure's crew size. At the next departure rescale it once by the new/prior crew multiplier ratio; Day shows this provisional value. A constant-size crew gets no extra compounding crew factor.
- Players who join mid-night do not change tonight's quota.
- Quota is checked only at `CLOSING`. Passing keeps every Ticket and awards Tokens once; failure awards none. Neither quota payments nor Day Bill deposits exist.

## 9. Save rules (per-run settings, locked at creation)

Mirrors the original game's per-save rules. Chosen in the **New Crew** menu, locked when the run is created, and shown in the Crew Trailer.

| Rule | Options | Default |
| --- | --- | --- |
| Night length | 3:00 / 5:00 / 7:00 / 10:00 | 5:00 |
| Difficulty | Normal / Hard / Extreme (×1 / ×1.5 / ×2) | Normal |
| Starting jar | 500 / 1,000 / 2,500 | 1,000 |
| Starting Tokens | 0 / 5 / 10 | 5 |
| Big-Stake Approval | On / Off | On for Public, Off for Friends/Invite |
| Privacy | Friends / Invite only / Public | Friends |

**Leaderboard eligibility:** only runs with all defaults (5:00, Normal, 1,000 jar, 5 Tokens) and not Assisted. Endless Nights has its own leaderboard (nights survived).

Solo uses the 0.65 crew factor. The retired Easy quota difficulty is not offered.

## 10. Endless Nights

- Unlocked per save after any ending.
- Night 13 onward. Floors rotate F2 → F3 → F4 → F4 → F2 … (see `04` for the quota formula beyond Night 12).
- No more endings. When the crew misses a quota, the cannon plays and the run ends; the score is **nights survived** (tie-break: jar at last success).
- Stars per night in Endless are listed in `04`.

## 11. First-time player flow inside the run (tutorial night)

A player is "new" if their profile has `tutorialDone = false`.

- If a new player is in the crew, Night 1 gets **tutorial mode** for that player only (other players see nothing different except that Honk follows the new player):
  - In Lot 13, Honk walks to the new player and points to Sal ("Grab something!") — skippable.
  - The new player gets a **free Do-Over Balloon** item once (tutorial gift).
  - On the floor, the first booth they approach shows its rule card for 4 s instead of 2 s, and the stake keypad pre-selects the minimum.
  - Their first play on Night 1 is at **Easy Assist** (wider target windows by 25%, documented per booth) — this guarantees an early win for almost everyone.
- After the player finishes Night 1 (success or fail), set `tutorialDone = true`.
- No text walls. Each tip is one sentence with an arrow.

## 12. Disconnects, joins and leaves mid-run

| Situation | Rule |
| --- | --- |
| Player disconnects during a night | Their active booth play resolves as if they stopped input (a push stops at the last banked step if possible; otherwise loss of stake). Their held item drops at their position and stays usable by teammates. |
| Player rejoins within the same run | Hub shows **Rejoin your crew** for as long as the run server is alive. They spawn at the floor lift (night) or the crate (day). Their pawned pieces and item state are restored. |
| New player joins mid-run (friend joins, or Quick Play fills an open seat) | Allowed during `DAY` and during `NIGHT` (spawns at the lift). Max 6 total. Quota is not recalculated until the next `DEPARTING`. |
| Host leaves | The run continues. The save stays owned by the original host and is written to their save slot by the server. A new **acting host** (longest-present player) gets host-only buttons (Play Again, rules display). |
| Everyone leaves | The server saves at the last completed state (if mid-night, the night in progress is lost and replays from its Day using the departure checkpoint). |
| Server shutdown (update) | On `game:BindToClose`, save immediately; players get "Midway closing for an update — your crew is saved." |

**Anti-abuse — quitting to dodge the cannon:** if everyone leaves during `NIGHT` or `CLOSING`, the save restarts that Night's Day with the jar and Tokens restored to their values **at departure** (the `DEPARTING` checkpoint; Day purchases stay made). Players can't keep winnings from a night they quit, and quitting can't undo losses. This also stops "save scumming" of individual plays (see `16_Anti_Exploit_and_Abuse_Rules.md`, `17_Data_and_Saves.md`).

## 13. Timeline of one typical night (5:00 rules)

| Time | What happens |
| --- | --- |
| Day, 0:00–1:30 | Crate pop, Day Card, crew checks Dare Board, buys 1–2 items, maybe pawns, gets in the car |
| +0:00–0:08 | Clown Car cutscene |
| +0:08–0:12 | Night intro countdown |
| +0:12–5:12 | Night: booths, items, pushes, big-stake toasts, Bigsby may walk the floor, one floor event |
| 4:12 | Final Call (1:00 left) |
| 5:12–5:17 | Closing Bell grace period |
| 5:17–5:29 | Closing Count |
| 5:29–5:44 | Night summary or Cannon |
| Total | About 7–8 minutes per night |
