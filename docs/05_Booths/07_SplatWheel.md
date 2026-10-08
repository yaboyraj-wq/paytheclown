# Booth 07 — Splat Wheel

## 1. Summary
| Field | Value |
| --- | --- |
| ID | `SPLAT_WHEEL` |
| Replaces (original) | Money Wheel (predict a color) |
| First floor | F2 Neon Arcade |
| Type | Aim (moving target) |
| Seats | 1 Controller |
| Authority | Pattern B (server projectile) |
| Round length | 5–8 s |

## 2. Fantasy and look
A big upright neon wheel spinning on a wall, divided into colored segments of different sizes. The player throws glowing paint balls at it. Hits leave neon splats that fade after a few seconds.

## 3. How it plays
1. Keypad: pick a **color** (Blue, Green, Purple, Gold). Set stake, GO.
2. The wheel spins. Aim and throw **one** paint ball (tap to throw; no power — fixed fast throw speed so it's about aim and timing).
3. The color the ball splats on is the result. A hit on the black rim or a miss = lose.

## 4. Visible setup randomness
- Segment arrangement (order of colored segments) is shuffled per night (seeded), visible.
- Spin direction per play, shown before GO.

## 5. Payout table
| Color | Share of wheel (F2) | Multiplier |
| --- | --- | --- |
| Blue | 40% | 2x |
| Green | 25% | 3x |
| Purple | 15% | 5x |
| Gold | 5% | 12x |
| Black rim and dividers | 15% | 0x |

Each segment pattern also has a shape (Blue = dots, Green = stripes, Purple = zigzags, Gold = stars) for color-blind players.

## 6. Push ladder
None.

## 7. Difficulty by floor
| Floor | Spin speed (rpm) | Rim/dividers share | Wobble |
| --- | --- | --- | --- |
| F2 | 12 | 15% | none |
| F3 | 15 | 17% | slight vertical bob (visible, deterministic) |
| F4 | 18 | 20% | bob + speed pulses on a 2 s cycle |
| Showdown | 20 | 20% | as F4 |

When the rim share grows, color shares shrink proportionally.

## 8. Easy Assist and Showdown
- Easy Assist: spin −15%; Blue segments +25% width.
- Showdown target: hit **Gold**.

## 9. Items and Foam Bat
- **Do-Over Balloon:** one more throw with the same color choice.
- **Double Dare Horn challenge:** hit Purple or Gold with one throw at +20% spin. Win = ×3 of original win.
- Foam Bat: no effect.

## 10. Edge cases and anti-abuse
- Throw direction clamped to the wheel's facing cone. Throw speed fixed by server.
- Hit detection: server raycast/projectile vs. the wheel's segment at the server's wheel angle at impact time.

## 11. Presentation
- Anticipation: segment of your chosen color pulses.
- Action: "splort!" paint impact; the splat sticks and rotates with the wheel.
- Win: the wheel flashes your color, neon fireworks.
- Loss gags: (1) paint splats back at the screen (2 s, wipes off), (2) the wheel blows a raspberry sound, (3) Honk gets splatted (cosmetic).

## 12. Dares and badges
- Dare "Spin Streak": win 3 in a row with stakes above 25% of max (Hard).
- Badge "Gold Splat": hit Gold on Floor 4.

## 13. Build notes
- Use a projectile with fixed velocity and server-side raycasting for consistency; visualize with a client tracer.
