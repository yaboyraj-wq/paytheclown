# Booth 10 — Rocket Ride

## 1. Summary
| Field | Value |
| --- | --- |
| ID | `ROCKET_RIDE` |
| Replaces (original) | Crash (a multiplier climbs; cash out before it crashes) |
| First floor | F2 Neon Arcade |
| Type | Steering + nerve (continuous push) |
| Seats | 1 Controller |
| Authority | Pattern C (server-simulated flight, client prediction) |
| Round length | 5–25 s |

## 2. Fantasy and look
A carnival ride cockpit facing a big arcade screen. On screen: a cartoon rocket flies up through a neon sky full of obstacles (balloons, birds, UFOs, stars). The multiplier is painted huge on the screen and climbs. A giant red EJECT lever sits next to the seat. A 3D version of the rocket on a pole beside the booth bobs up as the multiplier climbs (spectator fun).

## 3. How it plays
1. Set stake, GO. Countdown 3-2-1, liftoff.
2. The rocket flies upward automatically. The player steers **left/right** to dodge obstacles.
3. The multiplier rises over time: `m(t) = 1.0 + 0.10t + 0.025t²` (t in seconds), shown with two decimals.
4. Press **EJECT** any time → bank at the current multiplier.
5. Hit an obstacle → crash → lose the stake.
6. The course gets denser and faster as time passes.

## 4. Visible setup randomness
- The obstacle course is generated per play from a seed. The player sees obstacles about 2 seconds ahead (they scroll down the screen). No obstacle appears closer than 1.2 s of travel ahead.
- No hidden crash point. You only crash if you hit something.

## 5. Payout
- Bank = stake × multiplier at the server time of the EJECT input.
- Crash = 0x.
- Hard ceiling: at 25x the rocket reaches "the Moon" and auto-banks at 25x.

## 6. Push ladder
Continuous: every moment in flight is a push; EJECT is the bank.

## 7. Difficulty by floor
| Floor | Rocket lateral speed | Obstacle density growth | Obstacles visible ahead |
| --- | --- | --- | --- |
| F2 | 14 studs/s (screen space) | slow | 2.0 s |
| F3 | 13 | medium | 1.8 s |
| F4 | 12 | fast | 1.6 s |
| Showdown | 12 | fast | 1.5 s |

## 8. Easy Assist and Showdown
- Easy Assist: obstacles −25% density; visible ahead +0.5 s.
- Showdown target: **eject at 5.0x or more**.

## 9. Items and Foam Bat
- **Guardian Gnome** nearby: a crash refunds the stake.
- **Bubble Wrap:** a crash returns 50% of the stake (see `06`).
- **Do-Over Balloon:** after a crash, re-fly the same seed.
- **Double Dare Horn challenge:** relaunch at the banked multiplier and survive 3 more seconds. Success = ×3 of banked win.
- **Fizz Pop:** controls get slightly jittery, payout bonus applies.
- Foam Bat: no effect.

## 10. Edge cases and anti-abuse
- Server simulates the authoritative rocket x-position from steering inputs (20 Hz max) and checks collisions with the seeded obstacle set.
- Client predicts locally; if the server detects a collision the client didn't, the server wins (show crash).
- EJECT input timestamp is accepted per Pattern A window; multiplier is computed at that server time, capped at the multiplier at the moment of the input's arrival.
- Disconnect → auto-EJECT at the multiplier at disconnect time.

## 11. Presentation
- Anticipation: countdown, engine rumble, cockpit shake builds with the multiplier.
- Action: whooshes as obstacles pass; near-miss "WHOA!" text when dodging within 0.5 studs.
- Win: parachute opens, the rocket lands on a prize pile; Tickets spray.
- Loss gags: (1) rocket pops like a balloon and the pilot floats down on an umbrella, (2) rocket gets swallowed by a giant cartoon cloud that sneezes, (3) rocket bonks a UFO, which honks angrily.

## 12. Dares and badges
- Dare "Greed Test": eject at 10x or higher (Hard).
- Dare "Safe Exit": eject successfully 4 times in a row (Medium).
- Badge "To The Moon": reach 25x.

## 13. Build notes
- The screen can be a SurfaceGui with a 2D simulation (simplest, crisp). The multiplier and obstacles are 2D sprites.
- Keep `m(t)` and obstacle generation in shared modules.
