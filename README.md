# Pay the Clown!

A 1–6 player co-op carnival crawler. One shared jar. Five-minute skill nights.
Built from the original design in [00_START_HERE.md](00_START_HERE.md).

## Development

Only the private **Pay the Clown [DEV]** experience is authorized. Its identifiers
live in `src/shared/Config/Environment.luau`. The bootstrap refuses other places.
Do not publish LIVE. No API key is needed for the local prototype.

1. Install Rokit, Git, GitHub CLI and the Rojo Studio plugin.
2. Run `rokit install`, then `wally install`.
3. Run `powershell -File tools/check.ps1` to build and check the project.
4. Open the confirmed DEV place in Studio.
5. Run `rojo serve dev.project.json`. In the Rojo Studio plugin, Connect to
   `localhost:34872`, review the sync changes, then accept the connection.
6. Press Play. Stop Play before changing which Rojo project is served.

Rokit is currently installed at `C:\Users\YaBoy\.rokit\bin\rokit.exe`.
If commands are missing, fully restart Codex/your terminal to refresh PATH.
The check script also finds Rokit tools in the standard installation folder.

`dev.project.json` combines hub and tower for early milestones.
`hub.project.json` and `tower.project.json` build the separate future places.
Shared money and outcomes always belong to the server.

## Play the M1 prototype

Start with the [M1 playtest guide](docs/M1_PLAYTEST.md) for exact local multi-client
and DEV friend invitation steps. M1 is waiting at the director's playtest gate.

In Lot 13, press **READY**. Walk onto a booth pad and press **E** (or tap its
PLAY prompt). Set the shared stake and press **GO**. The crew has five minutes
to cover the quota. Bigsby takes payment at closing; falling short launches
everyone from the placeholder cannon. The host can press **PLAY AGAIN**.

- **Stop-the-Reels:** study the visible strips, then stop each reel with the
  button, Space, or R2. Matching symbols pay according to the preview card.
- **Block Toss:** aim with buttons, right-drag, or the left stick. Choose spin.
  Hold and release TOSS, Space, or R2 to set power. The right card explains
  the opening totals and Point rules.
- **Pie Sweeper:** choose pie count/opening and memorize the preview. GO hides
  the pies. PUSH, pick a covered tile, then BANK before a splat. Right-click
  tiles or use FLAGS for notes. Decision timeout banks automatically.

This is a gray-box fun test: no saves, shops, items, final art, audio or endings.
The written Pie cascade formula can pay 50x immediately at low pie counts;
that balance concern is recorded for the director's playtest.

## DEV testing commands

Type these in Roblox chat. They are intercepted by TextChatService rather than
sent as player chat. They work only in the exact authorized DEV experience,
and only in Studio or for the verified owner.

| Command | Effect |
| --- | --- |
| `/ptc jar 1000` | Set the shared jar; recorded in the audit log |
| `/ptc skip` | Depart from Day, or finish the current timed phase |
| `/ptc night 4` | Return to Day before Night 4; preserve the jar |
| `/ptc pass` | During a night, close it with a forced quota pass |
| `/ptc fail` | During a night, close it with a forced quota failure |

Night jumps accept 1–100. Jar values accept whole Tickets from 0–9,999,999,999.
Forced pass adds any missing quota Tickets with a DEV audit entry. These commands
are test aids; use ordinary controls for the three friend-group fun sessions.

Studio server checks live in `tools/qa`. They are **not** shipped by Rojo. Run them
as temporary Scripts in Play mode on DEV, not by requiring services in the MCP
command context (that has a separate module cache).

## Project map

- `src/shared/Config`: values and identifiers from the design
- `src/shared/Logic`: pure, independently tested game rules
- `src/shared/Net`: remote definitions and validation
- `src/server`, `src/client`: services and presentation
- `assets`: tracked original models; `art`: sources and asset records
- `tools/tests`: Lune tests; `docs/27_Decisions_Log.md`: plans and decisions

Never put keys or cookies in files. `.env` is ignored. Dependencies are restored
from `wally.lock`; they are not copied into Git. No third-party game files are used.
