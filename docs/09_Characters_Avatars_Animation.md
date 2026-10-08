# 09 — Characters, Avatars and Animation

## 1. Decision: players are their own Roblox avatars

The Steam game uses uniform cartoon blob characters. **We do not.** Players play as their own Roblox avatars because:
- On Roblox, the avatar is the player's identity and they pay real money to customize it. Replacing it removes self-expression and the urge to show off.
- Friends recognize each other instantly.
- Our cosmetics (Gert's Thrift Tent) are designed to be worn **on top of** avatars, which drives Stars and Robux spending.

An optional **Mascot Suit** costume (sold for Stars) gives a goofy full-body carnival-mascot look for players who want a uniform style. It's a cosmetic, never required.

## 2. Avatar rules (set in Game Settings and code)

| Rule | Setting | Why |
| --- | --- | --- |
| Rig type | **R15 only** | Ragdolls, emotes, layered costumes and penalties work the same for everyone |
| Body scale | Allow player scales, but booth control pads and seats must fit the full range (test with the tallest and smallest allowed scales) | Players hate being forced to a default body |
| Collisions | Players don't collide with each other on floors (collision groups) — except during the Foam Bat bonk ragdoll and in the Bouncy Lot | Prevents body-blocking booths |
| Accessories during booth play | Hide accessories larger than a size threshold (hats/back items over ~3 studs) **for the Controller's own camera only** while playing | A giant hat must never block the view of a booth |
| Crew sash | Every crew member wears a colored carnival sash (color assigned on joining: Red, Blue, Green, Yellow, Purple, Orange) | Teammates are easy to spot across a floor; color + a sash pattern for color-blind players |
| Name tags | Billboard name tag with sash color and an icon if VIP/Club | Readability |
| Emotes | Roblox default emotes allowed + our emotes from the Thrift Tent | Expression |

## 3. The penalty looks (Pawn Clamp)
| Piece pawned | How it looks on the avatar |
| --- | --- |
| Shades | A cartoon "smudged" pair of glasses on the face (the screen effect is only for that player) |
| Voice Box | A little red bike horn strapped over the mouth area; honks when they "talk" |
| Shoes | Giant floppy clown clogs replace feet visually; squeaky steps |

These must be built as accessories that work on any R15 avatar.

## 4. NPC characters (original, built in Blender, imported as rigs)

| Character | Rig | Triangle budget | Animations needed |
| --- | --- | --- | --- |
| Bigsby the Clown | Custom humanoid rig (R15-compatible bone names make reuse of Roblox animation tools easier) | ≤ 15,000 | Idle (belly bounce), Laugh, Count money, Grumble, Gasp, Point, Walk (floor stroll), Fire cannon, Cry into hanky, Sweep (ending), Showdown host pose, Taunt (3 variants) |
| Honk | Small humanoid rig | ≤ 6,000 | Idle, Wave, Point, Stamp, Honk horn, Nervous fidget, Load cannon, Cheer |
| Slick Sal | Humanoid rig | ≤ 8,000 | Idle lean, Open coat (show gadgets), Hand over item, Wink, Count Tokens |
| Grandma Gert | Humanoid rig | ≤ 8,000 | Rocking-chair knit idle, Clap, Adjust glasses, Measure-tape gesture |
| The Pawn Clamp | Mechanical rig (bones for claw, eye, drawer) | ≤ 8,000 | Idle hum, Eye look-at, Grab, Drawer open (payout), Shake |
| Sir Waddles | Rigid mesh + simple bones | ≤ 1,500 | Waddle, Quack, Spin, Bow |
| Bot ducks, cardboard fans, pins | Rigid meshes, tweened | ≤ 800 each | Procedural (tweens) |

Rig specs (from Roblox docs): bones frozen at scale 1 and rotation 0, root at 0,0,0, max 4 influences per vertex, no influence on the root, one animation track per FBX export. See `11_Art_Direction_and_Assets.md`.

## 5. Player animations (custom; play on any R15 avatar)

| Category | Animations |
| --- | --- |
| Booth actions | Throw (underhand, overhand), Ring toss flick, Mallet swing (Strongman), Bowl, Press big button, Pull lever (Rocket eject), Claw grab gesture, Tap-tile gesture, Paddle (Duck Derby seat), Juggle catch (left/right), Cheer on win, Facepalm on loss |
| Movement extras | Clown-clog waddle (Shoes pawned), Fizz Pop wobbly run |
| Items | Pop balloon, Blow horn, Wrench twist, Open crate, Hold up golden ticket, Zap wand flourish, Drink soda, Fire popper, Snap photo, Press remote, Plug in battery, Sing (karaoke, 3 loops), Plant gnome, Wrap in bubble wrap, Put on bowtie, Magnet sweep |
| Foam Bat | Swing (3 variants), Bonk reaction (the victim: dizzy stars), Rest on shoulder idle |
| Social | Crew pose (night summary), Celebration emotes from the shop, MVP pose, Biggest Loser slump |
| Cannon | Enter cannon, Launch flail, Ragdoll in the air, Splash landing (ending), plus each **Cannon Launch Style** cosmetic (see `14`) |
| Ending | Ringmaster bow, Clown-makeup surprise, Wave goodbye from the van |

Animation production approach (AI-friendly):
1. **Roblox Animation Editor** keyframes for most player animations (the agent can author KeyframeSequences through Studio MCP and Luau, or the user can capture them).
2. **Procedural animation** via tweens and springs for UI, booth machinery, ducks, pins, wheels, reels, doors, and camera shakes. Prefer procedural motion wherever it looks good; it's smoother and costs no assets.
3. **Blender** for NPC rigs and complex NPC animations, exported as FBX per Roblox export settings.
4. Use Roblox's built-in animation marketplace/catalog only for items Roblox licenses for free use in experiences (check each asset's license), never ripped animations.

## 6. Ragdoll and physics comedy
- Ragdoll implementation: on the server, replace Motor6Ds with BallSocketConstraints for the duration, then restore (standard Roblox ragdoll technique). Network owner = the player for smooth local physics; position is reset after.
- Used for: Foam Bat bonks (1 s), the Big Cannon launch, Bouncy Lot falls (optional).
- Never allow ragdolls to push players off the map: invisible safety walls around floors; out-of-bounds returns the player to the lift with a "boing."

## 7. What we are NOT taking from the original
- Their character bodies (blob mascots), faces, outfits, and silhouettes.
- Their animations (we author our own).
- Their lobby/limo/elevator cutscenes (we have the Clown Car and prize crate).
- Their body-part removal visuals (we use clothing-like pieces and slapstick).
- Their NPC designs (the loan shark, the trailer vendor, any boss look).
