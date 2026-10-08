# Booth 03 — Stop-the-Reels

## 1. Summary
| Field | Value |
| --- | --- |
| ID | `STOP_REELS` |
| Replaces (original) | Slot Machine (a 10x jackpot chase) |
| First floor | F1 The Midway |
| Type | Timing |
| Seats | 1 Controller |
| Authority | Pattern A (server timeline) |
| Round length | 5–8 s |

## 2. Fantasy and look
A tall, chunky carnival machine with three big vertical reels behind glass, a giant red STOP button on the counter, and light bulbs around the frame. Symbols are carnival icons: Balloon, Popcorn, Star, Cotton Candy, Ticket, and **Sir Waddles** (the rare one). It must not look like a casino slot machine: no lever, no coin slot, no "777," no cherries or bars.

## 3. How it plays
1. Set stake, GO. All three reels start spinning at the floor's speed.
2. Press the action button to stop **reel 1**, then **reel 2**, then **reel 3**. Each reel stops on the symbol under the center line at the moment you press (with a 0.12 s settle animation that never changes the result).
3. Result by the three symbols on the center line.
4. If you don't press within 6 s, reels stop automatically one by one (at their current position).

## 4. Visible setup randomness
- Each reel has a fixed **strip** of 12 symbols per night (seeded shuffle). The strip is printed on a small card beside the machine, so skilled players can learn it.
- Reel starting offsets are chosen per play before GO. The keypad preview shows every strip and its starting symbol before the stake locks.
- Nothing random after commitment or after a press (AGENTS §2.2).

## 5. Payout table
| Center line | Multiplier |
| --- | --- |
| Sir Waddles × 3 | 10x |
| Star × 3 | 5x |
| Any other symbol × 3 | 3x |
| Any 2 matching (any position) | 1.2x |
| No match | 0x |

Each reel strip of 12 contains: Sir Waddles ×1, Star ×2, Balloon ×2, Popcorn ×2, Cotton Candy ×2, Ticket ×3.

## 6. Push ladder
None.

## 7. Difficulty by floor
| Floor | Reel speed (symbols/second) | Speed pattern |
| --- | --- | --- |
| F1 | 6 | constant |
| F2 | 8 | constant |
| F3 | 9 | gentle speed wobble ±10% on a 1.5 s cycle (deterministic) |
| F4 | 11 | wobble ±15% on a 1.2 s cycle; reel 3 spins 10% faster |
| Showdown | 12 | as F4 |

## 8. Easy Assist and Showdown
- Easy Assist: speed −15%, and the center window shows a soft highlight on the symbol that will stop if you press now.
- Showdown target: any **3 of a kind**.

## 9. Items and Foam Bat
- **Do-Over Balloon:** same strips, same starting offsets.
- **Double Dare Horn challenge:** stop one reel only, at +30% speed, on Sir Waddles. Hit = ×3 of original win.
- **Fizz Pop:** the screen wobble makes timing harder; payout bonus applies.
- Foam Bat: bonking the machine makes it "hiccup" (a visual shake), no effect on results.

## 10. Edge cases and anti-abuse
- Pattern A input window per `00_Booth_Framework.md` §4.1.
- Reel positions are computed by a shared pure function `reelSymbolAt(strip, startOffset, speedFn, t)`; server evaluates the press time.
- Multiple presses within 0.1 s count once.

## 11. Presentation
- Anticipation: each stopped matching symbol makes the next reel's border glow ("two Stars… one more!").
- Action: big chunky "CLUNK" per stop, the button squashes.
- Win: lights chase, symbols bounce, a bell rings; Sir Waddles triple triggers a quack choir.
- Loss gags: (1) the machine burps popcorn, (2) a tiny "Nope" flag pops out, (3) Sir Waddles peeks from the top and shakes his head.

## 12. Dares and badges
- Dare "Popcorn Party": get 3 of a kind (Easy).
- Dare "Waddle Jackpot": get 3 Sir Waddles (Hard).
- Badge "Royal Quack": 3 Sir Waddles on Floor 3 or higher.

## 13. Build notes
- Reels can be SurfaceGui or 3D parts with a texture strip scrolled by UV offset; SurfaceGui with ImageLabels is simplest and crisp.
- Keep the strip card UI generated from the same strip data (single source).
