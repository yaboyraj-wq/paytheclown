# 07 — Lot 13: Every Station and the Daytime Systems

> Lot 13 is the crew's base during each Day (see `03` §3.2). It mirrors the original game's lobby station for station: spawn box → prize crate, loan-shark terminal → Dare Board, item trailer → Sal's Snack Trailer, secondhand store → Gert's Thrift Tent, Body Shredder → Pawn Clamp, playground → Bouncy Lot, elevator/limo → Clown Car, bat by the elevator → Foam Bat (on each floor). Plus two additions: the Bill Box and the Crew Trailer.

## 1. Layout (compact on purpose)

Everything must be reachable within about 8 seconds of walking from the crate. Top-down plan (north = toward the tower):

```
                 [ TOWER LIFT + CLOWN CAR ]
   [ CREW TRAILER ]      [ DARE BOARD ]      [ BIGSBY'S OFFICE + BILL BOX ]
   [ GERT'S THRIFT TENT ]   (PRIZE CRATE)    [ SAL'S SNACK TRAILER ]
   [ BOUNCY LOT ]                            [ PAWN CLAMP ]
```

- Sunset lighting, string lights, warm color grade. Distant tower glowing.
- Ground: packed dirt paths, gravel, patches of grass, tire swings, junk props (old carousel horse, broken signs).
- Every station has a big readable sign and a floating icon visible from the crate.

## 2. Prize crate (spawn)
- Each player spawns inside a big wooden prize crate stamped "RETURN TO SENDER" at the start of each Day and when joining mid-Day.
- The crate lid pops after 1.2 s automatically (or immediately when the player presses any key/taps). Confetti puff, "boing" sound, player jumps out.
- Purpose: the funny daily ritual (original: everyone spawns in a cardboard box).

## 3. Day Card
- 3-second center card on Day start: **Day N · Tonight: [Floor] · Quota: [amount] · Tonight's booths: [7 small icons]**. Then shrinks into the HUD's top bar.
- Tonight's booths are chosen at Day start (seeded; see `03` §5) so dares and shopping can be planned. They spawn physically at departure.

## 4. Honk's Dare Board (replaces the Loan Shark terminal)

### 4.1 What it is
A big corkboard with three paper dares pinned on it and Honk standing beside it with a rubber stamp.

### 4.2 Rules
1. Each Day the board shows **3 dares**: one Easy, one Medium, one Hard (pool in §4.4).
2. Dares are drawn only from dares that are possible **tonight** (their booth is in tonight's booth list).
3. **Any crew member can accept one dare per Day** for the whole crew. Accepted dare gets Honk's big "ACCEPTED" stamp; everyone gets a toast. The accepted dare shows on the HUD during the night with progress.
4. A dare counts only if accepted **before the Clown Car departs** (same as the original's challenges).
5. **Reroll:** replaces all 3 dares. Cost 1 Token, then +1 for each further reroll that Day.
6. Completing the dare pays the crew Tokens (Easy 3 / Medium 5 / Hard 8) and every crew member present +15 Stars, shown at the night summary and as a mid-night toast when completed.
7. Dares that are jokes about losing (e.g., "lose 4 in a row") still pay only if the crew meets tonight's quota.

### 4.3 Public crew rule
In Public/Quick Play crews, accepting a dare requires a 5-second crew vote (majority of responders; silence = yes). Friends crews: instant.

### 4.4 Dare pool
| Dare | Difficulty | Requirement | Booth |
| --- | --- | --- | --- |
| Big Spender | Easy | Crew stakes a total of 10× the floor max tonight | any |
| High Roller | Easy | Someone stakes the floor max (without Zap) | any |
| Team Effort | Easy | Every crew member wins at least 1 play (crews of 2+) | any |
| Lucky Streak | Easy | One player wins 3 plays in a row | any |
| Red Hot | Easy | Win COLOR 3 times | Hoop Wheel |
| Popcorn Party | Easy | Get 3 of a kind | Stop-the-Reels |
| Lucky 7 | Easy | Roll 7 on an opening toss | Block Toss |
| Hot Streak | Medium | One player wins 5 plays in a row | any |
| Overachiever | Medium | End the night with jar ≥ 2× quota (before paying) | any |
| Item Party | Medium | Use 3 different items tonight | any |
| Lucky Number | Medium | Win a NUMBER throw | Hoop Wheel |
| Risky Move | Medium | Win with a total under 10 | Ring Stack 21 |
| Waddle On! | Medium | Win with Sir Waddles | Duck Derby |
| Natural Roller | Medium | Win during the Point Phase | Block Toss |
| Batter Up | Medium | Win after a Foam Bat bonk | Block Toss |
| Spin The Wheel | Medium | Win 3 spins with stakes ≥ 25% of max | Strongman Spinner |
| Winner Winner Penguin Dinner | Medium | Bank ≥ 3x twice in a row | Penguin Crossing |
| Spot On | Medium | Stake a total of 5× floor max | Gem Recall |
| Safe Exit | Medium | Eject successfully 4 times in a row | Rocket Ride |
| Roll the Odds | Medium | Bank ≥ 5x | Hi-Lo Meter |
| Straight Down | Medium | Lose 7 drops in a row | Pinball Drop |
| Step Into Fire | Medium | Lose 4 climbs in a row | Funhouse Ladder |
| Poker Face | Medium | Win Two pair+ without locking in round 1 | Card Catch |
| Nine Lives | Medium | Get a Natural 9 | Bowl to Nine |
| No Bust Run | Hard | Win 4 rounds in a row | Ring Stack 21 |
| Waddle Jackpot | Hard | Get 3 Sir Waddles | Stop-the-Reels |
| Unstoppable Quack | Hard | Win 2 races in a row | Duck Derby |
| Keep It Spinning | Hard | Stake a total of 10× floor max | Strongman Spinner |
| Spin Streak | Hard | Win 3 in a row with stakes ≥ 25% of max | Splat Wheel |
| Traffic Monster | Hard | Bank ≥ 4.8x | Penguin Crossing |
| Marked to Win | Hard | Win ≥ 10x | Gem Recall |
| Greed Test | Hard | Eject at ≥ 10x | Rocket Ride |
| No Safe Rolls | Hard | Bank ≥ 10x | Hi-Lo Meter |
| Clean Fall | Hard | Land 24x | Pinball Drop |
| Flameproof | Hard | Bank ≥ 3x three times in a row | Funhouse Ladder |
| Perfect Sweep | Hard | Bank ≥ 20x | Pie Sweeper |
| No Detonations | Hard | Bank ≥ 5x three times in a row | Pie Sweeper |
| Three-Ring Circus | Hard | Bank ≥ 3.3x with 3 jugglers | Big Top Juggle |

Dare names are ours. Several mirror the *ideas* of the original's achievements (streaks, multipliers, deliberate losses), which are common game-design patterns, not copied text.

## 5. Slick Sal's Snack Trailer (item shop)

### 5.1 Look
A dented food trailer with a pull-down awning, menu board, gadgets hanging inside like snacks. Sal leans on the counter. The **counter** doubles as the crew stash (up to 6 items displayed with buyer name tags).

### 5.2 Shop UI
- Opens when a player walks up and presses E/taps (also from the HUD "Shop" button while within 15 studs).
- Shows 6 offer cards: big icon, name, one-line effect, cost in Tokens, and a "Hyped:" line in small text.
- Crew Token wallet is shown at the top.
- Buttons: **BUY**, **REROLL (n Tokens)**, close.
- Buying: card flies to the counter; crew toast "[Name] bought a Zap Wand (−4 Tokens)".
- In Public crews, purchases costing more than 50% of the wallet require a crew vote (5 s, silence = yes).

### 5.3 Stock rules
See `04` §9.1 (6 offers, weights, no more than 2 duplicates, seeded). Stock refreshes each Day.

### 5.4 Sal's barks (play one when someone opens the shop, max once per 20 s per player)
"Zap it before the Golden Ticket, kid!" · "Gnome next to the blocks? Smart." · "Bubble Wrap's for scaredy-cats. I sell lots." · "Reroll? Costs ya." · "Everything's legal. Mostly."

## 6. Grandma Gert's Thrift Tent (cosmetics)

### 6.1 Look
A striped tent full of costume racks, a big three-way mirror, hat stands. Gert knits in a rocking chair.

### 6.2 Function
- The **cosmetics shop and wardrobe**. Same store as the one in the hub (one catalog, two entrances).
- Categories: Hats, Costumes, Emotes, Jar Skins, Cannon Launch Styles, Name Tags, Karaoke Songs.
- **Try-on mirror:** previews the item on your avatar before buying (camera moves to the mirror).
- Prices in **Stars** (some also directly purchasable with Robux; see `15`).
- **Rotating Featured Rack:** 4 items that change daily (UTC midnight), plus an event rack during events.
- Owned items are equipped from the **Wardrobe** tab here or in the hub.
- Cosmetics belong to **each player** (permanent), unlike the original where cosmetics were tied to the host.

## 7. The Pawn Clamp (replaces the Body Shredder)

### 7.1 Look
A tall, rusty robot pawn machine with a glass display window, one big googly eye, flashing bulbs, and a giant grabbing clamp. Pawned items hang in its window with tags ("SHOES — CREW: BLUE SASH").

### 7.2 Pieces you can pawn (each once per run)
| Piece | Tokens paid | Penalty for the rest of the run | Buy-back |
| --- | --- | --- | --- |
| **Shades** | 8 | "Smudged vision": a soft dark smudge vignette over about 25% of the 3D view (fixed shape per player), plus a blurry spot in one corner. **HUD and UI stay fully readable.** | 12 Tokens |
| **Voice Box** | 6 | "Honk mode": your text chat shows to others as "HONK! HONK!" bubbles, your voice chat (if any) is muted in this experience, and your quick-chat lines appear as icons with a honk sound (icons still communicate meaning). | 9 Tokens |
| **Shoes** | 10 | "Clown clogs": walk speed 16 → 10, jump disabled, slight slide when stopping, squeaky footsteps. | 15 Tokens |

These mirror the original's three body parts (eyes → vision, mouth → voice, legs → movement) with slapstick, kid-safe versions.

### 7.3 Rules
1. Pawning is **self-only** at the Clamp, during Day only. Confirmation dialog: "Pawn your Shoes? You'll waddle all run. +10 Tokens" with **Pawn it** / **Keep them**.
2. Tokens go to the crew wallet.
3. A piece popped by a Pawn Popper counts as pawned (no Tokens; the Popper pays Tickets instead).
4. **Buy-back** at the Clamp with crew Tokens restores the piece and removes the penalty. Bought-back pieces can't be pawned again this run.
5. Penalties persist through disconnects and rejoins for the run (stored per UserId in the run save).
6. Penalties end when the run ends.
7. Safety: Honk mode never blocks Roblox's own report/block menu, and never hides system messages.

### 7.4 Implementation notes
- Shades: a client-side ScreenGui image overlay (behind the HUD layer) with a per-player seeded shape.
- Voice Box: use `TextChatService.OnIncomingMessage` on each client to replace that speaker's displayed text with "HONK! HONK!"; mute voice through the audio API (`AudioDeviceInput.Muted` for that player, set by the server — verify the current API in Roblox docs before building).
- Shoes: set `Humanoid.WalkSpeed = 10`, `JumpPower/JumpHeight = 0`, custom footstep sounds; restore on buy-back.

## 8. The Bill Box (our addition)

### 8.1 Look
A big padlocked steel box shaped like Bigsby's head, outside Bigsby's office trailer, with a slot in its mouth and a giant progress thermometer showing **Bill remaining**.

### 8.2 Rules
1. Any crew member can deposit Tickets from the jar into the Bill Box during a Day. Minimum 100.
2. Deposits **permanently** reduce the Bill. They can never be withdrawn.
3. **Guard:** a deposit can never take the jar below tonight's quota. (Prevents a griefer from making the night impossible.)
4. In Public crews, a deposit larger than 25% of the jar needs a crew vote (5 s, silence = yes).
5. Every deposit shows a crew toast and Bigsby laughs.
6. At the Final Choice, the crew compares the jar to the **remaining** Bill.

**Why it exists:** it gives crews a safe "bank it" decision at the run level (push-or-bank on a bigger scale) and makes the Bill feel like real progress for younger players.

## 9. Bouncy Lot (playground)
- Two trampolines, a slide, a tire swing, and a ball pit with 40 physics balls (client-simulated for performance).
- A hidden **Sir Waddles** rubber duck spawns in a random one of 8 hiding spots each Day; the first player to find it gets +5 Stars (once per Day per crew). Small delight that rewards exploring.
- Social downtime while the crew argues about the plan.

## 10. The Crew Trailer
- A beat-up camper with the crew name painted on the side (auto-generated: "The [Adjective] [Plural Noun]", e.g., "The Soggy Waffles"; host can reroll name for free).
- Inside: a board showing **save rules**, **crew list** with portraits, **run stats** (night, best night, Tickets won/lost, MVP counts), the **Photo Wall** (Snapshot Camera pictures and ending photos), and buttons:
  - **Leave crew** (teleport to hub; confirmation).
  - **Vote kick** (Public/Quick Play crews only): pick a player; needs a majority of the other players within 20 s; max one kick vote per player per 5 minutes; the kicked player is returned to the hub and can't rejoin this run.
  - **Invite** (opens Roblox's invite prompt).

## 11. The Clown Car
- A tiny, overstuffed clown car with 6 seats, parked at the tower lift.
- Sitting in a seat = READY. The HUD READY button also seats you automatically.
- Departure rules: `03` §3.2. Departure cutscene: `03` §3.3.
- If a Day has a new player in tutorial mode, Honk stands by the car and points ("Get in when you're ready!").

## 12. Night 1 tutorial in Lot 13 (only for new players)
1. Crate pops. Honk waves: "Psst! You owe a clown. Let me help!" (one line, 2 s).
2. Arrow to Sal: Honk hands the player a **free Do-Over Balloon** ("For when you mess up!").
3. Arrow to the Clown Car: "Hop in when your crew is ready!"
4. Each step is skippable, and the whole tutorial is skippable with one "I know how to play" button.
Total target: under 30 seconds.
