# 08 — Hub, Crews, Matchmaking and Teleports

> This file answers: "What happens when a player presses Play on Roblox?" Short version: they arrive in a public hub (**Midway Gates**), form a crew in under 60 seconds through a menu, a walk-up booth, Quick Play or their Roblox party, and the whole crew is teleported together into its own private server (**The Tower**) where the run happens.

## 1. Places in the experience

| Place | Role | Max players per server | Start place? | Access |
| --- | --- | --- | --- | --- |
| **Midway Gates** | Public hub | 30 (tune 20–40) | Yes | Public |
| **The Tower** | Private runs: Lot 13 + 4 floors + Center Ring | 6 | No | Reserved servers only; set Tower's access so it can only be reached by teleport from inside the experience |

- One Rojo project builds both places from shared code (`18_Technical_Architecture.md`).
- The Tower contains Lot 13 and all four floors in one place, with streaming enabled, so there are **no teleports between nights** (no loading screens mid-run).

## 2. The hub: Midway Gates

### 2.1 Purpose
The hub is the shop window and the matchmaker. It shows off what players can earn and buy, and gets everyone into a crew fast.

### 2.2 Layout (all within ~20 seconds of walking; most players use the menu)
```
                  [ GIANT GATE ARCH + LOGO ]
  [ CANNON CAM SCREEN ]    [ CREW BOOTHS x6 ]     [ LEADERBOARD TOWER ]
  [ PRACTICE ALLEY ]        (SPAWN PLAZA)        [ GERT'S THRIFT TENT (store) ]
  [ VIP BALCONY (pass) ]   [ DAILY PRIZE WHEEL* ] [ CARNIVAL PASS BOARD ]
                           [ CODES KIOSK ]
```
*The "Daily Prize Wheel" is not random: it's a **daily reward calendar** shaped like a wheel that advances one slice per login day (see `14`). Never make it a random spin.

| Area | What it does |
| --- | --- |
| Spawn plaza | Players spawn here; the PLAY button pulses on the HUD; Honk waves at first-timers. |
| Crew booths (6) | Walk-up crew formation (§3.4). |
| Cannon Cam screen | A giant screen replaying short recordings of real cannon launches and Huge wins from recent crews in this server's region (implement as a scripted reenactment: store the crew's avatar IDs + event type, then replay the animation with their avatars — no video). Players love seeing themselves. |
| Leaderboard tower | Weekly top crews (Normal default rules, by score), Endless nights survived, and lifetime Stars. |
| Thrift Tent (store) | Same catalog as Lot 13's tent; try-on mirror. |
| Practice Alley | 3 free-play booths (rotating weekly from the Floor 1 pool) with no stakes, so new players can try. Shows a "Try it for real with a crew!" prompt after 3 plays. |
| VIP Balcony | VIP pass owners only; a nicer view, a gold rope, a free emote stage (status only). |
| Carnival Pass board | Shows the season track. |
| Codes kiosk | Enter promo codes (cosmetic Stars rewards only; see `22`). |
| Daily calendar | Claim daily login reward. |

### 2.3 Hub HUD
- Top-left: Stars balance, level/pass tier.
- Top-right: Settings, Shop.
- Bottom-center: **PLAY** (huge, pulsing), and if applicable: **Rejoin your crew** (gold) or **Continue** (blue).
- Friends panel (right edge, collapsible): friends online and in this game, with **Join** buttons when their crew has a seat.

## 3. Forming a crew (four ways)

All four end the same way: a **crew record** is created and the crew is teleported to a new reserved server of The Tower (§4).

### 3.1 PLAY menu → New Crew
1. PLAY → **New Crew**.
2. Pick a **save slot** (3 slots; 6 with VIP). Empty slot = new run. Occupied = "Overwrite?" confirm or pick another.
3. Pick **rules** (see `03` §9). Defaults pre-selected; a single "Start with defaults" button for speed.
4. Pick **privacy**: Friends (default), Invite only, Public.
5. Lobby panel: crew list (you), **Invite** button (Roblox invite prompt), friends list with quick-invite buttons, **START** button.
6. START → teleport everyone in the lobby panel.

The lobby panel lives inside the hub; invited friends who accept arrive in the same hub server if possible (Roblox follow) and appear in the panel. If they're in a different hub server, they appear as "joining…" and get pulled in when the crew launches (they are teleported directly to the Tower server).

### 3.2 PLAY menu → Continue
1. Shows the player's saved runs: night, floor, crew members, rules, last played.
2. Select → the same lobby panel as above (pre-filled with past crew members who are online, marked "invite").
3. START → teleport. Only the save's **host** can continue a save (original rule). Non-hosts see their friend's save in "Friends' crews" and can request to join.

### 3.3 PLAY menu → Quick Play
1. The server searches the `OpenCrews` directory (§5.2) for a **Public** crew with an open seat, preferring (a) crews in `DAY` state, (b) earlier nights (Night ≤ 3), (c) same language/region if known, (d) more players already.
2. Found → teleport into that crew's Tower server with its access code.
3. Not found within 3 seconds → create a **new Public crew** (default rules) and teleport there. The new crew advertises its open seats so the next Quick Play players join it. In Lot 13, a banner says "Finding crewmates… (2/6)" with a **Start anyway** button. (The Day is untimed, so waiting is natural.)

### 3.4 Walk-up Crew Booths (hub)
- Six carnival ticket booths in the plaza. Stepping in shows a booth panel: crew list, privacy (Friends/Public), **START** for the first player (the host), and a 20-second auto-start countdown once 2+ players are in. Anyone can step out.
- Good for kids who prefer walking to menus and for friends standing together.

### 3.5 Roblox parties
- If a player is in a Roblox party, pressing PLAY (any option) brings the whole party: party members in the same hub server are added to the lobby panel automatically. Use the party APIs (`SocialService` party functions / `Player.PartyId`; verify current API names in the Roblox docs before building).
- Party members in other servers are teleported directly to the Tower when the crew launches.

## 4. Teleporting a crew

### 4.1 Launching a new run
1. The hub server creates a **crew record** in MemoryStore (`Crews` hash map, §5.1) with a new `crewId` (GUID), host, members, rules, slot, privacy.
2. Calls `TeleportService:TeleportAsync(towerPlaceId, playersArray, options)` with `options.ShouldReserveServer = true` and `options:SetTeleportData({ crewId = crewId })`.
3. Reads `ReservedServerAccessCode` and `PrivateServerId` from the result and writes them into the crew record.
4. Shows the **Clown Car teleport screen** (`TeleportService:SetTeleportGui` + client-side screen, see `10`).

### 4.2 Joining an existing run (rejoin, friend join, Quick Play fill)
- `TeleportOptions.ReservedServerAccessCode = record.accessCode`, then `TeleportAsync(towerPlaceId, {player}, options)`.
- Before teleporting, the hub checks `record.openSeats > 0` and that the player is allowed (privacy: Friends = host's friends or existing members; Invite = invited or existing members; Public = anyone not kicked).

### 4.3 Inside the Tower
- On server start, the Tower reads `crewId` from the **first** player's teleport data **only as a lookup key**, then loads the authoritative crew record from MemoryStore and the save from DataStore. Never trust teleport data for anything else (it is visible to clients).
- Validates `game.PrivateServerId == record.privateServerId`. If they don't match, the server refuses to load and sends players back to the hub.
- Players not in the record's allowed list are kicked back to the hub with a friendly message.

### 4.4 Returning to the hub
- `TeleportAsync(hubPlaceId, players)` (no reservation). The crew stays together as a group teleport where possible.
- The hub shows a "Welcome back" card with the run result and Stars earned, then the PLAY button.

### 4.5 Teleport safety (required)
- Wrap every teleport in a retry helper: up to 3 attempts with backoff (1 s, 2 s, 4 s) on `TeleportInitFailed`, following Roblox's documented safe-teleport pattern.
- Teleports don't work in Studio; build a **Studio mock** that simulates the flow in a single place (load the Tower content in the hub test session) so the agent can test without publishing.

## 5. MemoryStore schemas

### 5.1 `Crews` (MemoryStoreHashMap), key = `crewId`, TTL 2 hours, refreshed every 30 s by the Tower server
```lua
{
  crewId = "uuid",
  hostUserId = 123,
  privacy = "Friends" | "Invite" | "Public",
  members = { 123, 456 },        -- userIds currently in the run
  allowed = { 123, 456, 789 },   -- invited/previous members
  kicked = { 999 },
  openSeats = 4,
  state = "DAY" | "NIGHT" | ...,
  night = 3,
  floor = "F1_MIDWAY",
  rulesDefault = true,
  accessCode = "...",            -- ReservedServerAccessCode
  privateServerId = "...",
  saveSlot = 2,
  heartbeat = 1730000000,        -- os.time()
}
```

### 5.2 `OpenCrews` (MemoryStoreSortedMap), key = `crewId`, TTL 60 s, refreshed every 15 s while the crew is Public with open seats
- Sort key: priority score (lower is better): `stateRank * 100 + night * 10 + (6 − members)`.
- Value: `{ accessCode, openSeats, night, state, regionHint, languageHint }`.

### 5.3 `UserCrew` (MemoryStoreHashMap), key = `userId`, TTL 2 hours
- `{ crewId }` for the run the user is currently in, used for the **Rejoin your crew** button.

### 5.4 Limits and failure handling
- MemoryStore has request quotas; batch reads, cache results in the hub for 5 s, and back off on throttling.
- If MemoryStore is unavailable: Quick Play creates a new crew (no search); Rejoin shows "Try again in a moment"; friends can still join through the friends panel if the record was cached.

## 6. Friends joining friends
- Hub friends panel lists friends in the experience. If a friend is in a Tower run with an open seat and privacy allows, show **Join** → teleport via access code.
- Roblox's own "Join" on a friend's profile lands in the friend's **hub** server, or, if the friend is in a reserved Tower server, Roblox can't follow them directly. Therefore, when a player arrives in the hub and their friend is in a joinable run, show a big toast: "Mia's crew has a seat! **Join**".

## 7. Server sizes and why
- Hub 30: lively without being chaotic; leaves room for groups of 6 to land together.
- Tower 6: matches the original's 1–6 players and the quota scaling table.

## 8. Private servers (paid)
- Private servers apply to the **hub** (start place). A private hub server lets a friend group hang out and launch crews; runs are still in reserved Tower servers. Price: see `15`.

## 9. Messages and errors (player-facing)
| Situation | Message |
| --- | --- |
| Teleport failed after retries | "The Clown Car broke down! Try again." + Retry button |
| Crew full | "That crew is full. Try Quick Play!" |
| Run ended | "That run is over. Start a new one?" |
| Kicked from a run | "You were voted out of that crew." |
| Server shutting down | "Midway closing for an update — your crew is saved." |

## 10. Analytics events (see `19`)
`hub_arrive`, `play_pressed`, `crew_created` (method: menu/booth/quick/party), `crew_launch` (size), `teleport_failed`, `quickplay_matched` (wait time), `rejoin_used`, `friend_join_used`.
