# Booth 01 — Hoop Wheel

## 1. Summary
| Field | Value |
| --- | --- |
| ID | `HOOP_WHEEL` |
| Replaces (original) | Roulette (bet on a color or a number) |
| First floor | F1 The Midway |
| Type | Aim + timing (physics) |
| Seats | 1 Controller |
| Authority | Pattern B (server physics) |
| Round length | 6–9 s |

## 2. Fantasy and look
A big horizontal spinning wheel lying flat like a giant record, ringed with 12 small numbered cups and two wide colored lanes (Red and Gold) between the cups and the hub. Striped awning, light bulbs around the rim, a chalkboard showing the last 8 results. The player throws a rubber ball from a short counter. The ball bounces, rolls and settles into a lane or a cup.

## 3. How it plays
1. Keypad: choose **COLOR** (then pick Red or Gold) or **NUMBER** (then pick a cup 1–12). Set stake. GO.
2. The wheel spins at the floor's speed. An aim arc appears from the counter.
3. Player aims (mouse/drag/stick) and holds to charge throw power; release to throw.
4. The ball flies, lands on the wheel, rolls with the wheel's rotation, and settles in:
   - a cup (number result; the cup's color counts as its lane color), or
   - a lane (color result only; no number).
5. Result: if COLOR chosen and the ball settled in that color (lane or cup of that color) → win. If NUMBER chosen and the ball settled in that exact cup → win.

## 4. Visible setup randomness
- Cup order around the rim is shuffled each night (seeded). The layout is visible before staking.
- Wheel spin direction (clockwise/counter-clockwise) is chosen per play and shown by arrows before GO.
- Nothing random after the throw.

## 5. Payout table
| Choice | Win condition | Multiplier |
| --- | --- | --- |
| COLOR | Ball settles in chosen color (lane or same-colored cup) | 2.0x |
| NUMBER | Ball settles in the chosen cup | 10x |
| Either | Ball falls off the wheel (overthrow) | 0x |

## 6. Push ladder
None.

## 7. Difficulty by floor
| Floor | Wheel speed (rpm) | Cup width (studs) | Lane widths | Aim arc shown |
| --- | --- | --- | --- | --- |
| F1 | 8 | 1.6 | Red 50% / Gold 50% | Full arc |
| F2 | 11 | 1.4 | 50 / 50 | Full arc |
| F3 | 14 | 1.25 | 50 / 50, lanes slightly narrower (rim bumper 10% wider) | Half arc |
| F4 | 17 | 1.1 | 50 / 50, rim bumper 20% wider | Start of arc only |
| Showdown | 18 | 1.1 | — | Start of arc only |

The "rim bumper" is a neutral band (counts as a loss for COLOR) that widens on higher floors to keep COLOR near its target return.

## 8. Easy Assist and Showdown
- Easy Assist: wheel speed −15%, cup width +25%, full arc.
- Showdown target: pick a NUMBER and land it in **2 throws** (round won on either throw).

## 9. Items and Foam Bat
- Works with all generic items (Golden Ticket, Bubble Wrap, Fizz Pop, etc.).
- **Do-Over Balloon:** replays with the same cup layout and spin direction.
- **Double Dare Horn challenge:** one NUMBER throw at the chosen cup with speed +20%; hit = win ×3, miss = lose the original win.
- Foam Bat: no effect (boing).

## 10. Edge cases and anti-abuse
- Throw power clamped to 0.2–1.0; aim angle clamped to the counter's arc.
- If the ball doesn't settle within 8 s, the server takes the nearest cup/lane under the ball.
- The ball is server-owned; clients cannot move it.
- If the Controller leaves before throwing, the play is a loss (stake already locked).

## 11. Presentation
- Anticipation: wheel lights chase faster while charging; a drumroll while the ball rolls.
- Action: throw "whoosh," bounce "boing-boing," rolling rattle.
- Win: the cup or lane lights up, the chalkboard writes the result, confetti from the awning.
- Loss gags: (1) ball pops like a balloon, (2) ball bounces off and bonks the Controller's head (cosmetic only), (3) a duck pops out of the cup and quacks.

## 12. Dares and badges
- Dare "Red Hot": win COLOR 3 times in one night (Easy).
- Dare "Lucky Number": win a NUMBER throw (Medium).
- Badge "Bullseye Wheel": land a NUMBER on Floor 4.

## 13. Build notes
- Ball: sphere, server network owner, custom physical properties (low elasticity for predictability).
- Cups and lanes: invisible detector parts; read the result after the ball's speed is below 0.5 studs/s for 0.5 s.
- Store the last 8 results per booth instance for the chalkboard (purely cosmetic).
