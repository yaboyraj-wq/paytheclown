# 12 — Audio

> Sound does more for "this feels expensive" than graphics do. Every action gets a sound. Every sound belongs to one carnival world.

## 1. Sources (licensing first)
1. **Roblox Creator Store audio that Roblox licenses for use in experiences** (Roblox provides a library of licensed music and sound effects). Check each asset's license/terms.
2. **AI-generated audio from a tool whose paid plan grants commercial game use** (for example ElevenLabs paid plans, which bundle music, sound effects and voices). Keep receipts and the plan's terms in `docs/27_Decisions_Log.md`.
3. **Original audio** made by the user.
- **Never** use audio ripped from the original game, other games, songs, TV or movies. No real songs in the karaoke feature (all karaoke songs are original jingles).
- All uploaded audio must be owned by the experience owner (user or group) or be public and licensed for use.

## 2. Mixing structure
- `SoundService` with `SoundGroup`s: `Music`, `SFX`, `Voice`, `UI`, `Ambience`. Each has a settings slider (Settings screen) except Ambience (tied to SFX).
- Ducking: when a voice line plays, duck Music by −6 dB for its duration; when a Big/Huge win plays, duck Music −4 dB for 1.5 s.
- Loudness target: normalize all music to roughly −16 LUFS integrated and SFX peaks to −3 dBFS so nothing is jarringly loud.
- Spatial sounds (`Sound` parented to parts): booth sounds use `RollOffMode = InverseTapered`, min 10 studs, max 80 studs, so you hear nearby booths and a murmur of the floor.
- Limit simultaneous sounds: cap per category (SFX 24, Voice 2, Music 2) to avoid mush and protect performance.

## 3. Music tracks
| Track | Where | Notes |
| --- | --- | --- |
| Gates Theme | Hub | Upbeat calliope + modern beat, loopable 90–120 s |
| Lot 13 Day | Lot 13 | Relaxed banjo/ukulele-calliope mix, sunset vibe |
| Clown Car Sting | Departure cutscene | 8 s honky drive-off |
| F1 Midway Night | F1 | Classic carnival waltz-to-swing, 120 BPM |
| F1 Final Call | F1 last 60 s | Same theme, faster (150 BPM), more percussion |
| F2 Neon Night / Final Call | F2 | Synthwave-calliope fusion |
| F3 Funhouse Night / Final Call | F3 | Spooky-silly organ + bouncy bass (never scary) |
| F4 Big Top Night / Final Call | F4 | Grand circus march with brass |
| Closing Count | Counting cutscene | Drumroll + build |
| Night Survived | Summary | Short triumphant fanfare |
| Cannon | Launch | Slow-motion orchestral swell into a comedic "boing" |
| Showdown | Center Ring | Epic circus showdown theme |
| Endings ×3 | Endings | Paid in Full (warm sunrise), Ringmasters (victory), Part of the Act (silly march) |
| Event tracks | Seasonal | Haunted Midway, Frostbite Fair variants |

Final Call versions must be separate tracks (not pitch-shifted) and crossfade on the beat within 1 s.

## 4. Sound effects (minimum list)

### 4.1 Universal
Stake lock "ka-ching" + ticket whoosh · Jar gain (coins pouring, scaled by size) · Jar loss "thunk" · Win tiers ×4 (small/medium/big/huge stings) · Loss stings ×3 (sad trombone, kazoo, slide whistle) · Push ("ding-up" rising per step) · Bank ("cash register") · Timer tick (last 10 s) · Closing Bell · Big-stake toast alert · Approve / No way clicks · Toast chimes per type · Error bonk · Purchase success fanfare · Level/pass tier up.

### 4.2 Per booth (each booth file lists its cues)
Each booth needs: action sounds (throws, stops, taps), anticipation loop, win sound, 3 loss-gag sounds. Pitch-varied variants (±5%) to avoid repetition fatigue.

### 4.3 Items
One use sound per item (17) + Hyped variant layer (electric sparkle).

### 4.4 Lot 13 and hub
Crate pop, Honk's horn, Dare stamp, Sal's register, Gert's tent rustle, Pawn Clamp beeps and claw, Bill Box clunk, trampoline boing, Clown Car honk and engine, hub crowd ambience, gate creak.

### 4.5 Characters (voice)
- Bigsby: ~40 barks (see `02` §3.1 for the starting set), Honk: ~20 honk-words, Sal: ~15, Gert: ~10, Pawn Clamp: beeps + robot words.
- Voice style: cartoon, exaggerated, short. Captions always available (on by default).
- Use a voice tool with a commercial license, or the user's own voice performance; never imitate a real celebrity's voice.

## 5. Ambience
- Each floor: crowd murmur bed, distant rides, bulb buzz, area-specific layer (F2 arcade beeps, F3 creaky floorboards and distant giggles, F4 big tent echo).
- Lot 13: crickets, distant carnival music muffled, wind chimes.

## 6. Rules
1. Every UI button has a sound.
2. Every booth input has a sound on the same frame (client-side immediate).
3. No sound longer than 2 s for frequent actions.
4. The jar gain sound scales with the size of the gain (small trickle → avalanche).
5. Audio assets are preloaded per area to prevent first-play silence.
