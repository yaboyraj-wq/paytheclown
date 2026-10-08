# 04 — Economy and Balancing

> **This file is the single source of truth for numbers.** Every value here must live in one config module in code (`ReplicatedStorage/Shared/Config/Economy.luau` and siblings — see `18_Technical_Architecture.md`). Never hard-code a number in gameplay code. All values are **starting values** to be tuned with the economy simulator (section 11) and playtests. When you change a value, change it here and in config together, and log the change in `27_Decisions_Log.md`.

## 1. The three currencies

| Currency | Scope | Who owns it | Earned from | Spent on | Can Robux buy it? |
| --- | --- | --- | --- | --- | --- |
| **Tickets** | One run | The whole crew (the Jar) | Booth payouts, Pawn Popper, Ticket Rain, Snapshot Camera, starting jar | Stakes, nightly quota, Bill Box | **Never** |
| **Tokens** | One run (saved with the run) | The whole crew (Token wallet) | Surviving nights, surplus over quota, Dares, Pawn Clamp, Token Magnet, starting Tokens | Sal's items, shop rerolls, dare rerolls, pawn buy-backs | **Never** |
| **Stars** | Permanent | Each player personally | Playing (see section 8), daily rewards, Carnival Pass, Star packs (Robux) | Cosmetics at Gert's Thrift Tent | **Yes** (cosmetic only) |

Hard rule: **nothing bought with Robux can change a booth result, the jar, the Tokens wallet, or the quota.** The only exception is the once-per-run **Keep the Lights On** revive, which flags the run as Assisted (see `15_Monetization.md`).

## 2. The Bill

| Difficulty | Bill | Quota multiplier | Notes |
| --- | --- | --- | --- |
| Easy | 500,000 | ×0.70 | Suggested for solo |
| Normal | 1,000,000 | ×1.00 | Default, leaderboard eligible |
| Hard | 2,000,000 | ×1.40 | Hard badges |

- The Bill only goes down through the **Bill Box** (Lot 13; see `07`) or the final payment.
- The Bill shown in story text must come from config (`BILL[difficulty]`), never a hard-coded "1,000,000" string. If tuning changes the Bill, the story updates automatically.

## 3. Nightly quota

### 3.1 Base quota (Normal, 2-player baseline)

| Night | Floor | Base quota |
| --- | --- | --- |
| 1 | Midway | 400 |
| 2 | Midway | 800 |
| 3 | Midway | 1,500 |
| 4 | Neon Arcade | 3,000 |
| 5 | Neon Arcade | 5,500 |
| 6 | Neon Arcade | 10,000 |
| 7 | Funhouse | 18,000 |
| 8 | Funhouse | 30,000 |
| 9 | Funhouse | 50,000 |
| 10 | Big Top | 80,000 |
| 11 | Big Top | 125,000 |
| 12 | Big Top | 190,000 |
| 13+ (Endless) | Rotating | `round(190,000 × 1.35^(night − 12))` |

### 3.2 Crew size multiplier (crew present at `DEPARTING`)

| Crew size | 1 | 2 | 3 | 4 | 5 | 6 |
| --- | --- | --- | --- | --- | --- | --- |
| Multiplier | 0.65 | 1.00 | 1.30 | 1.55 | 1.80 | 2.00 |

### 3.3 Final formula
```
quota = roundNice( baseQuota[night] × crewMultiplier[crewSize] × difficultyMultiplier )
roundNice(x): if x < 10,000 → round to nearest 10; else → round to nearest 100
```

## 4. Stakes per floor

| Floor | Min stake | Max stake | Max stake with Zap Wand |
| --- | --- | --- | --- |
| F1 Midway | 10 | 1,000 | 2,000 |
| F2 Neon Arcade | 100 | 5,000 | 10,000 |
| F3 Funhouse | 500 | 25,000 | 50,000 |
| F4 Big Top | 2,000 | 100,000 | 200,000 |
| Endless (any floor) | floor min | `max(floorMax, round(quota × 0.6))` | ×2 |

- A stake can never exceed the jar.
- Rookie limit (Quick Play newcomers; see `03` §7.3): max 10% of jar per play.
- Big-stake threshold: stake > 30% of jar **and** > 10 × floor min (see `03` §7.2).
- While Bigsby Walks the Floor, minimum stakes ×1.25 (rounded up to nearest 10).

## 5. Booth payout summary

Each booth's full rules and payout tables live in `05_Booths/`. This table is the quick reference and the **balance target**. "Return" means average Tickets back per Ticket staked (1.00 = break even).

| # | Booth ID | Floor | Type | Key multipliers | Target return: new player | Average player | Skilled | Expert cap |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `HOOP_WHEEL` | 1 | Aim + timing | Color 2x, Number 10x | 0.95 | 1.10 | 1.35 | 1.6 |
| 2 | `RING_STACK_21` | 1 | Aim + choice | Beat Bigsby 2x, Exactly 21 3x, Tie 1x | 1.00 | 1.15 | 1.40 | 1.7 |
| 3 | `STOP_REELS` | 1 | Timing | 3-match 3–5x, 3 Sir Waddles 10x, 2-match 1.2x | 0.95 | 1.10 | 1.35 | 1.6 |
| 4 | `DUCK_DERBY` | 1 | Rhythm | 1st 2.5x, 2nd 1.2x, Sir Waddles win 5x | 1.00 | 1.15 | 1.40 | 1.7 |
| 5 | `BLOCK_TOSS` | 1 | Physics | Win 2x (2.5x when the Point is 4 or 10) | 0.95 | 1.05 | 1.30 | 1.6 (with Foam Bat) |
| 6 | `STRONGMAN_SPINNER` | 1 | Timing (power) | 0x–10x segments | 0.90 | 1.05 | 1.30 | 1.5 |
| 7 | `SPLAT_WHEEL` | 2 | Aim | Blue 2x, Green 3x, Purple 5x, Gold 12x | 0.90 | 1.10 | 1.35 | 1.6 |
| 8 | `PENGUIN_CROSSING` | 2 | Timing + nerve (push) | 1.2x → 10x over 10 lanes | 0.95 | 1.15 | 1.40 | 1.8 |
| 9 | `GEM_RECALL` | 2 | Memory | Up to 18x (5 picks) | 0.95 | 1.15 | 1.40 | 1.8 |
| 10 | `ROCKET_RIDE` | 2 | Steering + nerve (push) | Rising multiplier, eject any time | 0.95 | 1.15 | 1.40 | 1.8 |
| 11 | `HILO_METER` | 2 | Timing + nerve (push) | Side-size based, compounding | 0.95 | 1.10 | 1.35 | 1.7 |
| 12 | `PINBALL_DROP` | 2 | Timing (flippers) | 0.2x–24x slots | 0.90 | 1.05 | 1.30 | 1.6 |
| 13 | `FUNHOUSE_LADDER` | 3 | Observation + nerve (push) | 1.45x → 19.6x over 8 rows | 0.95 | 1.15 | 1.40 | 1.8 |
| 14 | `PIE_SWEEPER` | 3 | Logic + nerve (push) | Grows per safe tile | 1.00 | 1.15 | 1.45 | 1.9 |
| 15 | `CARD_CATCH` | 3 | Timing + choice | Pair 1x → Four of a kind 25x | 0.95 | 1.10 | 1.35 | 1.6 |
| 16 | `BOWL_TO_NINE` | 4 | Aim | Beat Bigsby 2x, Natural 9 2.5x, Tie 1x | 0.95 | 1.10 | 1.35 | 1.6 |
| 17 | `BIG_TOP_JUGGLE` | 4 | Rhythm co-op + nerve | +0.5x per 5 catches | 1.00 | 1.15 | 1.40 | 1.8 |

**Why returns are above 1.00 for average players:** unlike a casino, the crew has to *grow* the jar to beat rising quotas and the Bill. Good play must make money. The challenge comes from rising quotas, the clock, push greed, and teammates' decisions — not from a house edge.

**"Expert cap"** is the maximum return we allow even for perfect play. If playtest data or the simulator shows a booth beating its cap, make it harder (faster speeds, smaller targets) — never by adding hidden randomness.

## 6. Booth pools per floor

| Floor | New booths on this floor | Pads | Filled with |
| --- | --- | --- | --- |
| F1 Midway | Hoop Wheel, Ring Stack 21, Stop-the-Reels, Duck Derby, Block Toss, Strongman Spinner | 5 | 5 of the 6, rotating |
| F2 Neon Arcade | Splat Wheel, Penguin Crossing, Gem Recall, Rocket Ride, Hi-Lo Meter, Pinball Drop | 7 | ≥ 3 F2 booths + rest from F1 |
| F3 Funhouse | Funhouse Ladder, Pie Sweeper, Card Catch | 7 | all 3 F3 booths + 4 from F1–F2 |
| F4 Big Top | Bowl to Nine, Big Top Juggle | 7 | both F4 booths + 5 from F1–F3 |

Booths keep their own floor-based difficulty tables (each booth file has one). A Floor-1 booth that appears on Floor 4 uses its Floor-4 difficulty row and Floor-4 stake limits.

## 7. Tokens

### 7.1 Sources

| Source | Amount |
| --- | --- |
| Starting Tokens | 5 (save rule: 0 / 5 / 10) |
| Night survived | +3 |
| Surplus bonus | +1 per full 25% of tonight's quota left in the jar after paying it, max +4 |
| Dare completed | Easy +3, Medium +5, Hard +8 |
| Pawn Clamp (per piece, once each per player per run) | Shades +8, Voice Box +6, Shoes +10 |
| Token Magnet (item) | +1 per crew win while active, max +8 per night |

### 7.2 Sinks

| Sink | Cost |
| --- | --- |
| Items at Sal's Trailer | 3–8 (table in section 9) |
| Sal's stock reroll | 2, then +2 for each further reroll the same Day (2, 4, 6…) |
| Dare Board reroll | 1, then +1 each further reroll the same Day |
| Pawn buy-back | Shades 12, Voice Box 9, Shoes 15 |

Token wallet max: 99 (prevents hoarding across very long Endless runs).

## 8. Stars (personal, permanent)

### 8.1 Sources

| Source | Stars |
| --- | --- |
| Night survived (you were in the crew at Closing) | +10 |
| Night MVP | +5 |
| Each of your winning plays | +1, max +20 per night |
| Dare completed (you were in the crew) | +15 |
| Ending: Paid in Full / Ringmasters / Part of the Act | +150 / +250 / +100 |
| Cannon launch (being a good sport) | +10 |
| Endless night survived | +15 |
| First win of the day | +30 |
| Daily login streak (days 1–7) | 20, 30, 40, 50, 60, 80, 150, then repeats |
| Carnival Pass tiers | see `14_Progression_Badges_Retention.md` |
| Rewarded video (13+ only, optional) | +15, max 3 per day |
| VIP pass | +10% on all earned Stars (not purchased Stars) |
| 2x Stars pass | ×2 on all earned Stars (not purchased Stars); stacks additively with VIP (total ×2.1) |

Expected earn rate for an average player in a 45-minute session: about 150–250 Stars.

### 8.2 Sinks (Gert's Thrift Tent price bands)

| Category | Stars |
| --- | --- |
| Hats and small accessories | 300–800 |
| Emotes | 400–900 |
| Name tag styles | 500 |
| Cannon launch styles | 1,000–1,500 |
| Jar skins | 1,200–2,000 |
| Full costumes | 2,000–4,000 |
| Limited event items | 1,500–3,000 (time-limited, never random) |

Full catalog: `14_Progression_Badges_Retention.md` §6.

## 9. Item costs (Tokens)

| Item ID | Name | Cost | Unlocks on floor |
| --- | --- | --- | --- |
| `DO_OVER_BALLOON` | Do-Over Balloon | 3 | 1 |
| `DOUBLE_DARE_HORN` | Double Dare Horn | 3 | 1 |
| `FIX_IT_WRENCH` | Fix-It Wrench | 3 | 1 |
| `SURPRISE_CRATE` | Surprise Crate | 4 | 1 |
| `GOLDEN_TICKET` | Golden Ticket | 4 | 1 |
| `ZAP_WAND` | Zap Wand | 4 | 1 |
| `FIZZ_POP` | Fizz Pop | 5 | 1 |
| `PAWN_POPPER` | Pawn Popper | 5 | 2 |
| `SNAPSHOT_CAMERA` | Snapshot Camera | 6 | 2 |
| `REWIND_REMOTE` | Rewind Remote | 6 | 3 |
| `HYPE_BATTERY` | Hype Battery | 6 | 2 |
| `KARAOKE_MIC` | Karaoke Mic | 6 | 2 |
| `GUARDIAN_GNOME` | Guardian Gnome | 7 | 3 |
| `BUBBLE_WRAP` | Bubble Wrap | 7 | 1 |
| `SHOW_OFF_BOWTIE` | Show-Off Bowtie | 7 | 3 |
| `TOKEN_MAGNET` | Token Magnet | 8 | 2 |

Costs match the original game's ticket costs so its proven item balance carries over as a starting point. Full item rules: `06_Items.md`.

### 9.1 Sal's stock generation
- 6 offers per Day, drawn with weights from items unlocked by the current floor.
- Weights: common items 1.0, `REWIND_REMOTE` 0.5, `GUARDIAN_GNOME` 0.7, `TOKEN_MAGNET` 0.8.
- No more than 2 copies of the same item in one stock.
- Seed: `runSeed + day × 101 + rerollCount`.

## 10. Other numeric rules

| Rule | Value |
| --- | --- |
| Bill Box minimum deposit | 100 Tickets |
| Pawn Popper payout | 33% of tonight's quota per piece (Tickets into the jar) |
| Ticket Rain | 10 bundles × 1% of tonight's quota |
| Spotlight Booth | +25% payout for 30 s |
| Rush Hour | rounds 20% faster, payouts +10%, 30 s |
| Bigsby Walks the Floor trigger | jar < 50% of quota after first 60 s; lasts 45 s; once per night |
| Big-stake threshold | > 30% of jar and > 10 × floor min |
| Big-stake approval window | 5 s |
| Rookie stake limit | 10% of jar |
| Closing grace period | 5 s |

## 11. The economy simulator (must build before tuning)

Create `tools/economy_sim/` (Luau run with Lune, or Python). It must:
1. Model a crew of 1–6 players with skill tiers (new, average, skilled, expert) using the "target return" per booth from section 5 and a play rate of about 10–14 plays per player per 5-minute night.
2. Model stake behavior profiles: cautious (stake 10–20% of cap), normal (30–50%), greedy (60–100% and pushes).
3. Model item usage at a simple level (e.g., Golden Ticket once per night when available).
4. Run 10,000 runs per configuration and report: clear rate per night, chance to reach Night 12, chance jar ≥ Bill at final, median run length, Tokens earned per night, Stars per hour.

### 11.1 Balance targets (Normal, 4-player crew, average skill, normal stakes)

| Measure | Target |
| --- | --- |
| Night 1 clear rate | ≥ 97% |
| Night 3 clear rate | ≈ 90% |
| Night 6 clear rate | ≈ 75% |
| Night 9 clear rate | ≈ 60% |
| Night 12 clear rate | ≈ 45% |
| Reach an ending | ≈ 40% of runs |
| Jar ≥ Bill at final (given Night 12 cleared) | ≈ 55–65% |
| Median run length | 40–55 minutes |
| Skilled crews reaching an ending | ≈ 70% |

If targets are missed, tune in this order: (1) base quotas, (2) stake caps, (3) the Bill, (4) booth difficulty rows. Never fix balance with hidden randomness.

## 12. Economy safety rules

1. All currency changes happen on the server through one `Economy` service with an audit log (see `16`, `17`).
2. Every change has a reason code (e.g., `BOOTH_PAYOUT`, `QUOTA`, `BILL_DEPOSIT`, `PAWN`, `ITEM_BUY`, `DEV_PRODUCT`) and is sent to analytics as an economy event (see `19`).
3. Numbers are integers. No floating-point Tickets. Multipliers are applied then floored.
4. Max jar: 9,999,999,999 (fits safely in Luau numbers; displayed with abbreviations: 1.2K, 3.4M, 5.6B).

## 13. M0/M1 technical starting values (2026-10-07)

M1 uses the roadmap's short departure and placeholder cannon. These are prototype timings, not final cinematic timings. Arithmetic identities and indexing constants are not tuning values.

| Config/Runtime key | Starting value |
| --- | --- |
| `MAX_CREW` | 6 |
| `LOADING_SECONDS` | 20 |
| `READY_ALL_SECONDS` | 5 |
| `READY_SOLO_SECONDS` | 3 |
| `READY_MAJORITY_SECONDS` | 60 |
| `DAY_AFK_PROMPT` | 300 |
| `DAY_AFK_RETURN` | 120 |
| `DEPART_SECONDS` | 3 |
| `NIGHT_INTRO_SECONDS` | 4 |
| `NIGHT_SECONDS` | 300 |
| `FINAL_CALL_SECONDS` | 60 |
| `LAST_COUNTDOWN_SECONDS` | 10 |
| `CLOSING_GRACE_SECONDS` | 5 |
| `CLOSING_SECONDS` | 12 |
| `RESULT_SECONDS` | 15 |
| `RESULT_SKIP_AFTER` | 3 |
| `CANNON_SECONDS` | 5 |
| `RUN_OVER_SECONDS` | 30 |
| `CLAIM_AWAY_SECONDS` | 5 |
| `KEYPAD_IDLE_SECONDS` | 20 |
| `LOCK_SECONDS` | 0.6 |
| `RESULT_PRESENT_SECONDS` | 1.5 |
| `COOLDOWN_SECONDS` | 1 |
| `PUSH_SECONDS` | 8 |
| `CONTROLLER_DISTANCE` | 8 |
| `STATION_DISTANCE` | 12 |
| `INPUT_RATE` | 20 |
| `UI_RATE` | 10 |
| `INPUT_PAST_TOLERANCE` | 0.25 |
| `INPUT_FUTURE_TOLERANCE` | 0.05 |
| `MAX_PING_SECONDS` | 1 |
| `MAX_PACKET_FIELDS` | 8 |
| `MAX_PACKET_STRING` | 64 |
| `SPAM_MULTIPLIER` | 5 (strictly exceeding this multiple of each remote's rate) |
| `SPAM_SECONDS` | 3 consecutive one-second observation windows |
| `RETRY_ATTEMPTS` | 4 |
| `RETRY_INITIAL_SECONDS` | 0.5 |
| `RETRY_FACTOR` | 2 |
| `RETRY_MAX_SECONDS` | 4 |
| `STATE_INTERVAL` | 0.1 |
| `AUDIT_LIMIT` | 2048 |
| `MAX_SEQUENCE` | 2147483647 |
| `MAX_ADMIN_NIGHT` | 100 |
| `WALK_SPEED` | 16 |
| `JUMP_POWER` | 50 |
| `CANNON_UP` | 90 |
| `CANNON_FORWARD` | 75 |
| `PROTOTYPE_FLOOR` | 1 |
| `PIE_DIFFICULTY_FLOOR` | 3 |
| `WORLD_SEED_MAX` | 2147483646 (new server-random seed in 1..max for each run) |
| `SEED_MODULUS` | 2147483647 (deterministic setup seed mixing) |
| `SEED_MULTIPLIER` | 48271 |
| `SEED_STREAMS` | REEL_STRIP=1, REEL_OFFSET=2, PIE_BOARD=3 |
| `PIE_PREVIEW_SECONDS` | 2 |
| `MAX_ROUND_SECONDS` | 45 |
| `MINUTE` | 60 |
| `PERCENT` | 100 |
| `MILLISECOND` | 1000 |
| `DECIMALS` | 100 |

Pie Sweeper previews its fixed board for 2 seconds before commitment (AGENTS precedence). Other numeric tables remain in their named system specs.

### M1 Pie per-pick revision — 2026-10-07

Director-approved replacement for cascades and the 0.92 factor: each pick opens one
tile. The guaranteed opening pays 1x. For `k` successful picks including the opening,
the multiplier is `product(i=1..k-1, (25-i)/(25-pies-i))`, rounded to two decimals.
This conditions the reference §5.10 reciprocal-survival formula on the free safe
opening. Three pies: picks 1/2/3 pay 1x/1.14x/1.31x. Eight pies: 1x/1.5x/2.3x.
The 50x cap and all-safe auto-bank stay; neither can trigger from the opening alone.


## 14. M1 gray-box measurements and presentation defaults

These prototype-only starting values are mirrored exactly in `Config/Prototype.luau`. Distances are studs, angles radians, durations seconds, and UI measurements design pixels. They do not replace booth payout tables.

```json
{
  "adminCommands": {
    "fail": "fail",
    "jar": "jar",
    "night": "night",
    "pass": "pass",
    "skip": "skip"
  },
  "adminMaxTickets": 9999999999,
  "adminPrefix": "/ptc",
  "aimDragSensitivity": 0.004,
  "aimStep": 0.15,
  "angleMax": 0.6,
  "angularBase": 7,
  "angularPower": 9,
  "angularSpin": 8,
  "angularZ": 5,
  "booths": [
    {
      "id": "STOP_REELS",
      "position": [
        -34,
        20,
        -18
      ]
    },
    {
      "id": "BLOCK_TOSS",
      "position": [
        0,
        20,
        -18
      ]
    },
    {
      "id": "PIE_SWEEPER",
      "position": [
        34,
        20,
        -18
      ]
    }
  ],
  "cannonPosition": [
    47,
    22,
    28
  ],
  "cannonSize": [
    8,
    5,
    12
  ],
  "chargePeriod": 2.4,
  "colorDark": "34363C",
  "colorFloor": "55575D",
  "colorPad": "C3C5C8",
  "colorPart": "A7A9AD",
  "counterSize": [
    16,
    2,
    8
  ],
  "cubeSize": 2,
  "cubeSpacing": 1.7,
  "cubeStartY": 4.5,
  "cubeStartZ": 4,
  "daySpawn": [
    0,
    23,
    34
  ],
  "defaultDifficulty": "Normal",
  "defaultOpening": 13,
  "defaultPower": 0.5,
  "defaultPrivacy": "Friends",
  "density": 4,
  "faces": [
    {
      "face": "Top",
      "normal": [
        0,
        1,
        0
      ],
      "value": 1
    },
    {
      "face": "Bottom",
      "normal": [
        0,
        -1,
        0
      ],
      "value": 6
    },
    {
      "face": "Right",
      "normal": [
        1,
        0,
        0
      ],
      "value": 2
    },
    {
      "face": "Left",
      "normal": [
        -1,
        0,
        0
      ],
      "value": 5
    },
    {
      "face": "Front",
      "normal": [
        0,
        0,
        -1
      ],
      "value": 3
    },
    {
      "face": "Back",
      "normal": [
        0,
        0,
        1
      ],
      "value": 4
    }
  ],
  "facesText": [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6"
  ],
  "flatThreshold": 0.98,
  "floorPosition": [
    0,
    18,
    0
  ],
  "floorSize": [
    120,
    2,
    96
  ],
  "friction": 0.8,
  "initialAngles": [
    [
      0,
      0,
      0
    ],
    [
      0,
      0,
      0
    ]
  ],
  "labelDistance": 100,
  "labelPixels": 50,
  "labelText": 38,
  "lotSignPosition": [
    -45,
    28,
    38
  ],
  "nightSpawn": [
    0,
    23,
    10
  ],
  "packetWindow": 1,
  "padOffset": [
    0,
    -0.6,
    13
  ],
  "padSize": [
    10,
    0.4,
    7
  ],
  "pitHalf": 8,
  "pitMargin": 1.5,
  "pitSize": [
    16,
    1,
    16
  ],
  "postSize": [
    0.6,
    10,
    0.6
  ],
  "postX": 8,
  "postZ": -5,
  "powerBase": 10,
  "powerRange": 18,
  "readyPosition": [
    0,
    19.2,
    28
  ],
  "readySize": [
    18,
    0.4,
    8
  ],
  "reelCenterColor": "FFC93C",
  "reelCount": 3,
  "reelOffset": [
    0,
    4.4,
    1.6
  ],
  "reelRows": [
    -1,
    0,
    1
  ],
  "reelSize": [
    3.6,
    5.4,
    0.6
  ],
  "reelSpacing": 4.2,
  "reelSymbolText": 30,
  "signOffset": [
    0,
    9,
    -5
  ],
  "signSize": [
    17,
    5,
    0.5
  ],
  "spawnSpread": 4,
  "ui": {
    "actionBottom": 24,
    "aimDeadzone": 0.12,
    "aimWidth": 0.5,
    "alpha": 0.08,
    "barHeight": 12,
    "baseHeight": 820,
    "baseWidth": 1180,
    "blockParamsY": 64,
    "board": 300,
    "body": 18,
    "button": 56,
    "cameraFocus": [
      0,
      2,
      0
    ],
    "cameraOffset": [
      0,
      21,
      28
    ],
    "cameraSeconds": 0.4,
    "compactHeight": 480,
    "compactLandscapeHeight": 480,
    "compactWidth": 370,
    "corner": 8,
    "crewHeight": 28,
    "frameZ": 10,
    "gameBodyHeight": 380,
    "gameButtonY": 320,
    "gap": 8,
    "half": 0.5,
    "header": 82,
    "headerBarY": 42,
    "headerCrewY": 60,
    "headerJarY": 8,
    "headerPhaseX": 0.48,
    "margin": 20,
    "meterWidth": 0.45,
    "modalHeight": 260,
    "modalWidth": 540,
    "padding": 14,
    "panelHeight": 520,
    "panelTop": 122,
    "panelWidth": 420,
    "percent": 100,
    "phaseWidth": 0.52,
    "pieControlsY": 310,
    "previewAlpha": 0.15,
    "quarter": 0.25,
    "reelCameraFocus": [
      -4,
      4.4,
      0
    ],
    "reelCameraOffset": [
      -4,
      6,
      21
    ],
    "reelHeight": 94,
    "reelPayoutHeight": 96,
    "reelPlayPanelHeight": 220,
    "reelStripY": 132,
    "resultSeconds": 4,
    "row": 64,
    "ruleRow": 48,
    "scaleMin": 0.8,
    "sectionContentY": 132,
    "sectionRuleY": 46,
    "sectionStatusY": 100,
    "sectionTitleY": 12,
    "small": 18,
    "smallRow": 30,
    "stakeAdjustY": 132,
    "stakeChipsY": 68,
    "stakeGoY": 196,
    "stakeLimitsY": 34,
    "stakeValueY": 0,
    "stripText": 14,
    "textInset": 12,
    "textTransparency": 0,
    "third": 0.3333333333333333,
    "tile": 56,
    "timerWidth": 0.18,
    "title": 24,
    "titleRow": 34,
    "toastHeight": 124,
    "toastTop": 88,
    "toastWidth": 510,
    "wideThreshold": 900
  },
  "upBase": 8,
  "upRange": 12,
  "voidY": -4,
  "wallHeight": 4,
  "wallThickness": 1,
  "weight": 100
}
```
