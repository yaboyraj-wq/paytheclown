# 10 — UI and UX Specification

> The UI must feel like a top Roblox game: chunky, bright, animated, readable in 3 seconds on a phone, and consistent everywhere. **Every screen is built from the UI kit in section 3.** No one-off styles.

## 1. Style: "Carnival Poster"

Think vintage circus posters made friendly and modern: chunky rounded panels, thick dark outlines, warm cream backgrounds, red-and-gold headers, playful bouncy motion, ticket-stub shapes, light-bulb borders on important frames. Not a casino: no green felt, no chips, no cards-and-dice ornaments, no slot-machine fonts.

## 2. Design tokens (put these in `Shared/Config/UITheme.luau`)

### 2.1 Colors
| Token | Hex | Use |
| --- | --- | --- |
| `Ink` | `#2B1B3D` | Outlines (UIStroke), primary dark text |
| `Cream` | `#FFF4DC` | Panel backgrounds |
| `CreamShade` | `#F2E1BC` | Panel inner sections, disabled fills |
| `CarnivalRed` | `#E63946` | Headers, primary buttons |
| `Gold` | `#FFC93C` | Tickets, highlights, secondary buttons, Stars |
| `NightPurple` | `#3A1F5D` | Full-screen backgrounds, overlays (at 70% opacity for dimming) |
| `Teal` | `#2EC4B6` | Tokens, info, "Approve" |
| `WinGreen` | `#3DDC84` | Win states, quota met |
| `LossRed` | `#FF5A5F` | Loss states, timer warning |
| `White` | `#FFFFFF` | Text on red/purple |
| F2 accents | `#00E5FF`, `#FF2DAA` | Neon Arcade floor HUD accents |
| F3 accents | `#7B2CBF`, `#A3E635`, `#FF8C42` | Funhouse floor HUD accents |
| F4 accents | `#1D3557`, `#F8F9FA` | Big Top floor HUD accents |

The HUD frame color subtly shifts to each floor's accent (border glow), keeping the base kit the same.

### 2.2 Typography (Roblox built-in fonts; verify names in Studio)
| Role | Font | Notes |
| --- | --- | --- |
| Display (titles, big results) | Luckiest Guy | All caps, Ink stroke 3 px |
| Numbers (jar, timer, prices) | Fredoka One | Tabular feel; always formatted (1.2K, 3.4M) |
| Body (descriptions, settings) | Builder Sans (Bold/Medium) | Most readable on small screens |

### 2.3 Shape and depth
| Token | Value |
| --- | --- |
| Corner radius | 16 px panels, 12 px buttons, 999 px pills |
| Outline (UIStroke) | 3 px `Ink` on panels and buttons; 2 px on small chips |
| Drop shadow | Offset (0, 6 px) solid `Ink` at 35% (a duplicated frame behind, not blur) |
| Spacing scale | 4, 8, 12, 16, 24, 32 px |

### 2.4 Sizing system (how to make it look right on every device)
- Author UI in **offset pixels at a reference resolution of 1280×720** inside a root frame with a **UIScale** computed at runtime: `scale = clamp(min(viewportX/1280, viewportY/720), 0.6, 1.5)`. Re-compute on viewport changes.
- Anchor everything with `AnchorPoint` + scale positions to screen edges/corners; sizes in offset × UIScale. This is more predictable than pure Scale sizing.
- Respect the **safe area** (`ScreenGui.ScreenInsets = DeviceSafeInsets` for HUD roots; full-bleed only for backgrounds).
- Minimum touch target: 56×56 px at reference (on a phone after scaling, never below 44 px physical).
- Minimum text: 18 px at reference for body, 14 px absolute floor after scaling.
- Test matrix: 1920×1080 PC, 1280×720 PC, iPhone landscape (notch), small Android landscape (~800×360), tablet 4:3, console 10-foot (bigger text via a "Console" UIScale bump of +15%).

## 3. UI kit (build these components first)

| Component | Variants | Behavior |
| --- | --- | --- |
| `Button` | Primary (red), Secondary (gold), Approve (teal), Danger (loss red), Ghost (cream) ; sizes S/M/L/XL | Hover: scale 1.05 + brighten; Press: squash to 0.92 for 80 ms then spring back; click sound; disabled = CreamShade + 50% text |
| `Panel` | Cream with red header bar; header holds title + close X | Opens with scale 0.85→1 + fade 160 ms (Back easing); closes 120 ms |
| `TicketCounter` | Jar size, chip size | Numbers roll up/down over 400 ms with ease-out; +/− delta pops above in green/red |
| `CurrencyChip` | Tickets (gold ticket icon), Tokens (teal coin), Stars (gold star) | Pulse when value changes |
| `JarMeter` | HUD only | See §5.3 |
| `Timer` | Normal, Final Call (red pulse), Last 10 s (shake) | |
| `Toast` | Info, Win, Loss, Crew action, Purchase | Slides in from right, stacks max 3, 3 s life |
| `Card` | Item card, Dare card, Cosmetic card, Save slot card | Hover tilt (PC), tap select |
| `Keypad` | Stake keypad | See §5.6 |
| `Modal` | Confirm, Vote | Dims background (NightPurple 70%) |
| `ProgressBar` | Ticket-perforation style | |
| `Portrait` | Crew portrait with sash color ring and status badges | |
| `IconBadge` | Small round icons for status (holding item, pawned piece, VIP) | |
| `Tooltip` | PC hover, mobile long-press | |

Implementation: use **React (react-lua via Wally)** components or a small in-house component module; either way, one component per kit item, themed from `UITheme`. All strings from the localization table.

## 4. Motion and sound rules

| Event | Motion | Sound |
| --- | --- | --- |
| Button press | Squash 0.92, spring back (stiffness high) | Soft "pop" |
| Panel open/close | Scale + fade, 160/120 ms | Whoosh in / whoosh out |
| Currency change | Roll numbers 400 ms; chip bounce | Ticket "ka-ching" (gain), "thunk" (spend) |
| Toast | Slide 200 ms, out 150 ms | Light chime (type-specific) |
| Big win | Screen-edge glow 600 ms, text punch-scale 1.4→1.0 | Win sting (tiered) |
| Error | Horizontal shake 6 px ×3, 200 ms | Low "bonk" |

Respect **Reduce Motion** (settings): replace scale/shake with fades. Respect **Reduce Flashing**.

## 5. Screens (every screen in the game)

### 5.1 Loading screen (first join, `ReplicatedFirst`)
- Remove the default loading screen. Show: NightPurple background with slow drifting fog, string lights at top, the **logo** bouncing in, and a **ticket-shaped progress bar** that "tears" along perforations as it fills.
- Rotating tips (one line each): "Strike = 0 at Bowl to Nine!", "Zap before the Golden Ticket!", "Gnome + Block Toss = no losses!".
- Sir Waddles waddles across the bottom on a loop.
- Preload only critical assets (`ContentProvider:PreloadAsync` on logo, HUD icons, fonts) with a hard cap of 6 s; then a curtain-open transition reveals the hub.
- Target: the player can press PLAY within 8 s of the game opening on a mid phone.

### 5.2 Teleport screen (Clown Car)
- Used when leaving the hub for the Tower and returning: `TeleportService:SetTeleportGui` with the same visuals, then the destination's `ReplicatedFirst` shows the same screen until the character is loaded.
- Visual: side view of the tiny Clown Car driving along a night road under string lights, honking, crew portraits in the car windows. Caption: "Heading to Lot 13…" / "Back to the Gates…".

### 5.3 Run HUD (Lot 13 and nights)
```
┌──────────────────────────────────────────────────────────────────────────┐
│ [Crew strip: portraits]        [ JAR 12,450 ]  [⏱ 3:42]     [⚙][🛒]    │
│                                [■■■■■■■□□ Quota 15,500]                  │
│                                [Dare: Lucky 7 ☐]                         │
│                                                                          │
│                                                                          │
│ [Quick-chat]                                     [Item slot] [Toasts ↑]  │
└──────────────────────────────────────────────────────────────────────────┘
```
- **Jar meter (top center):** a glass jar icon with a gold Ticket counter. Below it the **quota bar**: fill = jar ÷ quota, a notch at 100%. Fill color: LossRed below 50%, Gold 50–99%, WinGreen ≥ 100% with a sparkle. The jar icon fills and sloshes with value changes. **This is the most important element in the game; give it the best animation and sound.**
- **Timer (right of jar):** ticket-stub shaped. Turns red with a pulse at Final Call; shakes in the last 10 s. During Day it shows "DAY" and the Clown Car ready count (e.g., "Car 2/4").
- **Crew strip (top-left):** portraits with sash color, a tiny icon for: held item, at a booth (booth icon), pawned pieces, READY (Day), Rookie. Tap a portrait → small card with their name and current activity.
- **Dare tracker:** under the quota bar; shows progress ("2/3").
- **Item slot (bottom-right, above mobile jump button):** held item icon; tap = use; long-press/hover = description; small drop button.
- **Quick-chat wheel (bottom-left button):** opens a radial menu with 8 lines + icons: "STOP!", "BANK IT!", "PUSH!", "Help me!", "Over here!", "Nice!", "Oops…", "Approve?". Each shows as a speech bubble with its icon over the player. Works for everyone (including players without text chat). Uses predefined, localized strings only.
- **Settings and Shop** buttons top-right.

### 5.4 Day Card
A center poster card (cream, red header "DAY 4"), lines: Tonight's floor (with floor icon), Quota (big number), Tonight's booths (7 icons). Stays 3 s, then animates into the HUD.

### 5.5 Booth rule card (BillboardGui above each booth)
- Booth name in Display font, one rule line (≤ 12 words), the key payout chips ("COLOR 2x · NUMBER 10x"), and a state badge: PLAY ME! / IN USE (name) / CLOSED.
- Max distance 60 studs; scales with distance; always readable.

### 5.6 Stake keypad (screen UI for the Controller)
```
┌─────────────── ROCKET RIDE ───────────────┐
│ Eject before you crash!                     │
│ Jar 12,450      Min 100 · Max 5,000 ⚡10,000  │
│        [ − ]   [   2,500   ]   [ + ]        │
│ [MIN] [¼] [½] [MAX]                         │
│ (booth choice row, if any)                  │
│ [Item: Golden Ticket — USE?]                │
│               [   GO!   ] 📣                │
└────────────────────────────────────────────┘
```
- Bottom-center panel on mobile (thumb-reachable), right side on PC.
- 📣 icon when the stake is Big (crew will be told).
- Disabled GO with reason text if invalid ("Not enough in the jar").

### 5.7 Big-stake toast (to teammates)
Large toast at the top-center: "[Portrait] Mia wants to stake **40%** of the jar at Rocket Ride!" with **Approve** (teal) and **No way** (red), 5-second ring timer. If approval is off, just the message and a "😱" button that sends a reaction.

### 5.8 Result popups (near the booth on screen)
- Win: big multiplier text ("x3!") punches in, Tickets amount in gold, confetti. Tier rules: `05_Booths/00_Booth_Framework.md` §10.
- Loss: the booth's loss gag + small "−2,500" in LossRed.
- Push decision: two huge buttons **PUSH (next: x2.4)** and **BANK (x1.9 · +4,750)** with an 8-second ring.

### 5.9 Shops and stations
- **Sal's Shop:** Panel with 6 item cards in a 3×2 grid (2×3 on phone), Token wallet chip, REROLL button with price, BUY on each card. Owned/stashed counter strip at the bottom showing what's on the counter.
- **Dare Board:** 3 dare cards (Easy/Medium/Hard color tabs: teal/gold/red), each with reward (Tokens + Stars), ACCEPT button, REROLL button.
- **Pawn Clamp:** 3 big piece cards (Shades, Voice Box, Shoes) showing payout, penalty in one line, and state (Pawned / Buy back for N).
- **Bill Box:** big thermometer of Bill remaining, a deposit slider (min 100, max = jar − tonight's quota), DEPOSIT button with confirm.
- **Thrift Tent:** category tabs left, item grid right, try-on mirror preview, price chips (Stars and/or Robux), Equip/Buy buttons, Featured rack banner.
- **Crew Trailer:** rules card, crew list, stats, Photo Wall gallery, Leave/Invite/Vote kick.

### 5.10 Night summary (after success)
A poster-style panel: "NIGHT 6 SURVIVED!" header; rows: Quota paid, Jar left, Won tonight, Lost tonight; award cards (MVP, Biggest Loser, Daredevil) with avatar headshots; Dare result; Tokens +N (crew), Stars +N (you). Buttons: **Continue** (majority vote shows count), auto-continue after 15 s.

### 5.11 Cannon summary (after fail)
"THE CROWD LOVED IT!" header over the cannon replay; nights survived, best night, total won; Stars earned; **Keep the Lights On** offer card (49 Robux; see `15`) with a 10-second ring; then **Play Again** / **Back to Gates**.

### 5.12 Final Choice, Showdown, Ending
- Final Choice: two giant poster buttons **PAY THE CLOWN** (gold) and **SHOWDOWN!** (red), vote counters under each, 20-second timer, the remaining Bill vs jar shown as two big numbers.
- Showdown: round tracker (3 circles), performer portrait, booth rule card, target line ("Land 5x or better!"), crowd meter.
- Ending: full-screen cutscene with skip after 3 s (after first view), then a **crew photo** pose and a score card; buttons: Endless Nights / Play Again / Back to Gates.

### 5.13 Hub screens
- **Play menu:** three big cards: **Quick Play** (fastest; "Join a crew now"), **New Crew**, **Continue** (with save count). Plus "Friends' crews" list.
- **New Crew:** slot picker → rules (toggles; "Start with defaults" shortcut) → privacy → lobby panel (crew list, Invite, START).
- **Daily calendar**, **Carnival Pass**, **Badges/Collection**, **Codes**, **Settings** panels.

### 5.14 Settings
Music volume, SFX volume, Voice line volume, Camera shake (on/off), Reduce Motion, Reduce Flashing, Color-blind patterns (on by default), Show crew stake toasts (on/off for non-Big stakes), Allow bat bonks on me, Quick-chat only mode (hides text chat bubbles), Language (follows Roblox setting), Graphics hint ("Lower Roblox graphics for smoother play").

## 6. Store and purchase UX (see `15` for products)
- Shop button always visible; never pops up a store during a night.
- Prices fetched at runtime from `MarketplaceService:GetProductInfoAsync` / `GetDeveloperProductsAsync` so **Managed Pricing / regional prices display correctly**. Never hard-code Robux prices in UI.
- Purchase flow: tap item → preview → Roblox purchase prompt → on success, a celebration (confetti, item equipped). On failure/cancel, no nagging.
- Starter Pack appears once after a player's first run ends (cannon or ending), then lives in the store.

## 7. Localization
- Every string in a `LocalizationTable` with keys (e.g., `HUD.JAR`, `BOOTH.ROCKET.RULE`). Enable Roblox automatic translation for supported languages and review the top 5 languages from analytics.
- Number formatting via one function (`Format.tickets(n)`: 999 → "999", 1,250 → "1.2K", 3,400,000 → "3.4M").
- Design for 30% longer text (German/Portuguese): buttons auto-size or shrink text to fit (`TextScaled` with `UITextSizeConstraint` min/max).

## 8. Accessibility
- Color + shape for every state.
- Reduce Motion, Reduce Flashing, Camera Shake toggles.
- Captions for voice lines (on by default).
- Controller navigation: every screen has a default `GuiService.SelectedObject` and logical `NextSelection*` links.
- Timers show numbers, not just bars.

## 9. Things that make UI look cheap (never do)
- Default Roblox fonts like Arial/SourceSans, default gray frames, unstyled TextButtons.
- Text baked into images (blurry, can't translate).
- Mixed icon styles (all icons share one style: thick outline, flat color, slight top highlight).
- Popups that block play during a night.
- Static screens: anything that changes must animate.
- More than 3 toasts at once.
