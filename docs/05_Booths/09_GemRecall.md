# Booth 09 — Gem Recall

## 1. Summary
| Field | Value |
| --- | --- |
| ID | `GEM_RECALL` |
| Replaces (original) | Keno (bet on tiles and hope gems land on them) |
| First floor | F2 Neon Arcade |
| Type | Memory |
| Seats | 1 Controller (teammates can help by shouting!) |
| Authority | Pattern C (server holds gem positions) |
| Round length | 8–15 s |

## 2. Fantasy and look
A glowing 5×5 tile floor panel, like a dance floor, under a glass dome. Gems light up under some tiles, then the lights go out. The player taps tiles to reveal them.

## 3. How it plays
1. Keypad: choose how many **picks** (1–5). Set stake, GO.
2. **Flash:** 5 gems light up under 5 random tiles for the floor's flash time.
3. The tiles go dark. Optional distractions (higher floors): decoy sparkles, a short tile shuffle animation that visibly slides rows (players can follow it).
4. The player taps exactly as many tiles as their picks. Each tapped tile reveals gem or empty.
5. Payout by number of hits, per the table.

## 4. Visible setup randomness
- Gem positions are random per play but **shown** during the flash. That's the memory test.
- Shuffle animations on F3/F4 are fully visible and followable.

## 5. Payout table
| Picks | Hits needed → multiplier |
| --- | --- |
| 1 | 1 → 1.8x |
| 2 | 2 → 3.5x |
| 3 | 3 → 6x; 2 → 1x |
| 4 | 4 → 10x; 3 → 2x |
| 5 | 5 → 18x; 4 → 4x; 3 → 1x |

Any fewer hits than listed = 0x.

## 6. Push ladder
None.

## 7. Difficulty by floor
| Floor | Flash time | Distraction |
| --- | --- | --- |
| F2 | 2.0 s | none |
| F3 | 1.6 s | 3 decoy sparkles after the flash |
| F4 | 1.3 s | one visible row slide (all tiles in a row slide one step) |
| Showdown | 1.2 s | one row slide + one column slide |

## 8. Easy Assist and Showdown
- Easy Assist: flash 2.5 s.
- Showdown target: **4 picks, 4 hits**.

## 9. Items and Foam Bat
- **Do-Over Balloon:** replays with the **same** gem positions — a powerful second look. (Intentional: the item's value is high here.)
- **Double Dare Horn challenge:** one new flash at 1.0 s, pick 2, need 2 hits. Win = ×3 of original win.
- **Snapshot Camera:** used before the flash, freezes a photo of the flash on the user's screen for 1 s more (only the item user sees it). Then normal Snapshot rules (see `06`).
- Foam Bat: no effect.

## 10. Edge cases and anti-abuse
- Gem positions are **never** sent to clients before the flash. During the flash the server sends positions for rendering; after the flash, the client must discard them. (Exploiters could keep them; that's acceptable because the flash shows them anyway — the flash is public information. The server still validates picks.)
- Picks must be distinct tiles. Picks must happen within 10 s or remaining picks auto-fill as misses.

## 11. Presentation
- Anticipation: dome hums; tiles pulse before the flash.
- Action: each tap "pings" and a tile flips.
- Win: gems float up and burst into Tickets.
- Loss gags: (1) an empty tile reveals a rubber chicken, (2) a tile reveals Bigsby's face winking, (3) the dome fogs and draws a sad face.

## 12. Dares and badges
- Dare "Spot On": stake a total of 5× the floor max at Gem Recall in one night (Medium).
- Dare "Marked to Win": win 10x or more (Hard).
- Badge "Photographic Memory": hit 5 of 5.

## 13. Build notes
- Flash data: send positions in the same remote call that starts the flash, with a server timestamp; client hides them at `flashEnd`.
- Row/column slides: server applies the permutation to its gem map; clients animate the same permutation.
