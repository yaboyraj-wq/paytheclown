# SETUP_CONNECTIONS — What to install and connect before sending the prompt

> Do these steps **in order**. Steps marked **(You)** need you personally (identity, payments, passwords). The AI agent should never handle your Roblox password, payments or identity checks.
>
> Note on "Codex Astra": these instructions use the standard OpenAI Codex setup (Codex CLI / Codex app / IDE extension, which share `~/.codex/config.toml` and read `AGENTS.md`). If your Codex version differs, use its equivalent settings screen for "MCP servers" and "project instructions."

## 1. Accounts (You)
1. **Roblox account** for development:
   - Complete the **age check** and **government ID verification** (you're 18+).
   - Turn on **2-Step Verification**.
   - Create a **Roblox Community (group)** that will own the game (e.g., "Lot 13 Studios").
2. **GitHub account** (free) and a **private repository** named `paytheclown`.
3. **OpenAI account** with Codex access.
4. Later (before going public to all ages): either keep **Roblox Plus or Premium for 2 months** or plan to pay the **1,000 Robux refundable publishing fee** (see `docs/20_Roblox_Compliance_and_Safety.md`).

## 2. Software to install
| Software | Why | Notes |
| --- | --- | --- |
| **Roblox Studio** (latest) | The game engine | Sign in with your dev account |
| **Codex** (CLI, app or IDE extension) | The AI agent | Choose your model in Codex settings |
| **Git** | Version control | `git --version` to check |
| **GitHub CLI** (`gh`) | Push code, open pull requests | `gh auth login` (You) |
| **VS Code** (optional) | Read code yourself, review changes | Install the "Rojo" and "Luau Language Server" extensions |
| **Rokit** | Installs the Roblox toolchain | The agent will add `rokit.toml` and install Rojo, Wally, Selene, StyLua, Lune, luau-lsp through it |
| **Rojo Studio plugin** | Syncs code from the repo into Studio | Install from Rojo's docs or the Studio plugin marketplace |
| **Blender** (4.x) | 3D models for NPCs and hero props | |
| **uv** (Python package runner) | Runs the Blender MCP server | Install from Astral's docs |
| **Node.js** (LTS) | Some tools/MCP servers use `npx` | Optional but useful |

## 3. Create the project folder
1. Clone your empty GitHub repo: `git clone https://github.com/<you>/paytheclown.git`
2. Copy **everything** from this spec folder into the repo root:
   - `AGENTS.md` → repo root (Codex reads it automatically).
   - `PROMPT.md`, `SETUP_CONNECTIONS.md`, `00_START_HERE.md` → repo root.
   - `docs/` → `paytheclown/docs/`.
   - `reference/` → `paytheclown/reference/`.
3. Commit: `git add . && git commit -m "Add game spec" && git push`.
4. Open Codex **in this folder** and mark the project as trusted (so it can use the project's settings).

## 4. Connect Roblox Studio (MCP) — required
Roblox Studio has a **built-in MCP server** that lets Codex read your game, edit scripts, run Luau, start/stop playtests, simulate keyboard/mouse input, take screenshots, search/insert assets, and generate meshes, materials and procedural models.

1. Open Roblox Studio and open (or create) the **DEV** place.
2. Open **Assistant** → click **…** → **Manage MCP Servers** → turn on **Enable Studio as MCP server**.
3. Easiest: in **Assistant Settings → MCP Servers → Quick connect**, turn on **Codex CLI** (restart Studio if Codex doesn't appear in the list).
4. Or add it manually to `~/.codex/config.toml`:

**Windows**
```toml
[mcp_servers.Roblox_Studio]
command = "cmd.exe"
args = ["/c", "%LOCALAPPDATA%\\Roblox\\mcp.bat"]
```
**macOS**
```toml
[mcp_servers.Roblox_Studio]
command = "/Applications/RobloxStudio.app/Contents/MacOS/StudioMCP"
```
5. Restart Codex. Check: Studio's MCP panel shows a **green indicator**; in Codex, run `/mcp` and confirm `Roblox_Studio` is listed.
6. Keep Studio open with the DEV place whenever the agent works. (Each tool call targets a specific Studio window by ID; the agent uses `list_roblox_studios` to find it.)

Security: MCP clients can read and modify your open places. Only connect Codex; disconnect when you're not using it.

## 5. Connect Blender (MCP) — recommended
1. Install **uv**.
2. Register the server with Codex (the package was renamed; use whichever works):
```bash
codex mcp add blender -- uvx mcp-for-blender
# older name:
codex mcp add blender -- uvx blender-mcp
```
   or in `~/.codex/config.toml`:
```toml
[mcp_servers.blender]
command = "uvx"
args = ["mcp-for-blender"]
```
3. Install the Blender add-on (`uvx mcp-for-blender install-addon`, or download `addon.py` from the project's GitHub and install it in **Blender → Edit → Preferences → Add-ons → Install**; enable it).
4. In Blender's 3D viewport press **N** → open the MCP tab → **Start MCP Server**.
5. In Codex run `/mcp` and confirm `blender` is listed. Only run **one** AI client against Blender at a time.

## 6. Roblox Open Cloud API key (for publishing and uploads) — recommended
1. (You) Creator Hub → **Open Cloud → API Keys** → create a key for the **DEV experience only** at first. Add permissions for: place publishing, asset upload (models, images, audio), and DataStores (DEV only).
2. Store it as an environment variable on your PC (e.g., `ROBLOX_API_KEY`). **Never** paste it into a file in the repo. The agent will add `.env` to `.gitignore`.
3. Later, create a separate key for LIVE and give it to the agent only for publishing releases you approve.

## 7. Studio settings for the DEV place
- **Game Settings → Security → Enable Studio Access to API Services**: ON for the **DEV** experience only (lets the agent test DataStores in Studio).
- **Allow HTTP Requests**: only needed for some third-party plugins; the built-in MCP doesn't need it.
- Avatar settings: R15 only (the agent sets this per `docs/09`).

## 8. Codex settings (recommended)
- **Sandbox:** workspace-write (can edit files in the project folder).
- **Approvals:** "on request" at first, so you see commands before they run. Loosen later if you trust the flow.
- **Reasoning effort:** high for planning and architecture milestones.
- **Project instructions:** `AGENTS.md` at the repo root (already included).

## 9. Optional connections
| Connection | Why |
| --- | --- |
| GitHub MCP/connector in Codex | Lets the agent open issues and pull requests (or it can use the `gh` CLI) |
| A documentation MCP | Studio's MCP already has `http_get` for Roblox docs, so this is optional |
| An image generator (if your Codex setup includes one) | Concept art and UI icon drafts; otherwise the agent draws icons as vector/SVG and uses Studio's generators |
| An audio tool with a commercial license (e.g., a paid ElevenLabs plan) | Music, sound effects and voice lines; you download files and put them in `art/audio/` for the agent to import |

## 10. Do NOT connect or give the agent
- The **Gamble With Your Friends installation folder** (or any game files) — see `docs/25`.
- Your Roblox password, payment methods, or anything that can spend Robux/real money.
- The LIVE experience's API key until you're ready to publish a release you've approved.

## 11. Final check before sending the prompt
- [ ] Repo cloned, spec files copied, committed.
- [ ] Codex opens in the repo folder and sees `AGENTS.md`.
- [ ] Studio open with the DEV place; MCP green indicator; Codex `/mcp` lists `Roblox_Studio`.
- [ ] Blender open with the MCP server started; Codex `/mcp` lists `blender`.
- [ ] Rojo plugin installed in Studio.
- [ ] `ROBLOX_API_KEY` env var set (DEV key).
- [ ] You have a DEV experience published (empty Baseplate is fine) under your group.

Then paste the contents of `PROMPT.md` into Codex.
