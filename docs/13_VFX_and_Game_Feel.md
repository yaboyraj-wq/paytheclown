# 13 — VFX, Camera and Game Feel ("Juice")

> "Juice" is the hundreds of small reactions that make every action feel good. It's the difference between a game that works and a game that feels like thousands of dollars were spent on it.

## 1. Juice rules (apply everywhere)
1. **Every input reacts on the same frame** with sound + visual on the player's own client (prediction), even before the server confirms.
2. **Every result is readable from across the floor** (big text, color, sound).
3. **Every currency change animates** (fly-to-jar trails, rolling numbers).
4. **Losses are funny.** Each booth has 3 rotating loss gags.
5. **Escalation:** bigger results get bigger reactions (win tiers in `05_Booths/00_Booth_Framework.md` §10).
6. **Respect settings:** Reduce Motion, Reduce Flashing, Camera Shake off.

## 2. Effect catalog (build as reusable modules in `Client/VFX`)

| Effect | Used for | Details |
| --- | --- | --- |
| Ticket trail | Stakes, payouts | 6–30 ticket sprites arc from source to the HUD jar (UI-space bezier); count scales with amount |
| Confetti burst (S/M/L) | Wins | ParticleEmitter, palette colors, gravity, 0.6–1.5 s |
| Fireworks | Huge wins, endings, Ticket Rain end | 3D particles over the booth/floor |
| Splat | Splat Wheel, pie loss gags | Decal + particle, fades 3 s |
| Screen splat | Pie in face, paint | ScreenGui image with drip animation, 1–1.5 s, small and off-center so play isn't blocked |
| Sparkle ring | Items active, Guardian Gnome halo, Zap Wand booth | Beam/attachment ring, palette color |
| Lightning crackle | Zapped booth, Hype Battery | Beam zigzags, 2 Hz flicker (Reduce Flashing = static glow) |
| Slow-mo | Huge win, cannon | 0.5 s at 30% animation speed on cosmetic animations only (server time is never slowed) |
| Number punch | Multiplier text | Scale 1.6 → 1.0 with overshoot, 250 ms |
| Camera shake | Big wins, cannon, bat bonks | Small amplitude (≤ 0.3 studs), 150–400 ms; off if Camera Shake is off |
| Light chase | Booth bulbs, night intro | Sequential emissive toggles |
| VHS rewind | Rewind Remote | Full-screen scanlines + color fringe + reverse audio blip, 1 s |
| Smoke puff | Loss gags, cannon | ParticleEmitter |
| Dizzy stars | Bonked players | Billboard stars orbiting head, 1 s |

## 3. Camera
- **Default:** Roblox follow camera, slightly higher and wider than default on floors (players need to see booths around them). Smooth zoom limits per area.
- **Booth play camera:** fixed framing per booth (defined in each booth's build notes), tween 0.4 s in/out. On mobile, frame action inside the safe area above the on-screen controls.
- **Spectator "Watch" camera:** wider version of the play camera.
- **Cinematics:** scripted camera paths with `TweenService` on `CFrame`: Clown Car departure, night intro, Closing Count, cannon, Showdown, endings. All skippable (after first view) except the first two cannons.
- **Never** take camera control from a player who is not involved, except for crew-wide cutscenes.

## 4. The Big Cannon sequence (signature moment — make it great)
1. Sirens and Bigsby's "Load the cannon!" (1.5 s).
2. Honk apologetically herds the crew into the cannon (players are teleported into position, 1 s).
3. Drumroll; Bigsby lights the fuse (1.5 s).
4. **BOOM** — slow-motion 1 s: each player flies out ragdolling in a spread pattern; **each player's Cannon Launch Style** plays (default: confetti trail; cosmetic styles: rocket trail, pie splat, rainbow, firework burst, duck floaty…).
5. Real-speed flight over the Ferris wheel (2.5 s), splash into the lake (fountain of water + rubber ducks), players pop up wearing inner tubes.
6. Summary UI fades in.
Total about 9–11 s. This moment is the most clipped and shared — it's worth extra polish.

## 5. Performance rules for effects
- Max active ParticleEmitters per client: 40; max particles per emitter rate 60/s; scale down by 50% on low-end devices (detect via a quick frame-time sample, not device name).
- Reuse effect instances (pooling) — never create/destroy hundreds per second.
- UI ticket trails max 30 sprites per trail; merge trails if more than 3 run at once.
- Lights: emissive materials for bulbs; real `PointLight`s only where they matter (≤ 8 shadow casters visible).

## 6. Game-feel checklist per booth (part of the definition of done)
- [ ] Stake trail to the booth
- [ ] Anticipation sound + light build
- [ ] Same-frame input response
- [ ] Tiered win reaction
- [ ] 3 loss gags rotating
- [ ] World reaction (crowd/Bigsby line) on Big+ wins
- [ ] Spectators can see what's happening from the watch zone
- [ ] Works with Reduce Motion / Flashing
