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

## Project map

- `src/shared/Config`: values and identifiers from the design
- `src/shared/Logic`: pure, independently tested game rules
- `src/shared/Net`: remote definitions and validation
- `src/server`, `src/client`: services and presentation
- `assets`: tracked original models; `art`: sources and asset records
- `tools/tests`: Lune tests; `docs/27_Decisions_Log.md`: plans and decisions

Never put keys or cookies in files. `.env` is ignored. Dependencies are restored
from `wally.lock`; they are not copied into Git. No third-party game files are used.

