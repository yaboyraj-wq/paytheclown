# 02 — Lore, World and Characters

> The lore exists to explain the rules without a tutorial. Every story fact below maps to a mechanic. Never add lore that contradicts a rule in `03_Core_Loop_and_Run_Structure.md`.

## 1. Tone

- **Saturday-morning cartoon.** Goofy, warm, a little sinister. Think "silly villain," never "scary villain."
- **Slapstick, not cruelty.** Nobody gets hurt. Pies, cannons, honks, clown shoes, confetti.
- **Kid-readable.** Short sentences. No sarcasm that needs adult context. No romance, no real-world brands, no real gambling words.
- **Rating target:** Minimal or Mild on Roblox's Maturity & Compliance questionnaire (see `20_Roblox_Compliance_and_Safety.md`).

### Words we use and words we never use

| Use | Never use |
| --- | --- |
| Tickets, Jar, Stake, Push, Bank, Cash out, Booth, Prize, Score | Bet, Wager, Gamble, Casino, Chips, Odds, Jackpot (as gambling), House, Dealer |
| Bill, Quota, Owe, Pay up | Loan shark, Debt collector, Interest, Kill, Die, Dead, Blood |
| Pawn, Pawn Clamp, Get it back | Body parts, Sell your eyes, Organs |
| Fired out of the cannon, Launched | Executed, Punished, Death |

"Jackpot" may appear only as a booth flavor word for a skill result (for example, a perfect reel stop) and never on anything a player stakes on by chance. When in doubt, use "Perfect!" or "Super!" instead.

## 2. The story

### 2.1 The setup (shown in a 20-second skippable intro on a player's first run)
1. A beat-up van full of friends breaks down on a foggy road at night.
2. Carnival music. Lights over the trees. A sign: **BIGSBY'S MIDNIGHT MIDWAY — OPEN DUSK TILL DAWN**.
3. The crew wanders in. Someone leans on a rope. The rope was holding the **Grand Balloon** — Bigsby's giant, glittering hot-air balloon shaped like his own face.
4. It floats away into the sky.
5. **Bigsby the Clown** pops up behind the crew. He unrolls a bill so long it rolls down the hill. **"1,000,000 TICKETS. Pay the clown."**
6. Honk stamps the crew's hands. They now live in **Lot 13** until the bill is paid. Every night, Bigsby sets a **quota**. Miss it, and it's the **Big Cannon**.

### 2.2 Why every rule exists (lore → mechanic map)

| Rule | Lore reason |
| --- | --- |
| Shared jar | The crew broke the balloon together, so Bigsby bills them together. One jar, stamped with all their names. |
| The Bill (1,000,000) | The Grand Balloon's price. |
| Nightly quota | Bigsby's "rent" for letting them stay in Lot 13. It goes up every night because Bigsby is greedy. |
| 5-minute nights | The Midway is only open a few minutes each night before the "Closing Bell." |
| Lot 13 by day | The crew sleeps in a junky trailer lot behind the tower. |
| Tokens | Bigsby's backstage money. Only the shady folks in Lot 13 take it. |
| Stars | Fame. Grandma Gert only sells costumes to performers with Stars. |
| Pawn Clamp | A greedy robot claw that holds your stuff as collateral for quick Tokens. |
| Four floors | The Tower has four acts. Each act unlocks as the season goes on. |
| The Big Cannon | Bigsby's favorite act: "The Human Cannonball Crew." The crew lands safely in the lake and wakes up in Lot 13 — the run is over and they must start a new season. |
| Three endings | Pay the bill, beat Bigsby at his own Showdown, or lose the Showdown and become part of the act. |
| Endless Nights | After any ending, Bigsby keeps the Midway open "for one more season." |

### 2.3 The endings

| ID | Name | How | What players see (15–25 s cutscene) |
| --- | --- | --- | --- |
| `PAID_IN_FULL` | Paid in Full | After Night 12, jar ≥ remaining Bill, crew chooses **Pay** | Bigsby counts the Tickets, sobs into a hanky, tears the bill. Sunrise. The van starts. The crew drives off while Honk waves. Leftover Tickets become the crew's score. |
| `RINGMASTERS` | Ringmasters | Crew chooses (or is forced into) the **Showdown** and wins | Spotlight on the crew wearing ringmaster hats. Bigsby is handed a broom and sweeps popcorn. Fireworks spell the crew members' names. |
| `PART_OF_THE_ACT` | Part of the Act | Crew loses the **Showdown** | Clown makeup splats onto every player. The crew is shot out of the cannon in matching costumes as the new opening act. Comedic, never sad. |

## 3. The cast

All characters are original. None may resemble characters from Gamble With Your Friends (no shark, no loan-shark styling, no blob mascots, no goatee trailer vendor look). See `11_Art_Direction_and_Assets.md` for model specs.

### 3.1 Bigsby the Clown — the boss
- **Role:** Owner of the Midway. Sets the quota, appears in cutscenes, walks the floor when the crew is doing badly, runs the Showdown.
- **Look:** Tall, round-bellied clown. Huge red bow tie, striped red-and-gold suit, tiny top hat, white face paint with a giant gold grin, one gold tooth. Carries a giant rolled-up bill. Big gloves.
- **Personality:** Greedy showman. Loves money, loves applause, hates losing. Dramatic. Never truly mean — a cartoon villain who also gets pied.
- **Voice:** Booming carnival barker. Laughs "HOO-HOO-HAA!"
- **Where:** Closing Count cutscene every night, Showdown, endings, and "Bigsby walks the floor" event (see `03`).
- **Sample lines (use as a starting set; keep each under 8 words):**
  - Night start: "Doors are open, crew! Make me rich!" / "Quota's up again. HOO-HOO-HAA!"
  - Big win by crew: "Hey! Hey! That's MY money… later."
  - Big loss by crew: "Ooh, I felt that one. Delicious."
  - Jar below danger line: "Your jar looks hungry, kids."
  - Last 60 seconds: "Sixty seconds! Tick-tock, little Tickets!"
  - Quota met: "Fine. FINE. Same time tomorrow."
  - Quota missed: "Load the cannon!"
  - Final choice: "Pay up… or play me for it?"

### 3.2 Honk — the helper (and tutorial voice)
- **Role:** Bigsby's tiny assistant clown. Runs the **Dare Board**, stamps hands, operates the cannon (apologetically), and is the tutorial guide.
- **Look:** Small (about half a Roblox avatar's height), oversized shoes, one big bike horn on his belt, blue-and-white stripes, sweet face.
- **Personality:** Nervous, kind, secretly on the crew's side.
- **Voice:** Honks plus short squeaky words.
- **Sample lines:** "Psst! Try the hoops first!" / "Dare accepted! Honk honk!" / "Sorry, sorry, cannon time…"

### 3.3 Slick Sal — the gadget seller
- **Role:** Runs **Sal's Snack Trailer**, the item shop (see `07_Lot13_Stations.md`).
- **Look:** Lanky raccoon-eyed carny in a stained apron and a paper hat, toothpick, trench coat with gadgets hanging inside. (A human carny, not an animal — do not make him a raccoon creature.)
- **Personality:** Fast-talking salesman. Teaches combos through his barks.
- **Sample lines:** "Zap it before the Golden Ticket, kid!" / "Everything's legal. Mostly." / "Reroll? Costs ya."

### 3.4 Grandma Gert — the costume seller
- **Role:** Runs **Gert's Thrift Tent** (cosmetics for Stars).
- **Look:** Tiny grandma with giant glasses, knitting needles, a measuring tape around her neck, a costume rack behind her.
- **Personality:** Sweet, dramatic about fashion.
- **Sample lines:** "Ooh, that's your color, dearie." / "Stars, please. I don't take Tickets."

### 3.5 The Pawn Clamp — the pawn machine
- **Role:** The body-part economy, reimagined as a pawn machine (see `07`).
- **Look:** A big claw-machine-like robot with one googly eye and a cash drawer mouth. It grabs items with a clamp. Gears, lightbulbs.
- **Personality:** Robot greed. Beeps.
- **Sample lines (text pop-ups + beeps):** "COLLATERAL ACCEPTED." / "SHOES: VERY STINKY. VERY VALUABLE."

### 3.6 Sir Waddles — the mascot duck
- A rubber duck with a monocle and a tiny crown who appears in Duck Derby (see `05_Booths/04_DuckDerby.md`) and across the game as a running joke (on posters, as a hidden collectible). Fans love a running joke character; Sir Waddles is ours.

## 4. Places

### 4.1 The Midway Gates (the public hub)
A ticket-gate plaza outside the carnival at dusk. Fog, string lights, a giant illuminated sign, food carts (decor). Contains: crew booths, the Play menu, the Thrift Tent storefront, leaderboards, a "Cannon Cam" replay screen, practice booths, and a VIP balcony. See `08_Hub_Matchmaking_Networking.md`.

### 4.2 Lot 13 (the crew's daytime base, inside the private run)
A cozy-junky trailer park behind the tower at sunset. Contains: the prize crate spawn, Honk's Dare Board, Sal's Snack Trailer, Gert's Thrift Tent, the Pawn Clamp, the Bill Box, the Bouncy Lot playground, the crew's trailer (save/rules display), and the Clown Car. See `07_Lot13_Stations.md`.

### 4.3 The Tower (four floors, inside the private run)

| Floor | ID | Name | Mood | Palette (see `11` for hex codes) |
| --- | --- | --- | --- | --- |
| 1 | `F1_MIDWAY` | The Midway | Classic, bright, warm | Red, gold, cream |
| 2 | `F2_NEON` | Neon Arcade | Fast, glowing, electric | Cyan, magenta, deep purple |
| 3 | `F3_FUNHOUSE` | Funhouse of Mirrors | Spooky-silly, wobbly | Purple, lime green, warm orange |
| 4 | `F4_BIGTOP` | The Big Top | Grand, spotlights, circus finale | Red, white, gold, navy |

### 4.4 The Center Ring
The middle of the Big Top floor, used only for the Showdown and endings.

## 5. Writing rules for all in-game text

1. Max 8 words for barks and toasts. Max 12 words for a rule card line. Max 2 lines per rule card.
2. Present tense, second person: "Stop the needle ABOVE the line."
3. Numbers as digits: "Win 3 in a row."
4. Every string goes through the localization table (`10_UI_UX_Spec.md`, section on localization). No hard-coded strings in scripts.
5. Every piece of text a player can see is checked against the "words we never use" table above.

## 6. Seasonal skins (live ops hooks)

The world is designed so each season can re-skin the Midway without new systems:

| Event | Timing | Re-skin | New booth or twist |
| --- | --- | --- | --- |
| Haunted Midway | October | Pumpkins, purple fog, ghost Honk | "Boo Ladder" variant of Funhouse Ladder |
| Frostbite Fair | December | Snow, ice booths, Bigsby in a scarf | "Snowball Hoops" variant of Hoop Wheel |
| Sir Waddles Day | Spring | Ducks everywhere | Duck Derby double Stars weekend |
| Summer Fireworks | July | Fireworks finale every night | New cannon launch styles |

See `22_Launch_Marketing_Ads_LiveOps.md` for the full live-ops calendar.
