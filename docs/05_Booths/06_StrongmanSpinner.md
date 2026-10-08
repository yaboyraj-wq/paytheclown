# Booth 06 — Strongman Spinner

## 1. Summary
| Field | Value |
| --- | --- |
| ID | `STRONGMAN_SPINNER` |
| Replaces (original) | Wheel of Fortune (a big spinning wheel; the original's version was pure luck) |
| First floor | F1 The Midway |
| Type | Timing (power meter) |
| Seats | 1 Controller |
| Authority | Pattern A (server computes spin from power) |
| Round length | 6–9 s |

## 2. Fantasy and look
A tall vertical prize wheel mounted on a strongman frame. The player swings a giant mallet onto a striker plate; the hit power spins the wheel. Segments are painted with multipliers. A pointer clacks against pegs as the wheel slows.

## 3. How it plays
1. Set stake, GO.
2. A **power meter** sweeps up and down beside the mallet. Press to swing at the current power.
3. The wheel spins with an initial speed proportional to power and decelerates with fixed friction. The final segment is a deterministic function of power: `finalAngle = startAngle + rotations(power)`.
4. The segment under the pointer when the wheel stops is the result.

## 4. Visible setup randomness
- The wheel's segment order is shuffled per night (seeded) and is visible.
- The wheel's **start angle** for each play is random and visible before the swing (the wheel sits still until you hit).
- The power→distance mapping is fixed and learnable (a skilled player learns "a 72% hit is about 2.5 turns").

## 5. Payout table (segments on a 24-slot wheel)
| Segment | Slots | Multiplier |
| --- | --- | --- |
| Pie (lose) | 8 | 0x |
| Small | 7 | 1.5x |
| Double | 5 | 2x |
| Triple | 2 | 3x |
| Five | 1 | 5x |
| Ten | 1 | 10x |

## 6. Push ladder
None.

## 7. Difficulty by floor
| Floor | Meter speed (sweeps/s) | Meter resolution | Wheel friction |
| --- | --- | --- | --- |
| F1 | 0.8 | smooth | high (fewer rotations, easier to read) |
| F2 | 1.0 | smooth | medium |
| F3 | 1.2 | smooth, with a 0.2 s pause at the top (deterministic) | medium-low |
| F4 | 1.5 | smooth | low (more rotations, harder to aim) |
| Showdown | 1.6 | smooth | low |

## 8. Easy Assist and Showdown
- Easy Assist: meter speed −15%; the 2x segments are 1 slot wider (6 slots).
- Showdown target: land **5x or 10x**.

## 9. Items and Foam Bat
- **Zap Wand**, **Golden Ticket**, **Bubble Wrap**: standard.
- **Do-Over Balloon:** same start angle and segment order.
- **Double Dare Horn challenge:** one more swing; must land 3x or better. Win = ×3 of original win.
- Foam Bat: bonking the wheel while it spins adds a small fixed slowdown (−5% speed, once per spin). Learnable trick, like the Block Toss bonk. Only a teammate can do it, within the spin.

## 10. Edge cases and anti-abuse
- The server computes the spin from the accepted input's power value (Pattern A). The client animates the same function.
- Bat bonk timing is evaluated on the server at the bonk's accepted timestamp.

## 11. Presentation
- Anticipation: the mallet glows as the meter nears the top; a heartbeat drum as the wheel slows.
- Action: huge "DONG!" when the mallet hits; pointer "clack-clack-clack."
- Win: the segment lights; the strongman bell rings; Ten triggers fireworks.
- Loss gags: (1) a pie launches from the wheel into the Controller's face (cosmetic splat on screen for 1 s), (2) the mallet head falls off, (3) the wheel wobbles and sighs.

## 12. Dares and badges
- Dare "Spin The Wheel": win 3 spins with stakes above 25% of the max in one night (Medium).
- Dare "Keep It Spinning": stake a total of 10× the floor max across spins in one night (Hard).
- Badge "Ten Out of Ten": land the 10x segment on Floor 3 or higher.

## 13. Build notes
- Implement as a pure function `spinResult(power, startAngle, frictionParams) → segmentIndex` shared by client and server.
- Make sure the pointer's visual "clacks" are derived from the same function so the animation always ends where the server says.
