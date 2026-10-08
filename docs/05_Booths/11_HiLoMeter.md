# Booth 11 — Hi-Lo Meter

## 1. Summary
| Field | Value |
| --- | --- |
| ID | `HILO_METER` |
| Replaces (original) | HiLo (set a dial, guess if a moving arrow lands higher or lower) |
| First floor | F2 Neon Arcade |
| Type | Timing + nerve (push) |
| Seats | 1 Controller |
| Authority | Pattern A |
| Round length | 4–30 s |

## 2. Fantasy and look
A big semicircle gauge like a carnival "Love Tester," scale 0–100. A needle sweeps back and forth. A glowing **target line** sits somewhere on the scale. Two giant buttons: **HIGHER** and **LOWER**, and a big **STOP** button.

## 3. How it plays
1. Set stake, GO. A target line appears at a random value (visible).
2. Choose **HIGHER** or **LOWER**. The multiplier for each side is shown on the buttons before you choose.
3. The needle starts sweeping. Press **STOP** to stop it. If it stops on your chosen side of the line → win this step; on the line exactly or the other side → lose.
4. After a win: **PUSH** (a new target line appears; your winnings ride; choose a side again) or **BANK**.

## 4. Visible setup randomness
- Each target line value is random (uniform 15–85) and shown before you choose a side.
- Needle speed and pattern are fixed per floor and step.

## 5. Payout
- Step multiplier for a side with size `s` (0–100 units on that side of the line): `stepMult = clamp(0.94 × 100 / s, 1.1, 6.0)`, rounded to 2 decimals.
  - Example: line at 70 → HIGHER side size 30 → 3.13x; LOWER side size 70 → 1.34x.
- Total multiplier = product of step multipliers while pushing.
- Hard ceiling: total 50x auto-banks.

## 6. Push ladder
Compounding steps as above. Each push makes the needle 8% faster than the previous step (max +40%).

## 7. Difficulty by floor
| Floor | Needle speed (sweeps/s) | Sweep shape | Line thickness (counts as lose) |
| --- | --- | --- | --- |
| F2 | 0.9 | linear | 1 unit |
| F3 | 1.1 | ease-in-out (slows at ends) | 1.5 units |
| F4 | 1.3 | ease-in-out with a quick "skip" in the middle third (deterministic) | 2 units |
| Showdown | 1.4 | as F4 | 2 units |

## 8. Easy Assist and Showdown
- Easy Assist: needle −15%; side zones get a soft highlight.
- Showdown target: reach **10x total** by pushing.

## 9. Items and Foam Bat
- **Do-Over Balloon:** replays the failed step with the same line.
- **Double Dare Horn challenge:** one more step forced to the smaller side. Win = ×3 of banked win.
- **Guardian Gnome:** a lost step refunds the original stake (not the accumulated winnings).
- Foam Bat: bonking the gauge stops the needle immediately (counts as the STOP at that moment). A teammate can "stop it for you" — chaos and teamwork. Only during the Controller's sweep, once per step.

## 10. Edge cases and anti-abuse
- Pattern A evaluation of STOP time. Needle position = shared deterministic function of time.
- Timeout: if STOP isn't pressed within 6 s, the needle stops where it is.
- Disconnect during PUSH_DECISION → BANK; during sweep → stop at current position.

## 11. Presentation
- Anticipation: the gauge buzzes louder as the needle passes the line.
- Action: a loud "DING" on STOP; the needle wobbles but the result is fixed.
- Win: hearts and stars burst from the gauge; the multiplier counter grows.
- Loss gags: (1) the gauge springs a leak of confetti, (2) the needle bends into a sad shape, (3) "TRY AGAIN, SWEETIE" sign flips up (Gert's voice).

## 12. Dares and badges
- Dare "Roll the Odds": bank 5x or more (Medium).
- Dare "No Safe Rolls": bank 10x or more (Hard).
- Badge "Needle Master": reach 25x.
