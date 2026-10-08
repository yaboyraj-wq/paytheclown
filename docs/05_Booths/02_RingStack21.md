# Booth 02 — Ring Stack 21

## 1. Summary
| Field | Value |
| --- | --- |
| ID | `RING_STACK_21` |
| Replaces (original) | Blackjack (get close to 21 without going over; the most decision-heavy table) |
| First floor | F1 The Midway |
| Type | Aim + choice |
| Seats | 1 Controller |
| Authority | Pattern B (ring physics) + Pattern C (stand/toss choices) |
| Round length | 10–25 s |

## 2. Fantasy and look
A classic ring-toss stall. A sloped board holds 11 wooden pegs, each topped with a painted number card from 1 to 11. Bigsby's cardboard cutout stands beside the board holding a scoreboard showing **his score** for this round. The player has a stack of 6 rope rings.

## 3. How it plays
1. Before the keypad opens, Bigsby's board flips to show **his score** for this round (17–21, visible). Set stake, GO.
2. Toss a ring (aim + power, like Hoop Wheel). If it rings a peg, that peg's number is added to your **total**. A ring that misses adds 0 but still uses a ring.
3. After each toss choose **TOSS** (another ring) or **STAND** (stop now). Max 6 rings.
4. Result when you STAND or run out of rings:
   - total > 21 → bust → lose.
   - total == 21 → "Perfect 21" → 3x.
   - total > Bigsby's score → 2x.
   - total == Bigsby's score → tie → stake returned (1x).
   - total < Bigsby's score → lose.
5. You can't ring the same peg twice: a ringed peg drops into the board and is replaced by a blank cover.

## 4. Visible setup randomness
- Bigsby's score (17–21) is chosen per round with weights 17: 20%, 18: 25%, 19: 25%, 20: 20%, 21: 10% and **shown before staking**.
- Peg positions on the board are shuffled per night (seeded) and visible.
- Nothing random after staking.

## 5. Payout table
| Result | Multiplier |
| --- | --- |
| Perfect 21 | 3.0x |
| Beat Bigsby (≤ 21) | 2.0x |
| Tie with Bigsby | 1.0x (stake back) |
| Below Bigsby or bust | 0x |

## 6. Push ladder
Not a push booth (TOSS/STAND is the choice).

## 7. Difficulty by floor
| Floor | Board distance (studs) | Peg spacing | Board sway |
| --- | --- | --- | --- |
| F1 | 8 | 2.2 | none |
| F2 | 9 | 2.0 | none |
| F3 | 10 | 1.85 | gentle sway, 0.15 studs, 3 s period (visible, deterministic) |
| F4 | 11 | 1.7 | 0.25 studs, 2.5 s period |
| Showdown | 11 | 1.7 | 0.3 studs |

High-value pegs (9, 10, 11) are placed in the back row on every floor.

## 8. Easy Assist and Showdown
- Easy Assist: ring catch radius +25%, board distance −1 stud.
- Showdown target: reach **exactly 21**.

## 9. Items and Foam Bat
- **Do-Over Balloon:** same Bigsby score and same peg layout, all rings back.
- **Double Dare Horn challenge:** Bigsby's score becomes 21; you get 3 new rings and must reach exactly 21 from 0. Win = ×3 of original win.
- Foam Bat: bonking the board before your next toss knocks one random-looking (actually fixed: the top-left un-ringed) peg card to show "+0" — no gameplay effect except comedy. Keep it harmless.

## 10. Edge cases and anti-abuse
- A ring that lands on two pegs counts the peg its center is closest to.
- If the player times out in the TOSS/STAND choice (8 s), auto-STAND.
- Disconnect → auto-STAND with the current total.

## 11. Presentation
- Anticipation: Bigsby's cutout leans in as your total approaches his score.
- Action: rope "thwip," wooden "clack" when ringing a peg, the total counter flips like an old scoreboard.
- Win: Bigsby's cutout falls over; confetti.
- Loss gags: (1) bust → the pegs all pop up like springs, (2) the cutout laughs and spins, (3) a pie hits the cutout anyway (crowd laughs).

## 12. Dares and badges
- Dare "Risky Move": win with a total under 10 (Medium). (Mirrors the original's achievement idea; our version.)
- Dare "No Bust Run": win 4 rounds in a row in one night (Hard).
- Badge "Perfect 21": hit exactly 21 on Floor 4.

## 13. Build notes
- Reuse the throw controller from Hoop Wheel.
- Peg detection: each peg has a cylinder zone; a ring counts when its center is within the zone and it has settled.
