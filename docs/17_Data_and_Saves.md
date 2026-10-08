# 17 — Data, Saves and Persistence

## 1. Stores overview
| Store | Type | Key | Holds |
| --- | --- | --- | --- |
| `PlayerProfile_v1` | DataStore (session-locked) | `u_<userId>` | Everything permanent about a player (Stars, cosmetics, settings, stats, daily state, pass, save slot pointers, receipts) |
| `CrewSaves_v1` | DataStore (locked per run) | `c_<hostUserId>_<slot>` | One run's state (the crew save) |
| `CrewHistory_v1` | DataStore | `h_<hostUserId>` | Last 20 finished runs (summary only) |
| `Codes_v1` | DataStore | `code_<CODE>` | Promo code definitions (Stars amount, expiry, max uses) |
| `Leaderboard_*` | OrderedDataStore | per board/week | Scores |
| `Crews`, `OpenCrews`, `UserCrew` | MemoryStore | see `08` §5 | Live, temporary matchmaking data |

Use a proven session-locking library for profiles (for example **ProfileStore**, the successor to ProfileService, via Wally) or implement equivalent locking with `UpdateAsync`. Never use `SetAsync` for profiles.

## 2. Player profile schema (v1)
```lua
{
  schemaVersion = 1,
  stars = 0,                 -- spendable
  starsLifetime = 0,
  xp = 0, level = 1,
  owned = { cosmetics = { [cosmeticId] = true } },   -- passes are checked live, not stored
  equipped = {
    hat = nil, costume = nil, jarSkin = "JAR_CLASSIC", cannonStyle = "CANNON_CONFETTI",
    nameTag = "TAG_DEFAULT", karaokeSong = "SONG_DEFAULT", emotes = { --[[up to 8 ids]] },
  },
  tutorialDone = false,
  settings = {
    music = 0.8, sfx = 1.0, voice = 1.0, cameraShake = true,
    reduceMotion = false, reduceFlashing = false, colorPatterns = true,
    allowBonks = nil,          -- nil = use crew default
    stakeToasts = true, quickChatOnly = false,
  },
  daily = {
    lastLoginDay = 0, calendarDay = 0, lastClaimDay = 0,
    tasksDay = 0, tasks = { --[[3 task records]] }, taskRerollsUsed = 0,
    firstWinDay = 0, adsDay = 0, adsWatched = 0, doubleStarsAdDay = 0,
  },
  club = { streakSaverMonth = 0, lastBonusDay = 0, monthlyCostumesClaimed = {} },
  pass = { seasonId = "S1", xp = 0, claimedFree = {}, claimedPremium = {} },
  stats = {
    runs = 0, nightsSurvived = 0, cannons = 0,
    endings = { PAID_IN_FULL = 0, RINGMASTERS = 0, PART_OF_THE_ACT = 0 },
    wins = 0, losses = 0, mvp = 0, biggestLoser = 0,
    crewTicketsWonLifetime = 0,
    boothWins = { --[[ [boothId] = n ]] }, itemsUsed = { --[[ [itemId] = n ]] },
    waddlesFound = 0, snapshots = 0, nightsWithFriend = { --[[ [friendUserId] = n, keep top 20 ]] },
  },
  badgesAwarded = { --[[ [badgeKey] = true ]] },   -- cache to avoid repeat award calls
  saveSlots = { [1] = nil, [2] = nil, [3] = nil, [4] = nil, [5] = nil, [6] = nil }, -- slot -> saveId
  receipts = { --[[ [purchaseId] = os.time(), keep last 200 ]] },
  codesRedeemed = { --[[ [code] = true ]] },
  moderation = { flags = 0, notes = {} },
}
```

## 3. Crew save schema (v1)
```lua
{
  schemaVersion = 1,
  saveId = "uuid", hostUserId = 123, slot = 2,
  createdAt = 0, updatedAt = 0,
  rules = { nightLength = 300, difficulty = "Normal", startJar = 1000, startTokens = 5,
            bigStakeApproval = false, privacy = "Friends" },
  rulesDefault = true,
  runSeed = 123456789,
  night = 4, state = "DAY",           -- saved states are only DAY or ended states
  jar = 0, bill = 1000000, billPaid = 0, tokens = 5,
  assisted = false, keepLightsUsed = false,
  endless = false, endingReached = nil,  -- "PAID_IN_FULL" | "RINGMASTERS" | "PART_OF_THE_ACT"
  stash = { { itemId = "ZAP_WAND", buyerUserId = 123 } },
  members = {
    ["123"] = { pawned = { SHADES = false, VOICE = false, SHOES = false },
                boughtBack = { SHADES = false, VOICE = false, SHOES = false },
                joinedNight = 1, rookie = false, bonkOptOut = nil },
  },
  kicked = { --[[ userIds ]] },
  day = {                               -- the current Day's generated content (prevents reroll scumming)
    boothList = { --[[ 5–7 booth ids ]] },
    dareOffers = { --[[ 3 dare ids ]] }, dareRerolls = 0, dareAccepted = nil,
    shopStock = { --[[ 6 item ids ]] }, shopRerolls = 0,
    waddlesSpot = 3, waddlesFound = false,
  },
  checkpoint = { jarAtDeparture = 0, tokensAtDeparture = 0 },
  nights = { --[[ per-night summary: quota, paid, won, lost, mvp, dare, items used ]] },
  photoWall = { --[[ up to 20 photo records ]] },
  lock = { jobId = "", time = 0 },      -- one Tower server at a time
}
```

## 4. When to save
| Moment | What is saved |
| --- | --- |
| Day start | Crew save (new Day content generated and stored) |
| Any Day transaction (buy, reroll, pawn, deposit, dare accept) | Crew save, debounced 10 s |
| `DEPARTING` | Crew save **checkpoint** (jar and Tokens at departure) |
| Night result (success or fail) | Crew save + each member's profile (Stars, stats) |
| Ending / run over | Crew save marked finished; summary appended to `CrewHistory`; slot freed |
| Purchases | Profile save before granting (see `15` §5.1) |
| Player leaving | Profile release (session lock end) |
| `game:BindToClose` | Save everything, wait for completion (Roblox gives up to 30 s) |

**Mid-night quit rule:** if every player leaves during a night, the run reloads at that Day with `jar = checkpoint.jarAtDeparture` and `tokens = checkpoint.tokensAtDeparture` (purchases already made that Day stay made). This prevents "quit to undo a loss."

## 5. Locks and concurrency
- Profiles: session-locked; if a profile is locked by another server (player hopping fast), wait and retry up to 10 s, then kick with "Loading your profile… please rejoin."
- Crew saves: when a Tower server loads a save, it writes `lock = { jobId, time }` via `UpdateAsync`. If another live server holds a fresh lock (< 5 minutes old), refuse to load and send players back to the hub with "Your crew is already playing elsewhere — use Rejoin." Refresh the lock every 60 s.

## 6. Migrations
- Every record has `schemaVersion`. On load, run migrations in order (`migrateProfile[1→2]`, …). Never delete fields without a migration. Unknown fields are kept.
- Store defaults in code (`DefaultProfile`) and deep-merge missing fields on load.

## 7. Limits and throttling
- DataStore and MemoryStore have per-server request budgets. Use a request queue with backoff; check `DataStoreService:GetRequestBudgetForRequestType` before non-critical writes.
- Keep each key well under the size limit (4 MB): bound arrays (receipts 200, nights 20, photos 20).

## 8. Privacy and data deletion
- Store only what the game needs. No real names, no emails, no chat logs.
- Honor Roblox's **Right to Erasure** requests: when Roblox notifies the creator that a user's data must be deleted, delete `u_<userId>`, any `c_<userId>_*` saves, `h_<userId>`, and leaderboard entries for that user. Keys are user-ID-based to make this easy. Document the procedure in `docs/27_Decisions_Log.md` and test it.
- Studio testing: enable "Allow Studio access to API services" only in a **test place**/experience copy, not on the live experience's data, or use a separate DataStore name prefix for Studio (`DEV_`).

## 9. Backups and recovery
- DataStore versioning lets you list and restore prior versions of a key; build an admin-only restore command for support cases.
- Before any risky migration, export a sample of keys (Open Cloud DataStore API) to a local backup.
