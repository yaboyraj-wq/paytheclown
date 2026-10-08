# Booth 14 — Pie Sweeper

## 1. Summary
| Field | Value |
| --- | --- |
| ID | `PIE_SWEEPER` |
| Replaces (original) | Mine Sweeper (reveal tiles, avoid mines, cash out) |
| First floor | F3 Funhouse of Mirrors |
| Type | Logic (deduction) + nerve (push) |
| Seats | 1 Controller (teammates can help reason!) |
| Authority | Pattern C (server holds pie positions) |
| Round length | 10–45 s |

## 2. Fantasy and look
A 5×5 grid of silver cloches (dinner covers) on a long banquet table. Some hide cream pies. Lifting a cloche reveals either a clean plate with a **number** (how many neighboring cloches hide pies, like real Minesweeper) or a pie that launches into the Controller's face.

## 3. How it plays
1. Keypad: choose **pie count** within the floor's range and select a safe opening tile. The server creates the board now, excluding that tile and, for counts ≤ 6, its neighbors. Show every pie for a **2-second preview before GO is enabled**. Changing the opening or pie count generates a new preview before commitment. Set stake, GO; the board is then fixed and hidden.
2. **First reveal is always safe** at the selected opening and opens a small area (if it's a 0, neighbors cascade open like real Minesweeper).
3. Every revealed safe tile shows a number 0–8 = count of pies in the 8 surrounding cloches. Players can deduce safe tiles.
4. After each reveal: **PUSH** (reveal another) or **BANK** (cash out at the current multiplier). Cascade reveals count as one action but all revealed tiles count toward the multiplier.
5. Reveal a pie → splat → lose.
6. Optional: right-click/long-press to place a **flag** on a suspected pie (no gameplay effect, just notes).

## 4. Visible setup randomness
- Pie positions are generated and shown before commitment, never after it. During play the authoritative map remains server-only and only revealed numbers are sent. The pre-stake preview is public information, so a client can retain it (the same accepted limitation as Gem Recall); no security claim relies on clients forgetting it. This resolves the original hidden-after-stake placement conflict with AGENTS §2.2. See `27`, 2026-10-07.

## 5. Payout (multiplier after k safe tiles revealed)
```
safeTiles = 25 − pies
mult(k) = 0.92 × Π_{i=0}^{k−1} (25 − i) / (safeTiles − i)
```
Rounded to 2 decimals. The first reveal (always safe) is excluded from the product (it starts the board at 1.0x). Cascades multiply in all revealed tiles. Hard ceiling: 50x auto-banks; revealing all safe tiles auto-banks.

Example, 3 pies: after 5 extra safe tiles ≈ 1.9x; after 10 ≈ 4.4x.

## 6. Push ladder
Per reveal as above.

## 7. Difficulty by floor
| Floor | Allowed pie counts | Time per reveal decision |
| --- | --- | --- |
| F3 | 3–8 | 10 s |
| F4 | 4–10 | 8 s |
| Showdown | fixed 5 pies | 8 s |

Deduction makes this the most skill-rewarding booth; the 0.92 factor keeps guessers below break-even while logical players beat it.

## 8. Easy Assist and Showdown
- Easy Assist: pie count fixed at 3, and the first reveal is always a 0 (cascade).
- Showdown target: **bank at 5x or more with 5 pies**.

## 9. Items and Foam Bat
- **Rewind Remote**, **Guardian Gnome**: standard.
- **Do-Over Balloon:** after a splat, continue the same board with the splatted pie flagged (you keep your progress, the pie is revealed). Very strong; intended.
- **Double Dare Horn challenge:** reveal 2 more tiles with no further numbers shown. Success = ×3 of banked win.
- **Foam Bat:** bonking the table rattles the cloches; for 1 s every cloche hiding a pie jiggles **slightly more** than others. One bonk per round. Rewards observation.

## 10. Edge cases and anti-abuse
- Pie map is server-only. Revealed numbers are computed on the server.
- Anomaly flag: >95% safe-reveal rate on non-deducible (50/50) positions over 40+ guesses (see `16`).
- Timeout on decision → BANK.

## 11. Presentation
- Anticipation: a dramatic "dun-dun" as the cloche lifts slowly when the player holds the tap (hold to lift slowly, release to lift fast — purely visual drama).
- Action: plate "ting," number pops out.
- Win: waiters (cardboard) applaud; plates spin.
- Loss gags: (1) pie in the face (screen splat 1.5 s), (2) the pie is a pie-shaped whoopee cushion, (3) all remaining pies launch as fireworks.

## 12. Dares and badges
- Dare "Perfect Sweep": bank 20x or more (Hard).
- Dare "No Detonations": bank 5x three times in a row (Hard).
- Badge "Pie Proof": clear the entire board with 8+ pies.

## 13. Build notes
- Board logic is a pure module (`PieSweeperLogic`) with unit tests: pre-stake placement around the selected opening, unchanged map after commitment, number calculation, cascade, multiplier.
