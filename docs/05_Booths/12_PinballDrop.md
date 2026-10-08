# Booth 12 — Pinball Drop

## 1. Summary
| Field | Value |
| --- | --- |
| ID | `PINBALL_DROP` |
| Replaces (original) | Plinko (drop a ball through pegs into multiplier slots; up to 24x) |
| First floor | F2 Neon Arcade |
| Type | Timing (flippers) + aim (drop position) |
| Seats | 1 Controller |
| Authority | Pattern B (server physics) |
| Round length | 6–10 s |

## 2. Fantasy and look
A tall upright neon pinball-plinko cabinet. A ball drops from a slider at the top, bounces through a triangle of pegs, past **two flippers** in the middle, and lands in 11 slots at the bottom. Edge slots glow gold.

## 3. How it plays
1. Set stake, GO.
2. Slide the dropper left/right to choose the **drop position**, press to drop.
3. As the ball falls, tap **LEFT FLIPPER** or **RIGHT FLIPPER** to bat it when it passes the flipper zone (once per flipper per drop).
4. The ball settles in a slot → multiplier.

## 4. Visible setup randomness
- None. Peg layout fixed per floor; physics deterministic.

## 5. Payout table (slots left to right)
| Slot | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Multiplier | 24x | 6x | 2x | 1.2x | 0.4x | 0.2x | 0.4x | 1.2x | 2x | 6x | 24x |

Center slots return part of the stake (0.2x–0.4x). Edges are hard to reach.

## 6. Push ladder
None.

## 7. Difficulty by floor
| Floor | Peg rows | Flipper strength | Edge slot width |
| --- | --- | --- | --- |
| F2 | 8 | strong | 1.0 |
| F3 | 9 | medium | 0.9 |
| F4 | 10 | medium-weak | 0.8 |
| Showdown | 10 | medium-weak | 0.8 |

## 8. Easy Assist and Showdown
- Easy Assist: flipper window +25% longer.
- Showdown target: land **6x or better**.

## 9. Items and Foam Bat
- **Foam Bat "Tilt":** a teammate can bonk the cabinet once per drop to nudge the whole board 3° left or right for 0.5 s (direction from swing). Over-use (twice in one drop) triggers "TILT!" and the drop lands in the center slot. Learnable trick.
- **Do-Over Balloon:** another drop from the same position.
- **Double Dare Horn challenge:** one drop that must land in slot 2 or 10 or better. Win = ×3 of original win.
- **Bubble Wrap:** center-slot losses return 50%+ (see `06`).

## 10. Edge cases and anti-abuse
- Server-owned ball. Flipper inputs evaluated at accepted timestamps; each flipper can fire once per drop.
- Ball stuck for 3 s → server nudges it down (deterministic small impulse).

## 11. Presentation
- Anticipation: cabinet lights strobe faster as the ball nears the bottom (Reduce Flashing respected).
- Action: peg "plink-plink" sounds tuned to a musical scale left to right (it plays a little tune).
- Win: slot lights explode; 24x plays a pinball "MULTIBALL!"-style jingle (original sound).
- Loss gags: (1) ball turns into a tiny rubber duck in the slot, (2) cabinet coughs smoke, (3) "GAME OVER" pixel text with a raspberry.

## 12. Dares and badges
- Dare "Clean Fall": land 24x (Hard).
- Dare "Straight Down": lose 7 drops in a row on purpose (Medium) — a joke dare; awards Tokens only if the crew still meets quota. (Mirrors the original's deliberate-loss achievements.)
- Badge "Edge Master": land 24x on Floor 4.

## 13. Build notes
- Pegs are anchored small cylinders; the ball is a server-owned sphere with tuned elasticity. Test that the same drop position + flipper timing gives the same slot in 95%+ of server trials; if not, raise friction/mass until it does.
- The slot "tune" uses 11 notes of one musical scale so every drop sounds musical.
