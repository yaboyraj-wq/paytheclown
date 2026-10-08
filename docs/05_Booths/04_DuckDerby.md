# Booth 04 — Duck Derby

## 1. Summary
| Field | Value |
| --- | --- |
| ID | `DUCK_DERBY` |
| Replaces (original) | Duck Race (bet on one of the ducks, including the fan-favorite "YARL") |
| First floor | F1 The Midway |
| Type | Rhythm / tapping race |
| Seats | **Multi-seat: up to 4 players**, each with their own duck and stake |
| Authority | Pattern A (server evaluates rhythm inputs) |
| Round length | 12–15 s |

## 2. Fantasy and look
A water channel with 5 lanes. Rubber ducks in tiny racing helmets paddle down the lanes toward a checkered flag. A starter pistol that shoots confetti. Bleachers with cheering cardboard fans. Each player gets a duck with their crew sash color.

## 3. How it plays
1. Players step on any of the 4 player pads. The first player to press GO starts a **6-second join window** ("Race starts in 6!"); others can join and stake during the window.
2. Each player picks a duck: **Normal duck** or **Sir Waddles** (heavier and slower, pays more). Only one player per race can pick Sir Waddles.
3. Remaining lanes are filled with **Bigsby's ducks** (bots). Each bot duck shows a **speed rating** (1–5 stars) on its lane sign before the race. Bot ducks race at fixed speeds based on their rating (no randomness).
4. The race: a beat marker pulses on screen. Each press **on the beat** gives a strong paddle; off-beat presses give a weak paddle; mashing gives "splashes" that slow you (anti-mash).
5. Finish position decides the payout. Ties go to the duck whose front crossed first by server time.

## 4. Visible setup randomness
- Bot duck speed ratings are rolled per race and shown on lane signs during the join window.
- Beat tempo is fixed per floor and shown by the metronome.
- Nothing random after the gun.

## 5. Payout table
| Finish | Normal duck | Sir Waddles |
| --- | --- | --- |
| 1st | 2.5x | 5.0x |
| 2nd | 1.2x | 1.0x (stake back) |
| 3rd–5th | 0x | 0x |

Places count against all ducks (players and bots).

## 6. Push ladder
None.

## 7. Difficulty by floor
| Floor | Beat tempo (BPM) | Perfect window (± s) | Bot speed range (in "stars") | Track length |
| --- | --- | --- | --- | --- |
| F1 | 100 | 0.12 | 1–3 | 60 studs |
| F2 | 115 | 0.10 | 2–4 | 70 |
| F3 | 125 | 0.09 | 2–5 | 75 |
| F4 | 135 | 0.08 | 3–5 | 80 |
| Showdown | 140 | 0.075 | three 5-star bots | 80 |

Sir Waddles: −15% paddle strength.

## 8. Easy Assist and Showdown
- Easy Assist: perfect window +25%, bots capped at 2 stars.
- Showdown target: finish **1st** (normal duck).

## 9. Items and Foam Bat
- **Karaoke Mic** nearby: affects payouts as usual (Mic is an aura; see `06`).
- **Do-Over Balloon:** re-runs the race with the same bot ratings (only for the player who used it; others' results stand).
- **Double Dare Horn challenge:** a 6-second sprint vs one 5-star bot. Win = ×3 of original win.
- Foam Bat: not allowed at Duck Derby (players are sitting; prevents griefing racers).

## 10. Edge cases and anti-abuse
- Inputs above 8 per second count as "splash" (slows the duck) — removes auto-clicker advantage.
- A player who disconnects mid-race: their duck stops; result computed as is.
- Each player's stake and payout is separate. Big-stake rules apply per player.

## 11. Presentation
- Anticipation: countdown with crowd chanting "QUACK! QUACK! QUACK!"
- Action: splash particles per paddle; perfect paddles leave a little rainbow wake.
- Win: the duck does a backflip; the winning player's name flashes on the scoreboard.
- Loss gags: (1) the duck spins in circles, (2) the duck gets a tiny towel and sulks, (3) a bot duck honks at you.

## 12. Dares and badges
- Dare "Waddle On!": win with Sir Waddles (Medium). (Our answer to the original's fan-favorite duck.)
- Dare "Unstoppable Quack": win 2 Derbies in a row (Hard).
- Badge "Duck Royalty": win with Sir Waddles on Floor 4.

## 13. Build notes
- Duck movement is computed on the server from accepted inputs; replicate positions at 10 Hz with client interpolation.
- Beat clock: shared function from server start time and BPM.
