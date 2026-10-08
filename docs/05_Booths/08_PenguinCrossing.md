# Booth 08 — Penguin Crossing

## 1. Summary
| Field | Value |
| --- | --- |
| ID | `PENGUIN_CROSSING` |
| Replaces (original) | Penguin Cross (a penguin crosses lanes while a multiplier climbs; cash out or lose it) |
| First floor | F2 Neon Arcade |
| Type | Timing + nerve (push) |
| Seats | 1 Controller |
| Authority | Pattern C (server-simulated movement and traffic) |
| Round length | 6–30 s |

## 2. Fantasy and look
A tabletop diorama of a frozen neon city: 10 lanes of tiny snowmobiles, ice-cream trucks and zamboni carts sliding across. A chubby penguin in a scarf waits at the curb. Each lane's far curb is a safe "island" with a glowing multiplier sign.

## 3. How it plays
1. Set stake, GO. The penguin waits on the start curb.
2. Press **HOP** to move the penguin across the next lane. The hop takes 0.45 s. If a vehicle occupies the penguin's path during the hop, the penguin is "bonked" (comedy, not injury) → round lost.
3. After each successful hop, the penguin stands on an island showing the current multiplier. Choose **PUSH** (hop the next lane) or **BANK** (cash out at the shown multiplier).
4. Lanes get faster and busier the further you go.
5. Reaching the far side (lane 10) auto-banks at 10x.

## 4. Visible setup randomness
- Traffic patterns per lane (vehicle spacing and speeds) are generated per play from a seed and are fully visible on the board. Players read gaps and time hops.
- No hidden state.

## 5. Push ladder
| Lane cleared | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Multiplier | 1.2x | 1.5x | 1.9x | 2.4x | 3.0x | 3.8x | 4.8x | 6.0x | 7.5x | 10x |

Getting bonked at any lane = 0x (unbanked value lost).

## 6. Difficulty by floor
| Floor | Vehicle speed (lane 1 → lane 10) | Minimum gap (s, lane 1 → 10) |
| --- | --- | --- |
| F2 | 6 → 12 studs/s | 1.4 → 0.8 |
| F3 | 7 → 14 | 1.3 → 0.7 |
| F4 | 8 → 16 | 1.2 → 0.6 |
| Showdown | 9 → 17 | 1.1 → 0.55 |

Rule for the generator: every lane must always contain at least one safe hop window per 3 s (no impossible lanes).

## 7. Easy Assist and Showdown
- Easy Assist: vehicle speed −15%, gaps +25%.
- Showdown target: **bank at lane 7 (4.8x) or further**.

## 8. Items and Foam Bat
- **Guardian Gnome** nearby: a bonk refunds the stake instead of losing it.
- **Rewind Remote:** standard global rewind.
- **Do-Over Balloon:** after a bonk, restarts from the start curb with the same traffic seed.
- **Double Dare Horn challenge:** one extra lane at the next lane's speed ×1.2; success = ×3 of banked win.
- Foam Bat: no effect.

## 9. Edge cases and anti-abuse
- Server owns the penguin position and all vehicles. A hop input is accepted only when the penguin is idle on a curb.
- Collision is checked on the server along the hop path over the hop duration.
- PUSH_DECISION timeout (8 s) → auto-BANK.
- Disconnect → auto-BANK at the last island.

## 10. Presentation
- Anticipation: each island sign glows brighter; music gains a layer per lane.
- Action: cute hop sound; vehicles honk as they pass close.
- Win (bank): the penguin slides on its belly to a prize podium; Tickets fly to the jar.
- Loss gags: (1) penguin flattened into a pancake shape then pops back, (2) penguin bounces off a truck into a snowbank, (3) penguin gets scooped up by the zamboni and waves.

## 11. Dares and badges
- Dare "Winner Winner Penguin Dinner": bank at 3x or more twice in a row (Medium).
- Dare "Traffic Monster": bank at 4.8x or more (Hard).
- Badge "Cold Feet": reach lane 10 (10x) on any floor.

## 12. Build notes
- Board is a small 3D diorama; the camera looks down at 60°. Vehicles are simple meshes on rails; positions are a pure function of time and lane seed, so clients render them locally from server start time and only the hop/collision is server-verified.
