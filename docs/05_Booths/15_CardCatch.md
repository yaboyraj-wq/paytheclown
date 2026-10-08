# Booth 15 — Card Catch

## 1. Summary
| Field | Value |
| --- | --- |
| ID | `CARD_CATCH` |
| Replaces (original) | 1P Poker (four cards, lock some, draw again) |
| First floor | F3 Funhouse of Mirrors |
| Type | Timing + choice |
| Seats | 1 Controller |
| Authority | Pattern A (conveyor timeline) + Pattern C (lock choices) |
| Round length | 12–20 s |

## 2. Fantasy and look
A funhouse conveyor belt carries giant playing cards past a mechanical grabber claw. The deck is a **carnival deck**: 4 suits — Balloon, Star, Duck, Ticket — with values 1–8 (32 cards). The player's hand of 4 is shown on a big board. No casino card look: bright cartoon art, no traditional suits, no chips.

## 3. How it plays
1. Set stake, GO. The conveyor starts. The next 3 cards coming are visible on a preview strip.
2. **Catch round 1:** press GRAB four times. Each press grabs the card currently under the claw.
3. **Lock:** tap the cards you want to keep (lock 0–4).
4. **Catch round 2:** the conveyor speeds up 15%; grab one replacement for each unlocked card.
5. Hand is scored.

## 4. Visible setup randomness
- The deck order on the conveyor is shuffled per play, but the next 3 cards are always visible ahead, and the belt speed is constant. Skill = timing your grab to the card you want.

## 5. Payout table (4-card hands)
| Hand | Multiplier |
| --- | --- |
| Four of a kind | 25x |
| Straight flush (4 in a row, same suit) | 15x |
| Three of a kind | 6x |
| Flush (same suit) | 4x |
| Straight (4 in a row) | 3x |
| Two pair | 2x |
| Pair of 6s, 7s or 8s | 1.2x |
| Any other pair | 0.5x |
| Nothing | 0x |

## 6. Push ladder
None.

## 7. Difficulty by floor
| Floor | Belt speed (cards/s) | Preview cards | Card spacing |
| --- | --- | --- | --- |
| F3 | 1.6 | 3 | wide |
| F4 | 2.0 | 2 | medium |
| Showdown | 2.2 | 2 | medium |

## 8. Easy Assist and Showdown
- Easy Assist: belt speed −15%, preview 4.
- Showdown target: **Three of a kind or better**.

## 9. Items and Foam Bat
- **Do-Over Balloon:** replay catch round 2 with the same deck order.
- **Double Dare Horn challenge:** grab 1 more card at +30% speed; if it improves the hand by one rank, ×3 of original win.
- Foam Bat: bonking the conveyor pauses it for 0.3 s (once per round) — a teammate can help you time a grab.
- The "Poker Face" dare: win Two pair or better **without locking** any card in round 1.

## 10. Edge cases and anti-abuse
- Pattern A grab evaluation: the card under the claw at the accepted timestamp.
- Deck order beyond the preview is never sent to clients.
- Timeout per grab 4 s → grabs whatever is under the claw.

## 11. Presentation
- Anticipation: drumroll during round 2.
- Action: claw "chunk," card flip.
- Win: the cards fan out and do a little dance.
- Loss gags: (1) the claw drops the cards and shrugs, (2) the cards fold into paper airplanes and fly away, (3) a mirror shows Bigsby holding four of a kind and laughing.

## 12. Dares and badges
- Dare "Poker Face": see above (Medium).
- Badge "Four of a Kind": get four of a kind.
