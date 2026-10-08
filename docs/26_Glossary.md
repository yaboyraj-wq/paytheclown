# 26 — Glossary (use these exact words in code, UI and docs)

| Term | Meaning | Code name |
| --- | --- | --- |
| **Run** | One save's journey from Night 1 to an ending or the cannon | `Run` |
| **Crew** | The 1–6 players in a run | `Crew` |
| **Host** | The player who owns the crew save | `hostUserId` |
| **Acting host** | Longest-present player when the host is absent | `actingHostUserId` |
| **Day** | Untimed planning phase in Lot 13 before each night | `State.DAY` |
| **Night** | The timed play phase on a tower floor (default 5:00) | `State.NIGHT` |
| **Final Call** | Last 60 seconds of a night | `finalCall` |
| **Closing Bell** | End of the night timer | `closingBell` |
| **Closing Count** | Bigsby checks jar ≥ quota; a pass keeps the whole jar | `State.CLOSING` |
| **Jar** | The crew's shared Tickets for the run | `jar` |
| **Tickets** | Run currency in the jar; can't be bought | `Tickets` |
| **Tokens** | Crew currency for Sal's items, rerolls, buy-backs; can't be bought | `Tokens` |
| **Stars** | Personal permanent currency for cosmetics; can be bought | `Stars` |
| **Bill** | Whole-jar final payment, snapshot at Final Choice; fixed debt retired, M6 redesign pending | `finalPayment` (M6) |
| **Bill Box** | Retired Day deposit station; future role awaits M6 redesign | `BillBox` (deferred) |
| **Quota** | Minimum jar balance to survive; never deducted at Closing Count | `quota` |
| **Pending quota** | Next threshold derived from the retained closing jar, rescaled at departure if crew size changes | `nextQuota` |
| **Successful nights** | Number of passed Closing Counts; drives quota multipliers and floor Token rewards | `successfulNights` |
| **Booth** | A skill mini-game on a floor | `Booth` |
| **Pad** | A booth's spawn spot on a floor | `BoothPad` |
| **Controller** | The player currently playing a booth | `controller` |
| **Watch zone** | Area where teammates spectate a booth | `WatchZone` |
| **Stake** | Tickets locked into a booth play | `stake` |
| **Big stake** | > 30% of jar and > 10 × floor min; triggers crew heads-up | `isBigStake` |
| **Approval** | Crew veto window for big stakes (save rule) | `bigStakeApproval` |
| **Rookie** | Quick Play newcomer limited to 10% stakes | `rookie` |
| **Push** | Continue a streak booth for a higher multiplier | `push` |
| **Bank** | Cash out a streak booth now | `bank` |
| **Multiplier** | Payout ÷ stake | `multiplier` |
| **Profit** | Payout − stake | `profit` |
| **Easy Assist** | Tutorial-only wider windows on a new player's first play | `easyAssist` |
| **Showdown** | 3-round skill challenge after Night 12 | `Showdown` |
| **Performer** | Player chosen to play a Showdown round | `performer` |
| **Item** | Sal's gadget bought with Tokens | `Item` |
| **Stash** | Sal's counter holding bought, unclaimed items (max 6) | `stash` |
| **Hyped** | Stronger item effect while a Hype Battery is active | `hyped` |
| **Foam Bat** | Free world tool on each floor; bonks | `FoamBat` |
| **Bonk Window** | 1.5 s window after Block Toss blocks settle | `bonkWindow` |
| **Pawn / Pawn Clamp** | Trading Shades/Voice Box/Shoes for Tokens with penalties | `Pawn` |
| **Piece** | One pawnable thing: `SHADES`, `VOICE`, `SHOES` | `Piece` |
| **Dare** | Honk's daily challenge for the crew | `Dare` |
| **Day Card** | Start-of-day info card | `DayCard` |
| **Floor** | One of 4 tower levels: `F1_MIDWAY`, `F2_NEON`, `F3_FUNHOUSE`, `F4_BIGTOP` | `Floor` |
| **Floor event** | Spotlight Booth, Ticket Rain, Rush Hour | `FloorEvent` |
| **Bigsby Walks the Floor** | Drama event when the jar is low | `bigsbyWalk` |
| **Big Cannon** | The fail sequence | `Cannon` |
| **Keep the Lights On** | Once-per-run Robux revive; makes the run Assisted | `keepLightsOn` |
| **Assisted** | Run flag; no leaderboards or ending badges | `assisted` |
| **Endless Nights** | Post-ending mode from Night 13 | `endless` |
| **Midway Gates** | The public hub place | `Hub` |
| **The Tower** | The private run place (Lot 13 + floors) | `Tower` |
| **Lot 13** | Day area inside The Tower | `Lot13` |
| **Clown Car** | Ready/departure vehicle | `ClownCar` |
| **Quick-chat** | Predefined message wheel | `QuickChat` |
| **Crew Treat** | Robux product that gives the crew a visual treat and Stars | `CrewTreat` |
| **Carnival Pass** | Season pass | `CarnivalPass` |
| **Carnival Club** | Monthly subscription | `CarnivalClub` |
| **Showbiz Level** | Player level | `level` |
| **Style lock** | Approved art references, palettes and rules | — |
