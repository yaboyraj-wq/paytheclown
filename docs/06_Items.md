# 06 — Items (Sal's Gadgets) and the Foam Bat

> Every item in the original game has a Roblox version here that does the same job without chance-based gambling. Costs are in Tokens (`04` §9). Items are implemented in one `ItemService` using the booth hooks defined in `05_Booths/00_Booth_Framework.md` §11.

## 1. General item rules

### 1.1 Buying and carrying
1. Items are bought at **Sal's Snack Trailer** in Lot 13 with crew Tokens (`07_Lot13_Stations.md`). Any crew member can buy.
2. A bought item appears on Sal's **counter** (the crew stash) with a small name tag of the buyer. Stash holds up to **6** items. When full, Sal won't sell more.
3. **Any crew member can pick up any stashed item** (walk up, press E / tap). Picking up shows a big "Got it!" toast with a one-line description.
4. **Each player carries one item at a time.** The Foam Bat also counts as the held tool, so holding the bat means no item in hand.
5. Items **last for the whole run** until used. Unused items left on the counter stay there for the next Day. (Kinder than the original, where a forgotten pickup was wasted.)
6. A held item can be **dropped** (drop button / Backspace / B). Dropped items stay where they fall until the night ends, then return to Sal's counter.
7. If a player disconnects, their held item drops where they stood.

### 1.2 Using
- Each item has one **use prompt** (shown on the HUD's item slot): "Use", "Plant", "Aim and tap", etc.
- Most items work only during a **Night**. Exception: the **Surprise Crate** can be opened in Lot 13.
- Items can't be used in the **Showdown**.
- One item use per player per second (debounce).
- Every use triggers a crew-wide toast ("Mia used a Golden Ticket at Rocket Ride!").

### 1.3 Payout bonus math (one rule for all items and events)
- All payout bonuses apply to **profit only**: `profit = payout − stake`. Bonuses are percentages of profit, added together, **capped at +100%** total per play.
- `finalPayout = stake + floor(profit × (1 + sumOfBonuses))` when profit > 0.
- Bonuses never apply to a loss or a tie.
- For a **Golden Ticket** play, the stake doesn't come from the jar, so on a win the jar gets the full `finalPayout`.

### 1.4 Loss protection order (if several apply to one losing play)
1. **Guardian Gnome** (full stake refund) — if it applies, the others are not consumed.
2. **Bubble Wrap** (partial refund).
3. **Do-Over Balloon** (player may choose to replay instead; offered after the above resolve).

### 1.5 Hype Battery
While the **Hype Battery** is active (rest of the night after use), every item used by the crew uses its **Hyped** value listed below.

## 2. The items

### 2.1 Do-Over Balloon — `DO_OVER_BALLOON` — 3 Tokens
- **Replaces:** Angel's Reel (spin for a chance to undo your last loss).
- **What it does:** After you **lose** a booth play, you have 5 seconds to pop the balloon. Your stake is put back and you replay the **exact same setup** (same layout, same Bigsby score, same seed — each booth file says what "same" means). No chance involved: it's a skill retry.
- **Use:** a "Pop to retry!" button appears for 5 s after a loss while you hold it.
- **Hyped:** the retry also gets Easy Assist timing windows (+25%).
- **Limits:** one Do-Over per play. Not usable on Showdown.
- **Tutorial gift:** new players get one free on their first Night 1.
- **Look:** a red balloon with a cartoon "↺" arrow. Pop = "POP!" and the booth rewinds with a VHS-rewind effect.

### 2.2 Double Dare Horn — `DOUBLE_DARE_HORN` — 3 Tokens
- **Replaces:** Devil's Reel (triple or lose your last win).
- **What it does:** After you **win** a play, you have 5 seconds to blow the horn. You immediately play that booth's **Double Dare challenge** (a short, harder skill test defined in each booth file). **Succeed → your whole payout is tripled. Fail → you lose the payout and the stake.**
- **Hyped:** success multiplies ×4 instead of ×3.
- **Rules:** big-stake approval rules apply if the win is more than 30% of the jar (teammates get a toast: "[Name] is daring their 12,000-Ticket win!").
- **Look:** a red-and-black party horn with devil-ish clown horns (cartoon). Sound: a goofy "BWAAAP."

### 2.3 Fix-It Wrench — `FIX_IT_WRENCH` — 3 Tokens
- **Replaces:** Screwdriver (3 tickets in the original; its effect was never documented, so this is our own design).
- **What it does:** Use on a booth to "tune it up": for the rest of the night that booth uses the **previous floor's difficulty row** (e.g., an F4 booth plays its F3 row), but payouts at that booth are reduced by 10% of profit.
- **Hyped:** no payout reduction.
- **Rules:** one Wrench per booth per night. Not usable on a Floor-1 booth on Floor 1 (no easier row).
- **Look:** an oversized cartoon wrench; using it spawns sparks and the booth gets a little "TUNED" sticker.

### 2.4 Surprise Crate — `SURPRISE_CRATE` — 4 Tokens
- **Replaces:** Mystery Box (random item).
- **What it does:** Open it to get one random item from the current Sal's pool. **The crate shows the possible items and their chances on its side** before you open it. Bought only with Tokens (never Robux), so it is not a paid random item.
- **Hyped:** choose 1 of 2 revealed items.
- **Can be opened in Lot 13.** The result is placed in your hands (or on the counter if your hands are full).
- **Look:** a wooden crate with "?" stencils, rattles when held.

### 2.5 Golden Ticket — `GOLDEN_TICKET` — 4 Tokens
- **Replaces:** Golden Chip (a single free all-in).
- **What it does:** Use on a booth's stake keypad. Your stake is set to that booth's **current max stake** (including Zap Wand bonus) and it's **free**: nothing leaves the jar. Win → the full payout goes into the jar. Lose → the jar loses nothing.
- **Hyped:** +25% profit on that play.
- **Rules:** doesn't need big-stake approval (no risk to the jar). One Golden Ticket per play.
- **Best combo:** Zap Wand first (raises the max), then Golden Ticket.
- **Look:** a shiny gold ticket that sparkles; using it makes a gold ticket rain onto the booth.

### 2.6 Zap Wand — `ZAP_WAND` — 4 Tokens
- **Replaces:** Taser (use on a keypad to raise the maximum bet).
- **What it does:** Zap a booth's stake keypad. That booth's max stake becomes ×2 (see `04` §4) for the rest of the night, for everyone.
- **Hyped:** ×3.
- **Rules:** one zap per booth per night. A zapped booth shows crackling lightning on its sign.
- **Look:** a light-up toy wand with a lightning bolt tip. Big "BZZZT!"

### 2.7 Fizz Pop — `FIZZ_POP` — 5 Tokens
- **Replaces:** Drink (more profit while drunk). We use a candy sugar rush instead of alcohol.
- **What it does:** Drink it: for **60 seconds**, your wins get **+30% profit**, but your screen gently wobbles and your aim sways in a smooth, **deterministic** figure-eight pattern (never random), and timing booths show a slightly blurred marker.
- **Hyped:** +45% profit.
- **Look:** a fizzy soda bottle with a swirly straw; the player's avatar gets a fizzing bubble effect and a goofy run animation.

### 2.8 Pawn Popper — `PAWN_POPPER` — 5 Tokens
- **Replaces:** Quota Gun (pays 33% of quota for each body part it shoots off).
- **What it does:** A confetti-blaster that "pops" one pawnable piece (Shades, Voice Box or Shoes — see `07` Pawn Clamp) off a crew member and sends it straight to the Pawn Clamp. **Each pop adds 33% of tonight's quota in Tickets to the jar.** The popped player gets that piece's penalty for the rest of the run (same as pawning it).
- **Consent rule (anti-grief):** aiming at a teammate sends them a prompt: "Pop your Shoes for the crew? (+5,000 Tickets)" with **Yes/No** (5 s, default No). You can always pop **yourself** without a prompt.
- **Charges:** 3 pops per Popper. Each player has 3 pieces; each piece can only be pawned/popped once per run.
- **Hyped:** +45% of quota per pop.
- **No Tokens** are paid for popped pieces (Tokens come only from the Pawn Clamp itself).
- **Look:** a big confetti cannon with a cartoon clamp on the barrel; the popped piece flies off with a "BLOOP!" and lands in a little parachute crate that zooms away to Lot 13.

### 2.9 Snapshot Camera — `SNAPSHOT_CAMERA` — 6 Tokens
- **Replaces:** Camera (capture a winning player for extra profit).
- **What it does:** Aim at a **teammate** who is currently playing a booth and take the photo **before their result**. If their play wins, they get **+50% profit** on it. If it loses, the photo is just funny.
- **Hyped:** +75% profit.
- **Rules:** can't photograph yourself. One photo per play. The photo is saved to both players' "Photo Wall" in the Crew Trailer (cosmetic, for screenshots).
- **Look:** an old flash camera with a big bulb; "FLASH!" white pop and a polaroid that develops on screen.

### 2.10 Rewind Remote — `REWIND_REMOTE` — 6 Tokens
- **Replaces:** Time Machine (rolls back time; reported up to 60 seconds).
- **What it does:** Rewinds the crew's night by **45 seconds**: the jar returns to its value 45 s ago (or the night's start value if earlier), and the timer gets 45 s back (never more than the night length).
- **Requirement:** **all booths on the floor must be idle** (no play in progress). The remote blinks red until they are.
- **Hyped:** 60 seconds.
- **Not rewound:** Tokens, Stars, items used, pawned pieces, dares.
- **Limit:** once per night per crew.
- **Look:** a chunky VCR remote. Use → the whole screen does a VHS rewind effect, everyone's camera shakes, Bigsby yells "HEY! That's cheating!… I'll allow it."

### 2.11 Hype Battery — `HYPE_BATTERY` — 6 Tokens
- **Replaces:** Stake Holder (increases the power of each item).
- **What it does:** Use it (any time during a night): **for the rest of that night, every item the crew uses gets its Hyped effect.**
- **Rules:** one active Hype Battery per night. It doesn't affect items used before activation.
- **Look:** a giant cartoon battery with a lightning face. Activation: the jar meter UI glows electric blue for the rest of the night.

### 2.12 Karaoke Mic — `KARAOKE_MIC` — 6 Tokens
- **Replaces:** Microphone (while active, raises nearby profit by singing).
- **What it does:** Activate to sing for **30 seconds**. While singing, you can walk slowly but can't play booths. Every crew win at a booth within **25 studs** gets **+25% profit**.
- **Hyped:** +40% profit.
- **Songs:** default song is an original carnival jingle; extra songs are cosmetic purchases (Stars or Robux), never stronger.
- **Look:** a sparkly retro microphone; music notes float from the singer; a ring on the floor shows the 25-stud radius.

### 2.13 Guardian Gnome — `GUARDIAN_GNOME` — 7 Tokens
- **Replaces:** Holy Statue (while active, prevents all loss nearby).
- **What it does:** Plant the gnome on the floor. For **30 seconds**, any booth within **15 studs** refunds the stake on a loss (no loss).
- **Hyped:** 45 seconds.
- **Rules:** affects plays that **resolve** while the gnome is active. Booths in range show a halo. One active gnome per crew at a time.
- **Best combo:** plant next to Block Toss (the original's famous Holy Statue + Street Craps combo).
- **Look:** a garden gnome in a superhero cape with a glowing shield.

### 2.14 Bubble Wrap — `BUBBLE_WRAP` — 7 Tokens
- **Replaces:** Insurance (decreases the amount lost).
- **What it does:** Use before pressing GO. Your next play is wrapped: **if it loses, 50% of the stake comes back.**
- **Hyped:** 75% back.
- **Look:** the booth gets wrapped in bubble wrap; on a loss, satisfying pop sounds as Tickets come back.

### 2.15 Show-Off Bowtie — `SHOW_OFF_BOWTIE` — 7 Tokens
- **Replaces:** Gambler's Confidence (increases profit amount).
- **What it does:** Put it on: **for the rest of the night, your wins get +25% profit.** Wearing it frees your hands (the item slot empties).
- **Hyped:** +40% profit.
- **Look:** a giant sparkly bowtie that spins when you win.

### 2.16 Token Magnet — `TOKEN_MAGNET` — 8 Tokens
- **Replaces:** Bonus Draw (get a ticket each time the team profits).
- **What it does:** Use during a night: **for the rest of the night, the crew gets +1 Token for every winning play by anyone**, up to +8.
- **Hyped:** up to +12.
- **Look:** a horseshoe magnet with Tokens zipping to it; a little "+1" pops over the jar for each Token.

## 3. Item combos to protect (players love discovering these)

| Combo | Why it's good | Original equivalent |
| --- | --- | --- |
| Zap Wand → Golden Ticket | Doubles the free max stake | Taser + Golden Chip |
| Guardian Gnome + Block Toss | Losing tosses refund | Holy Statue + Street Craps |
| Hype Battery + Karaoke Mic + clustered booths | +40% profit for the whole crew nearby | Stake Holder + Microphone |
| Rewind Remote + Funhouse Ladder / Pie Sweeper | Undo a bad climb or sweep | Time Machine + Dragon Tower / Mine Sweeper |
| Show-Off Bowtie + Fizz Pop | Stacking profit bonuses (cap +100%) | Gambler's Confidence + Drink |
| Bubble Wrap + Rocket Ride | Push longer with a safety net | Insurance + Crash |

Sal's barks hint at these combos (see `02` §3.3).

## 4. The Foam Bat — `FOAM_BAT` (free world object)

**Replaces:** the baseball bat by the original's casino elevator that could be carried inside and used to hit a craps die onto a chosen number.

### 4.1 Where and how
- One Foam Bat rests on a rack beside the **tower lift on each floor**. It respawns there at every night start.
- Any crew member can pick it up (it's a Tool). It **can't leave the floor**: walking into the lift or the night ending returns it to the rack.
- Holding it fills your hands (you can't hold an item at the same time).
- Swing: primary action. Swing cooldown 1.2 s.

### 4.2 What it does at booths (defined in each booth file)
| Booth | Bat effect |
| --- | --- |
| Block Toss | During the 1.5 s Bonk Window after blocks settle, tip one block one face (one bonk per toss) |
| Strongman Spinner | Bonk the spinning wheel: −5% speed, once per spin |
| Hi-Lo Meter | Bonk the gauge to stop the needle for the Controller, once per step |
| Pinball Drop | "Tilt" nudge once per drop; twice = TILT (center slot) |
| Funhouse Ladder | Bonk one door per row before the tap: reveals whether it's a Boo |
| Pie Sweeper | Bonk the table once per round: pie cloches jiggle more for 1 s |
| Card Catch | Pause the conveyor 0.3 s, once per round |
| Bowl to Nine | Knock down one standing pin after ball 1 |
| Duck Derby, Big Top Juggle | Not allowed (bat is lowered automatically in those zones) |
| Others | Harmless "boing" |

**Who can bonk:** only crew members who are **not** the Controller of that booth (it's a teammate trick), except where a booth file says otherwise.

### 4.3 Bonking players (comedy)
- A bonk on a player knocks them back 6 studs with a 1-second ragdoll and a cartoon "BONK!" star.
- **Never** allowed on: a player who is a booth Controller, a player in a seat (Duck Derby, Big Top Juggle, Rocket cockpit), a player in the Showdown, or a player who was bonked in the last 8 seconds.
- **Bonk setting:** each player has "Allow bonks on me" in Settings. Default **ON** in Friends/Invite crews, **OFF** in Public/Quick Play crews.
- Bonks never change Tickets, items or results.

## 5. What we are not copying from the original's items

- **Names, icons, models, sounds and descriptions** are all original.
- **Angel's/Devil's Reel randomness** is replaced by skill retries and skill challenges.
- **Drink/alcohol** becomes a candy soda.
- **Shooting body parts off** becomes a consensual, confetti "pop" of clothing-like pieces into a pawn machine.
- **Holy Statue** religious imagery becomes a superhero garden gnome.
- **Time Machine** keeps the idea (rewind) but uses our own limits (45/60 s, all booths idle).

## 6. Anti-abuse summary for items

1. All item effects are applied on the server. Clients only send "use item X at target Y."
2. Targets are validated (distance ≤ 20 studs for aimed items; the booth must exist and be in the right state).
3. Pawn Popper needs consent unless self-targeted.
4. Snapshot needs a teammate currently in `PLAYING`.
5. Rewind needs all booths idle; once per night.
6. Hype Battery once per night.
7. Item purchases are server-checked against the Token wallet with the purchase price recorded in the run's audit log (see `16`, `17`).
