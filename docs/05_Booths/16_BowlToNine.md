# Booth 16 — Bowl to Nine

## 1. Summary
| Field | Value |
| --- | --- |
| ID | `BOWL_TO_NINE` |
| Replaces (original) | Baccarat (race the dealer to a total of 9; only the last digit counts) |
| First floor | F4 The Big Top |
| Type | Aim (precise bowling) |
| Seats | 1 Controller |
| Authority | Pattern B (server physics) |
| Round length | 10–16 s |

## 2. Fantasy and look
A short circus bowling lane with 10 bowling pins dressed as tiny clowns. Bigsby's scoreboard on the side shows **his score** (0–9) for the round. The player bowls a big striped ball.

## 3. How it plays
1. Before staking, Bigsby's score (0–9) is shown. Set stake, GO.
2. **Ball 1:** aim (lane position + angle) and power; bowl. Pins knocked = your count.
3. If your count is 8 or 9 after ball 1, it's a **Natural** → resolve now.
4. Otherwise, choose **STAND** or **BOWL AGAIN** (ball 2 at the remaining pins).
5. Your score = total pins knocked **mod 10** (a strike = 10 → 0; 9 pins = 9).
6. Compare with Bigsby's score.

## 4. Visible setup randomness
- Bigsby's score per round is random (weights favor 5–7) and shown before staking.
- Pins always start in the same rack.

## 5. Payout table
| Result | Multiplier |
| --- | --- |
| Natural 9 (exactly 9 pins with ball 1) | 2.5x |
| Your score > Bigsby's | 2.0x |
| Tie | 1.0x |
| Your score < Bigsby's | 0x |

Knocking all 10 (a strike) scores 0 — the joke is that a "perfect" bowl is the worst result. Teach this on the rule card: "Strike = 0! Aim for 9."

## 6. Push ladder
None.

## 7. Difficulty by floor
| Floor | Lane length | Ball weight | Pin stability |
| --- | --- | --- | --- |
| F4 | standard | standard | standard |
| Showdown | +10% | standard | slightly wobblier |

(Bowl to Nine appears only on F4 and later.)

## 8. Easy Assist and Showdown
- Easy Assist: aim guide line shows the ball's predicted path.
- Showdown target: **score exactly 9** (any way).

## 9. Items and Foam Bat
- **Do-Over Balloon:** reset pins and bowl again.
- **Double Dare Horn challenge:** one ball; knock exactly 9 pins. Win = ×3 of original win.
- **Foam Bat:** a teammate can bonk one standing pin once per round after ball 1 settles (knocks it down). Changes your count by +1 — useful to go from 8 to 9, or a disaster from 9 to 10!

## 10. Edge cases and anti-abuse
- Server-owned ball and pins. A pin counts as knocked if tilted more than 45° or moved off its spot by > 1 stud after settling.
- Settling: wait until all pins' speeds < 0.3 studs/s for 0.5 s, max 6 s.

## 11. Presentation
- Anticipation: pins nervously wobble; crowd hush.
- Action: thunderous rolling sound; pins shout "WAH!" as they fall.
- Win: pins stand back up and bow.
- Loss gags: (1) a strike plays a sad trombone and "STRIKE = ZERO!" sign, (2) the ball comes back on its own and bonks the player gently, (3) Bigsby bowls a perfect 9 on his own lane (animation only).

## 12. Dares and badges
- Dare "Nine Lives": get a Natural 9 (Medium).
- Badge "Gutter Genius": win after bowling a gutter ball with ball 1.
