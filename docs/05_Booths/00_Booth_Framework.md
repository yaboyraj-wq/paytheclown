# 05.00 — Booth Framework (read before any booth file)

> All 17 booths are built on **one shared framework**. Each booth file only describes what is unique about that booth. If a booth file is silent on something, this framework decides it.

## 1. What a booth is

A booth is a self-contained mini-game on a pad on a tower floor. It has:
- a **3D model** (the stall, the machine, the props),
- a **control pad** where the Controller stands,
- a **watch zone** where teammates stand to spectate,
- a **rule card** (billboard UI above the booth),
- a **stake keypad** (screen UI shown to the Controller),
- the **mini-game** itself (3D, 2D overlay, or both),
- a **result presentation** (VFX, SFX, camera, toasts).

## 2. Booth lifecycle (server state machine)

```
IDLE → CLAIMED → STAKING → LOCKED → PLAYING → (PUSH_DECISION ↔ PLAYING) → RESOLVING → COOLDOWN → IDLE
```

| State | Entered when | Leaves when | Notes |
| --- | --- | --- | --- |
| `IDLE` | Spawned, or cooldown ended | A crew member steps on the pad / taps PLAY | Rule card shows "PLAY ME!" bounce |
| `CLAIMED` | Controller claims | Controller opens keypad (auto), or walks off pad for 5 s (→ IDLE) | Only one Controller (unless multi-seat) |
| `STAKING` | Keypad open | Controller presses GO with a valid stake (→ LOCKED), or cancels (→ IDLE), or 20 s idle (→ IDLE) | Big-stake approval happens here (see `03` §7.2) |
| `LOCKED` | Stake approved | Immediately → PLAYING after 0.6 s "stake fly" animation | Stake removed from jar now |
| `PLAYING` | Round starts | Round reaches a resolution point | Inputs accepted only now |
| `PUSH_DECISION` | Push booths only, after each step | PUSH (→ PLAYING next step) or BANK (→ RESOLVING), or 8 s timeout (→ auto BANK) | Auto-bank on timeout protects AFK/disconnected players |
| `RESOLVING` | Result known | 1.0–2.5 s result presentation finishes | Payout added to jar at the start of this state |
| `COOLDOWN` | Presentation done | 1.0 s | Prevents accidental double-starts |

Rules:
- Only the server changes booth state. Clients render state from a replicated `BoothState` (see `18`).
- Closing Bell: booths in `IDLE`/`CLAIMED`/`STAKING` go dark immediately. Booths in `LOCKED`/`PLAYING`/`PUSH_DECISION` get the 5-second grace; at the end of grace, `PUSH_DECISION` auto-banks, `PLAYING` resolves as a loss.

## 3. The randomness rule (Pillar 2)

**All randomness must be visible before the stake locks, or be created by the player's own input.** Concretely:
- Allowed: shuffling segment order on a wheel *before* staking (visible), choosing where gems flash (shown to the player), placing obstacles in a Rocket Ride course that the player can see ahead, choosing Bigsby's score in Ring Stack 21 (shown on the board before staking).
- Not allowed: a hidden roll after the player commits that decides win/lose, random "miss chance," random physics noise, rubber-banding, or secretly adjusting difficulty based on stake size.
- Physics must be deterministic for the same inputs within normal engine tolerances. Server-owned parts, no added noise.
- Every booth file states its **visible setup randomness** explicitly.

## 4. Server authority patterns

Pick the pattern named in each booth file.

### 4.1 Pattern A — Timing booths (Stop-the-Reels, Hi-Lo Meter, Strongman Spinner, Card Catch, Duck Derby, Big Top Juggle)
- The server owns the timeline: it sends `startServerTime` and the motion parameters (speeds, sequences). The client renders the motion locally from `workspace:GetServerTimeNow()`.
- The client sends input events with its `GetServerTimeNow()` timestamp.
- The server accepts an input if its timestamp is within `[now − (ping + 0.25 s), now + 0.05 s]` and evaluates the outcome at that timestamp using the same deterministic motion function.
- Inputs outside the window are rejected (treated as "no input"). Duplicate inputs are ignored.
- The motion function lives in a **shared** module so client and server compute identical positions.

### 4.2 Pattern B — Server physics booths (Hoop Wheel, Block Toss, Splat Wheel, Pinball Drop, Bowl to Nine)
- The client sends a **throw/launch request** with clamped parameters (aim angle, power 0–1, spin −1..1, or flipper press times).
- The server validates and clamps every parameter, spawns the projectile with **network ownership set to the server**, and simulates.
- Clients see the server simulation (with client-side visual smoothing only — never client-side authority).
- Results are read by the server from physics (which cup the ball rests in, which face is up) after the objects settle (velocity < threshold for 0.5 s) or after a max time (then the nearest valid result is taken).

### 4.3 Pattern C — Discrete choice booths (Ring Stack 21 choices, Gem Recall, Pie Sweeper, Funhouse Ladder, Penguin Crossing moves, Rocket Ride steering)
- The client sends choices (tile index, door index, lane step, steer direction). The server holds all hidden state (gem positions after the flash, pie positions, which door is the Boo) and never sends it to the client until it is revealed.
- For continuous steering (Rocket Ride, Penguin Crossing), the client sends steering input at up to 20 Hz; the server simulates the authoritative position and collisions; the client predicts locally for smoothness and corrects to the server.

## 5. The stake keypad (shared UI)

- Opens automatically when the Controller claims the booth.
- Shows: booth name, mini rule line, current jar, min and max stake (with Zap Wand bonus if active), a big stake number, buttons **−**, **+**, **MIN**, **¼**, **½**, **MAX**, and big **GO!**. Step size scales with the floor (F1: 10, F2: 100, F3: 500, F4: 2,000).
- Booth-specific choice row (if any) above GO (e.g., Hoop Wheel: COLOR or NUMBER; Gem Recall: number of picks 1–5).
- If the stake is Big, GO shows a little megaphone icon ("Crew will be told").
- Held-item hint: if the Controller holds an item that works here, a small badge appears ("Golden Ticket ready — use it?").
- See `10_UI_UX_Spec.md` for layout and style.

## 6. Cameras

- When a play starts, the Controller's camera smoothly moves to the booth's **play camera** (a fixed, readable framing defined per booth) in 0.4 s. On resolve, it returns over 0.4 s.
- Teammates in the watch zone get a **"Watch"** button that switches them to a spectator camera of that booth (same framing, slightly wider).
- Mobile: play cameras must frame the action inside the safe area with the on-screen buttons not covering it.

## 7. Inputs per platform

| Action | PC | Mobile | Console |
| --- | --- | --- | --- |
| Claim / play | E or click the PLAY prompt | Tap PLAY prompt | X / Square |
| Primary action (throw, stop, tap, catch) | Left click or Space | Tap the big action button | A / Cross (R2 also works) |
| Aim | Mouse | Drag on screen (left half) | Left stick |
| Power / charge | Hold and release primary | Hold and release action button | Hold and release A |
| Steer (Rocket, Penguin) | A/D or arrows | On-screen left/right buttons | Left stick |
| Push / Bank | 1 = Push, 2 = Bank (also buttons) | Two big buttons | Y = Push, B = Bank |
| Leave booth | Backspace / walk off | X button on UI | B (when not in PUSH_DECISION) |

Use `ContextActionService` and Roblox's input action system so bindings are defined once. Every on-screen button must be at least 56×56 px on a phone.

## 8. Easy Assist (tutorial only)

For a player's first play on their first Night 1 (`03` §11): target windows +25% wider, speeds −15%, rule card stays 4 s. Each booth file lists exactly which parameter changes. Easy Assist never applies after the tutorial night and never in the Showdown.

## 9. Showdown mode

Each booth file defines a **Showdown target** and **Showdown difficulty** (usually the Floor 4 row plus one step). In Showdown: no stake keypad, no items, no Foam Bat, no pushes beyond what the target requires. The crowd watches; the camera is cinematic.

## 10. Feel beats (every booth must have all four)

1. **Stake:** the stake number flies from the jar meter to the booth with a "ka-ching" and a ticket trail.
2. **Anticipation:** a rising sound, lights on the booth build, the camera pushes in slightly.
3. **Action:** instant feedback on the player's input on the same frame (sound + visual), even before the server confirms. If the server disagrees, the client corrects quietly (this should be rare with Pattern A/C).
4. **Reveal and reaction:** big readable result text ("x3!", "SPLAT!"), Tickets pour into the jar on a win, a gag on a loss, and a world reaction (crowd, Bigsby line, confetti).

Win tiers for presentation:

| Tier | Multiplier | Presentation |
| --- | --- | --- |
| Small | > 1x and < 2x | Small confetti, "Nice!" |
| Medium | 2x–4.99x | Confetti burst, crowd cheer |
| Big | 5x–9.99x | Screen-edge glow for the Controller, floor-wide horn, toast to crew |
| Huge | 10x+ | Slow-motion 0.5 s, fireworks over the booth, Bigsby reaction line, toast to crew, counts for "Huge Win" badge |

Loss gags rotate per booth (each booth file lists 3 gags).

## 11. Item hooks (implemented in `ItemService`; see `06_Items.md`)

Every booth must expose these hooks so items can work without booth-specific code where possible:

| Hook | Called when | Used by |
| --- | --- | --- |
| `onBeforeLock(play)` | Stake about to lock | Golden Ticket, Bubble Wrap, Zap Wand (max stake), Guardian Gnome (aura check) |
| `onPayout(play, multiplier)` → multiplier | Result known | Show-Off Bowtie, Fizz Pop, Karaoke Mic, Snapshot Camera, Hype Battery |
| `onLoss(play)` | Loss decided | Do-Over Balloon, Bubble Wrap, Guardian Gnome |
| `onWin(play)` | Win decided | Double Dare Horn, Token Magnet |
| `getDoOverState(play)` | Do-Over used | Returns the exact same setup to replay |
| `getDoubleDareChallenge(play)` | Double Dare used | Returns a short harder version (each booth file defines it) |

## 12. Foam Bat hooks

Booths that react to the Foam Bat define it in their file. Default: bonking a booth plays a "boing" and does nothing else. Bonking a booth's Controller is blocked (see `06_Items.md` Foam Bat rules).

## 13. Anti-abuse rules (all booths)

1. Inputs are only accepted in `PLAYING`/`PUSH_DECISION` from the current Controller.
2. Rate limit: max 20 input events per second per player per booth; extra events are dropped and flagged.
3. Throw parameters are clamped to valid ranges; out-of-range values are clamped and logged.
4. A play can't be started if the jar is below the floor minimum.
5. No booth can pay out more than `maxStakeWithZap × maxMultiplier` in one play (sanity cap; log if hit).
6. A disconnecting Controller: push booths auto-bank the last banked value; other booths resolve as a loss of stake (prevents rage-quit rerolls).
7. All results are logged with booth ID, inputs summary, multiplier and stake (see `16`, `19`).

## 14. Analytics events (every booth)

`booth_play_started`, `booth_play_resolved` (multiplier, stake, floor, night, crewSize, items used), `booth_push` (step), `booth_bank` (step), `booth_abandoned`. See `19_Analytics_and_KPIs.md`.

## 15. Accessibility

- Every timing booth has a visual cue and an audio cue for the timing window.
- Color is never the only signal (shapes or icons too). Color-blind-safe palettes for Splat Wheel and Hoop Wheel (patterns on segments).
- Text size meets the UI minimums in `10`.
- A "Reduce Flashing" setting dims strobing effects.

## 16. File template for each booth

Each booth file uses these headings in order:
1. Summary table (ID, replaces, floor, type, seats, authority pattern, round length)
2. Fantasy and look
3. How it plays (step by step)
4. Visible setup randomness
5. Payout table
6. Push ladder (if any)
7. Difficulty by floor
8. Easy Assist and Showdown
9. Items and Foam Bat
10. Edge cases and anti-abuse
11. Presentation (feel beats, loss gags, sounds)
12. Dares and badges tied to this booth
13. Build notes
