# Booth 13 — Funhouse Ladder

## 1. Summary
| Field | Value |
| --- | --- |
| ID | `FUNHOUSE_LADDER` |
| Replaces (original) | Dragon Tower (climb rows, avoid the dragon eyes; players memorized positions) |
| First floor | F3 Funhouse of Mirrors |
| Type | Observation + nerve (push) |
| Seats | 1 Controller |
| Authority | Pattern C (server knows the Boo doors) |
| Round length | 6–30 s |

## 2. Fantasy and look
A tall funhouse wall of little doors stacked in 8 rows, like a giant advent calendar. The player's cartoon climber starts at the bottom. Behind one door per row hides a **Boo** (a pop-up ghost clown — silly, not scary). The other doors hide a ladder rung up to the next row.

## 3. How it plays
1. Set stake, GO. Row 1 lights up.
2. **Look for the tell.** As the climber stands before a row, the Boo door gives a brief tell (see table): a flicker of light under the door, a creak sound, a wobble, or a shadow. Tells are subtle and get subtler on higher floors.
3. Tap a door. Safe → the climber climbs to the next row; the multiplier updates. Boo → the climber falls into a ball pit → lose.
4. After each safe row: **PUSH** (next row) or **BANK**.

## 4. Visible setup randomness
- Which door hides the Boo is random per row (seeded per play), but **every Boo door shows a tell** that a careful player can perceive. The tell always plays once, 0.4–0.8 s after the row becomes active, and the player can't tap until the tell has finished (doors unlock with a click). This guarantees the information is always offered.

## 5. Push ladder (3 doors per row, 1 Boo)
| Row cleared | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Multiplier | 1.45x | 2.1x | 3.0x | 4.4x | 6.4x | 9.3x | 13.5x | 19.6x |

Row 8 auto-banks.

## 6. Difficulty by floor
| Floor | Doors per row | Boos per row | Tell types used | Tell duration | Tell strength |
| --- | --- | --- | --- | --- | --- |
| F3 | 3 | 1 | light flicker + creak | 0.5 s | clear |
| F4 | 3 (rows 1–5), 4 with 2 Boos (rows 6–8) | 1–2 | one of: flicker, creak, wobble | 0.35 s | medium |
| Showdown | 3 | 1 | one random tell type per row | 0.3 s | faint |

On F4 rows with 4 doors and 2 Boos, multipliers for those rows use the same ladder (it becomes riskier; intended for experts).

## 7. Easy Assist and Showdown
- Easy Assist: tell duration ×1.5 and plays twice.
- Showdown target: **reach row 5** (6.4x).

## 8. Items and Foam Bat
- **Rewind Remote:** standard.
- **Guardian Gnome:** a Boo refunds the stake.
- **Do-Over Balloon:** after a Boo, retry the same row (same Boo position; the tell plays again).
- **Double Dare Horn challenge:** climb 1 row with a faint tell. Win = ×3 of banked win.
- **Foam Bat:** a teammate can bonk one door per row before the Controller taps: a bonked Boo door pops its ghost early (revealing it as a Boo, so the climber avoids it); a bonked safe door just wobbles (also useful info). One bonk per row. Teamwork!

## 9. Edge cases and anti-abuse
- The Boo map lives only on the server until a door is opened.
- **Known weakness:** the tell has to reach the player's screen, so a cheater reading network traffic could identify the Boo door. Accept this and mitigate it:
  1. Send each row's cue as one message containing an animation value for **every** door (the Boo gets the tell, the others get harmless idle values), so the message shape is the same every time.
  2. Flag players whose safe-door rate is above 98% over 30+ rows for review (see `16`).
- Taps before doors unlock are ignored. PUSH_DECISION timeout → BANK.

## 10. Presentation
- Anticipation: spooky-silly organ music; each row the music rises a step.
- Action: door "creeeak" and a happy "pop" on safe; the climber does a little cheer.
- Win (bank): the climber slides down a slide into a pile of Tickets.
- Loss gags: (1) Boo clown honks a horn in the climber's face, the climber faints into the ball pit, (2) the door is a whoopee cushion, (3) a mirror at the bottom shows a stretched funny reflection of the Controller's avatar.

## 11. Dares and badges
- Dare "Step Into Fire": lose 4 times in a row at the Ladder (joke dare; Medium).
- Dare "Flameproof": bank 3x or more 3 times in a row (Hard).
- Badge "Top of the Funhouse": clear row 8.

## 12. Build notes
- Keep the Boo map server-only. When a row becomes active, fire one `LadderRowCue` event with an array of door cue values (tell or idle) so every row's message looks alike.
