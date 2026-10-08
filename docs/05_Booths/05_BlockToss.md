# Booth 05 — Block Toss

## 1. Summary
| Field | Value |
| --- | --- |
| ID | `BLOCK_TOSS` |
| Replaces (original) | Street Craps (physics dice; come-out roll then point phase; the original's "skill table," plus the baseball bat trick) |
| First floor | F1 The Midway |
| Type | Physics throw + strategy |
| Seats | 1 Controller (the "Roller"); others may watch and use the Foam Bat (rules below) |
| Authority | Pattern B (server physics) |
| Round length | 8–30 s |

## 2. Fantasy and look
A low wooden pit with padded walls, painted like a carnival game board. Two big soft foam cubes, each face showing 1–6 as dots in bright colors. A chalkboard shows the current phase: **OPENING TOSS** or **POINT: 8**. Bigsby's "Lucky 7" banner hangs over it (decor).

## 3. How it plays
Rules are simple craps rules, renamed:
1. Set stake, GO. Phase = **Opening Toss**.
2. Aim, charge power, set spin (a small spin slider/stick flick), release. Both blocks tumble and settle.
3. **Opening Toss result** (sum of top faces):
   - 7 or 11 → **WIN** 2x.
   - 2, 3 or 12 → **LOSE**.
   - Any other (4, 5, 6, 8, 9, 10) → that number becomes the **Point**. Phase = **Point Phase**.
4. **Point Phase:** keep tossing.
   - Toss the Point again → **WIN** 2x.
   - Toss a 7 → **LOSE**.
   - Anything else → toss again.
5. Max 10 tosses in Point Phase; if reached, the round is a tie (stake back) — prevents stalling.

## 4. Visible setup randomness
- None. Outcome is purely physics from the player's throw parameters (and bat bonks). Blocks always start in the same rest position in the Roller's hands.

## 5. Payout table
| Result | Multiplier |
| --- | --- |
| Win on Opening Toss (7 or 11) | 2.0x |
| Win by hitting the Point | 2.0x |
| Hit 4 or 10 as the Point and then hit it (harder) | 2.5x |
| Lose (2, 3, 12 on opening; 7 in point phase) | 0x |
| 10 point-phase tosses without result | 1.0x (stake back) |

## 6. Push ladder
None (Point Phase is the tension).

## 7. Difficulty by floor
| Floor | Pit size | Wall bounciness | Power meter speed | Spin control |
| --- | --- | --- | --- | --- |
| F1 | Small (easier control) | 0.3 | slow | 3 steps |
| F2 | Medium | 0.35 | medium | 5 steps |
| F3 | Medium, slight slope toward the back | 0.4 | medium-fast | 5 steps |
| F4 | Large | 0.45 | fast | 7 steps |
| Showdown | Large | 0.45 | fast | 7 steps |

These are tuned so learned throws work but need precision.

## 8. Easy Assist and Showdown
- Easy Assist: power meter −15% speed; on the opening toss, 7 and 11 are highlighted in the result reminder.
- Showdown target: **win the round** within 3 total tosses (opening win, or make the Point by the 3rd toss).

## 9. Items and Foam Bat

### The Foam Bat (our version of the original's baseball bat trick)
- After **both blocks have settled** and before the result locks, there is a **1.5-second Bonk Window** (a glowing ring around the pit).
- During the window, any crew member holding the Foam Bat can bonk **one block once**. The bonk applies a fixed impulse in the direction of the swing that tips the block over by exactly one face toward the swing direction (adjacent face).
- Only **one bonk per toss**, total, by anyone.
- The Roller cannot bonk their own toss (they are holding the blocks). A teammate must do it → teamwork moment.
- After the window closes (or after the bonk settles), the result locks.
- The server computes the tip with physics; the impulse is fixed-size and direction-quantized to 4 directions, so it is learnable and not random.

### Items
- **Guardian Gnome** planted next to the pit: while active, a losing toss doesn't end the round — it refunds the stake (the original's best-known combo: Holy Statue on Street Craps).
- **Do-Over Balloon:** replays the round from the Opening Toss.
- **Double Dare Horn challenge:** one opening toss; must roll exactly 7. Win = ×3 of original win.
- **Fizz Pop:** power meter wobbles; payout bonus applies.

## 10. Edge cases and anti-abuse
- Throw parameters are clamped; blocks are server-owned.
- A block that lands tilted against a wall (not flat) after 3 s: server nudges it to its nearest flat face (deterministic: the face whose normal is closest to up).
- A block that leaves the pit: the toss is void and repeated (doesn't count toward the 10 tosses), max 3 voids per round, then loss.
- Bonk window can't be extended. Bat bonks outside the window do nothing.

## 11. Presentation
- Anticipation: the point number glows on the chalkboard; crowd murmurs grow with each toss in Point Phase.
- Action: soft "foomp" bounces; the camera follows the blocks; the bonk is a huge cartoon "BONK!" text.
- Win: blocks jump and high-five (animated); confetti.
- Loss gags: (1) blocks deflate, (2) a cardboard "7" falls from the ceiling onto the Roller, (3) Bigsby's banner winks.

## 12. Dares and badges
- Dare "Lucky 7": roll a 7 on your opening toss (Easy).
- Dare "Natural Roller": win during the Point Phase (Medium).
- Dare "Batter Up": win a round after a Foam Bat bonk changed the result (Medium).
- Badge "Home Run": win with a bat bonk on Floor 4.

## 13. Build notes
- Use custom physical properties for consistent tumbling; test that identical inputs give identical results on the server in 95%+ of trials. If not, reduce sensitivity (heavier blocks, higher friction).
- Read the top face by comparing each face's normal to world up.
