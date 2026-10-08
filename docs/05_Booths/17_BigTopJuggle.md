# Booth 17 — Big Top Juggle (original booth; our 17th game)

## 1. Summary
| Field | Value |
| --- | --- |
| ID | `BIG_TOP_JUGGLE` |
| Replaces (original) | Steam lists 17 games but only 16 are named in public sources, so this is our own 17th booth. It is not based on anything in the original. |
| First floor | F4 The Big Top |
| Type | Co-op rhythm + nerve (push) |
| Seats | **Multi-seat: 1 to 3 jugglers**, one shared stake |
| Authority | Pattern A |
| Round length | 10–40 s |

## 2. Fantasy and look
A spotlight circle in the Big Top. Up to 3 players stand on star marks. Juggling pins fly between them in arcs. A giant multiplier sign hangs above. Drumroll.

## 3. How it plays
1. The first player sets the stake and GO; a 5-second join window lets up to 2 more crew members step on star marks.
2. Pins arc toward players. Each player has catch prompts that appear on their screen (lanes like a rhythm game). Press **CATCH** when the pin's ring shrinks onto the hand marker.
3. Each successful catch adds to a shared counter. Every 5 catches the multiplier steps up and the tempo rises.
4. **Any player** can call **TAKE A BOW** (bank) after a step; it needs only one press.
5. A drop (a missed catch) ends the act → lose (unless banked).

## 4. Visible setup randomness
- Pin throw sequence (which player gets which pin) is seeded per round but each pin is visible in flight for at least 0.8 s before it must be caught.

## 5. Push ladder
| Catches | 5 | 10 | 15 | 20 | 25 | 30 | 40 | 50 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Multiplier | 1.5x | 2.0x | 2.6x | 3.3x | 4.1x | 5.0x | 7.0x | 10x |

At 50 catches → auto-bank at 10x.

## 6. Difficulty
| Setting | Value |
| --- | --- |
| Start tempo | 90 BPM |
| Tempo increase | +6 BPM per step |
| Catch window | ±0.11 s at start, shrinking to ±0.08 s at 30+ catches |
| Pins in the air | 1 per juggler at start, +1 every 10 catches (max juggler count + 2) |
| Showdown | starts at 110 BPM, window ±0.09 s |

Solo juggling uses the same table (one player gets every pin, so tempo per player is higher; solo bonus: +0.2x on banked multiplier to keep solo fair).

## 7. Easy Assist and Showdown
- Easy Assist: window +25%.
- Showdown target: **reach 20 catches (3.3x)** and bank.

## 8. Items and Foam Bat
- **Karaoke Mic** nearby boosts payout (thematic!).
- **Do-Over Balloon:** after a drop, restart from 0 catches with the same seed.
- **Double Dare Horn challenge:** 5 more catches at +20 BPM. Success = ×3 of banked win.
- Foam Bat: not allowed in the spotlight circle (players are busy; prevents griefing).

## 9. Edge cases and anti-abuse
- One stake (from the starting player). Payout goes to the jar. Stars for wins are given to all jugglers.
- A juggler who leaves the circle mid-act causes a drop on their next pin (so leaving is not a safe escape).
- A griefer who joins and deliberately drops: the starting player can set **"Solo act"** on the keypad (no join window). Default is "Open act."
- Inputs evaluated per Pattern A; auto-clickers are blocked by limiting to one catch input per pin.

## 10. Presentation
- Anticipation: spotlight narrows, drumroll builds every 5 catches.
- Action: pin "whup-whup" spin sounds, a crisp "clap" on catch.
- Win (bow): roses fall from above; the crowd stands.
- Loss gags: (1) pins bonk all jugglers' heads in sequence (comedy bonks), (2) a pin lands upright on someone's head and they freeze in a pose, (3) a seal (cardboard) catches the dropped pin and claps.

## 11. Dares and badges
- Dare "Three-Ring Circus": bank 3.3x or more with 3 jugglers (Hard).
- Badge "Juggle Legend": reach 50 catches.
