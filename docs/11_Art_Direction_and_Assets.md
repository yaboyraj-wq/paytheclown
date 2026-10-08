# 11 — Art Direction, Assets, Logo and Store Art

> Goal: every screenshot looks like one studio made it. Consistency beats detail. A simple, cohesive, well-lit world looks more expensive than a detailed, mismatched one.

## 1. The style in one line
**Chunky toy-like carnival:** rounded, slightly exaggerated shapes; saturated colors; soft warm night lighting with glowing bulbs; hand-painted-looking textures; cartoon proportions; no realistic grime, no gore, no realistic faces.

### Style rules
1. **Shapes:** rounded edges and bevels everywhere (no razor-sharp corners). Booths are chunky and slightly top-heavy like toys. Bigsby's things are tall and spiky (villain shape language); the crew's things are round.
2. **Color:** use only the palettes in §2. Saturated mid-tones, warm highlights, cool purple shadows.
3. **Materials:** mostly painted wood, painted metal, canvas, plastic, glass, light bulbs. Use Roblox materials or simple PBR with hand-painted albedo; avoid photo textures.
4. **Light:** every floor has a key light color, plenty of bulb strings (emissive, not real lights), and a few real lights for mood.
5. **Signage:** every booth has a big painted sign with its name in the display font style (as a texture or SurfaceGui text).
6. **Readability first:** gameplay objects (targets, cups, doors, pins) contrast strongly with backgrounds.

## 2. Palettes (hex)

| Area | Primary | Secondary | Accent | Shadow/ambient |
| --- | --- | --- | --- | --- |
| Hub (Midway Gates, dusk) | `#E63946` red | `#FFC93C` gold | `#FFF4DC` cream | `#3A1F5D` purple |
| Lot 13 (sunset) | `#FF8C42` orange | `#FFC93C` gold | `#2EC4B6` teal | `#5A3E7A` dusk purple |
| F1 The Midway | `#E63946` red | `#FFC93C` gold | `#FFF4DC` cream | `#2B1B3D` ink |
| F2 Neon Arcade | `#00E5FF` cyan | `#FF2DAA` magenta | `#FFE600` yellow | `#14082B` deep purple |
| F3 Funhouse | `#7B2CBF` purple | `#A3E635` lime | `#FF8C42` orange | `#1B0F2E` |
| F4 The Big Top | `#E63946` red | `#F8F9FA` white | `#FFC93C` gold | `#1D3557` navy |

## 3. Lighting per area (Studio settings to start from)
- `Lighting.Technology = Future` (scales down on low-end devices automatically). Keep shadow-casting lights to ≤ 8 visible at once per area.
- Each area has a preset module (`Shared/Config/LightingPresets.luau`) applied when the area becomes active: `Ambient`, `OutdoorAmbient`, `ClockTime`, `Atmosphere` (density, color, haze), `Bloom` (intensity 0.4–0.8), `ColorCorrection` (saturation +0.1, contrast +0.05, floor tint), `SunRays` off indoors.
- Night intro: lights turn on in a chasing sequence (fun, readable).
- Final Call: floor lights pulse in time with the music (respect Reduce Flashing).

## 4. How the art gets made (AI-built pipeline)

Order of preference for each asset:
1. **Roblox parts + materials** (fast, cheap, editable by the agent through Studio MCP). Great for booth frames, stalls, floors, walls, signs, simple props. Use rounded parts (`Part` with `Shape`, wedges, cylinders) and **SurfaceGui** for signs.
2. **Studio's `generate_procedural_model`** (Studio MCP) for prop variations built from primitives.
3. **Blender via Blender MCP / Python scripts** for anything that needs smooth curves or characters: Bigsby, Honk, Sal, Gert, Pawn Clamp, Sir Waddles, ducks, pins, the Clown Car, the Big Cannon, the jar, the logo prop, wheel faces. Export FBX with Roblox's settings (§5).
4. **Studio's `generate_mesh` / `generate_material`** for quick background props and tiling materials, then restyle to match the palette.
5. **Creator Store assets** only if their license allows use and they're restyled to match; never as hero assets.

**Never** use, trace, or derive from the original game's models, textures, UI art, logo, or screenshots.

### 4.1 The "same studio" test (every asset)
Put the new asset in a screenshot next to three approved assets under the area's lighting. If it stands out as different in style, detail level or color, fix it or redo it.

### 4.2 Hero assets get extra rounds
Hero assets (players look at them closely): Bigsby, the Jar (HUD icon + 3D props), the Big Cannon, the Clown Car, every booth's centerpiece, Sir Waddles, the logo. Background assets get one pass.

## 5. Roblox technical specs (from Roblox's official modeling docs)

| Rule | Requirement |
| --- | --- |
| Triangles | No single mesh over **20,000 triangles** |
| Geometry | Watertight, quads where possible, no n-gons, no zero-thickness faces |
| Rigs | Bones frozen at scale 1 and rotation 0; root at 0,0,0; max 4 influences per vertex; no influence on root |
| Animation | One animation track per FBX export |
| Textures | Up to 4096×4096 supported; size by object: ~256 for a 5-stud object, 512 for 10, 1024 for 20 |
| PBR (SurfaceAppearance) | Albedo (RGB), Normal (**OpenGL** tangent space), Roughness, Metalness, Emissive (grayscale) |
| UVs | One UV set, within 0–1, overlaps allowed |
| Materials | One material per mesh |
| Blender export | File → Export → FBX; Path Mode = Copy + Embed Textures; Apply Scalings = FBX Unit Scale; Add Leaf Bones off; Bake Animation off unless animating |

### 5.1 Performance budgets (targets for our baseline phone; confirm on a real device)
| Budget | Target per visible area |
| --- | --- |
| Draw calls | ≤ 600 on F1–F4 floors, ≤ 400 in Lot 13 |
| Triangles on screen | ≤ 650,000 |
| Unique textures per floor | ≤ 40 (use trim sheets and shared palettes) |
| Client memory (baseline phone) | aim under ~1 GB total; check the Performance Stats overlay on the device |
| Frame rate | 60 fps on PC, 30+ fps on the baseline phone |

Reuse meshes and textures everywhere (instancing needs the same mesh and texture IDs). Combine small static pieces into one mesh in Blender. Use `Model.LevelOfDetail` and streaming for floors. Test memory on a real phone; Studio numbers are inflated because Studio runs client and server together.

## 6. Master asset list

### 6.1 Characters (see `09`)
Bigsby, Honk, Slick Sal, Grandma Gert, Pawn Clamp, Sir Waddles, bot ducks (×4 colors), cardboard crowd fans (×6 variants), juggling pins, crew sashes (×6 colors), penalty accessories (smudged glasses, honk box, clown clogs), Mascot Suit costume.

### 6.2 Booths (17) — each needs: stall/frame, centerpiece, control pad, watch zone decal, sign, props, VFX hooks
Hoop Wheel, Ring Stack 21, Stop-the-Reels, Duck Derby (channel + ducks + bleachers), Block Toss (pit + foam blocks), Strongman Spinner (frame + wheel + mallet), Splat Wheel, Penguin Crossing (diorama + vehicles + penguin), Gem Recall (tile floor + dome + gems), Rocket Ride (cockpit + screen + 3D pole rocket), Hi-Lo Meter (gauge), Pinball Drop (cabinet), Funhouse Ladder (door wall + climber), Pie Sweeper (table + cloches + pies), Card Catch (conveyor + claw + 32 card faces), Bowl to Nine (lane + clown pins + ball), Big Top Juggle (spotlight circle + pins).

### 6.3 Environments
| Area | Key pieces |
| --- | --- |
| Midway Gates (hub) | Gate arch with logo, ticket booths ×6, leaderboard tower, Cannon Cam screen, Thrift Tent storefront, practice alley, VIP balcony, food carts (decor), fog, string lights, Ferris wheel in the distance |
| Lot 13 | Prize crate, Dare Board, Sal's trailer, Gert's tent, Pawn Clamp, Bigsby's office trailer + Bill Box, Crew Trailer, Bouncy Lot (trampolines, slide, ball pit), Clown Car, tower lift entrance, junk props |
| F1 The Midway | Striped tents, bulb arches, popcorn carts, hay bales, 5 booth pads |
| F2 Neon Arcade | Neon tubes, arcade cabinets (decor), checker floor, holographic signs, 7 pads |
| F3 Funhouse | Warped mirrors, tilted floors (visual only), spinning tunnel arch, ghost-clown cutouts, 7 pads |
| F4 The Big Top | Giant tent interior, ring, bleachers, spotlights, trapeze rigs (decor), Center Ring stage, 7 pads |
| Cinematics | Big Cannon + lake + Ferris wheel backdrop, counting machine, Grand Balloon, the van, ending sets |

### 6.4 UI art (see `10`)
Logo, icon set (~80 icons: currencies, items, booths, statuses, settings), panel frames and button shapes (9-slice), item card art (17), booth icons (17), dare icons, badge icons (~45), cosmetic thumbnails (rendered from the in-game items with a consistent camera rig and lighting), loading screen art, teleport screen art.

## 7. Logo
- **Wordmark:** "PAY THE" small on a red ribbon banner; **"CLOWN!"** huge below in chunky circus-poster letters (red fill, gold inline, 3–4 px Ink outline at icon size, offset Ink shadow).
- **Mascot:** Bigsby's grinning head peeking over the "O," holding the end of a long rolled bill that curls around the word.
- **Details:** light-bulb dots around the banner; a small ticket-stub tag reading "CARNIVAL CO-OP."
- **Must read at 150 px wide.** Test it as a Roblox tile.
- Our own design: do **not** imitate the original game's logo layout, colors or lettering.

## 8. Game icon (512×512 minimum, square)
- Bigsby's face close-up (big grin, gold tooth) holding up a giant golden ticket, on a red-and-gold sunburst. No small text (unreadable at tile size). Optional tiny "PAY UP!" ribbon only if readable at 150 px.
- Make 2–3 variants (different expressions/backgrounds) for testing over time.

## 9. Thumbnails (1920×1080, 16:9; upload 3–5 for Roblox thumbnail personalization)
Each must show **real gameplay moments** (Roblox requires imagery that represents the experience). Use staged in-game shots (Studio free camera) with real avatars, then light overlays (no misleading content).

| # | Concept | Overlay text (≤ 3 words) |
| --- | --- | --- |
| 1 | The whole crew mid-air out of the Big Cannon over the Ferris wheel, Bigsby laughing | "DON'T GET FIRED!" |
| 2 | A friend about to EJECT at Rocket Ride at 9.8x while the crew screams; jar meter visible | "PUSH IT?!" |
| 3 | Bigsby looming over a tiny crew holding the giant bill | "PAY THE CLOWN!" |
| 4 | Four booths montage (Hoop Wheel, Pie Sweeper, Duck Derby, Block Toss with bat bonk) | "17 GAMES!" |
| 5 | Crew in costumes on the Big Top stage, confetti | "WITH FRIENDS!" |

Composition rules: one clear focal subject, faces/characters big, high contrast, readable at small size, nothing important in the corners where Roblox overlays metadata. Swap thumbnails with each big update and let personalization pick winners (don't remove a thumbnail too early).

## 10. File and naming conventions
- Asset names: `Area_Object_Variant` (e.g., `F1_Booth_HoopWheel_Frame`, `Char_Bigsby_Rig`, `UI_Icon_Item_ZapWand`).
- Source files in repo: `art/blender/<area>/<asset>.blend`, exports in `art/export/<asset>.fbx`, textures in `art/textures/<asset>_<map>.png`, UI in `art/ui/`.
- Keep an `art/ASSET_LOG.md` listing each asset, how it was made (parts / procedural / Blender / generated), its uploaded asset ID, and the human creative decisions (selection, edits) — useful for ownership records (see `25`).

## 11. Reference board
The user may place their **own** screenshots and clips in `reference/` (e.g., real carnivals, cartoon styles, other Roblox games, their own recordings of playing the original for *feel* notes). Rules for using references: `25_Original_Game_Reference_Policy.md`.
