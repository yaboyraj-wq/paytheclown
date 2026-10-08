# 24 — Testing, QA and Definition of Done

## 1. Test layers
| Layer | Tool | What |
| --- | --- | --- |
| Unit tests | **Lune** running `src/shared/Logic` modules | Quota math, stakes, payouts and bonus caps, every booth's pure logic (reel symbol at time t, needle position, wheel spin result, Pie Sweeper board/cascade/multiplier, Card Catch hand ranking, Hi-Lo multipliers, rocket multiplier), RNG streams reproducibility, formatting, schema migrations |
| Simulation | `tools/economy_sim` | Balance targets (`04` §11) |
| Studio playtest (single client) | Studio MCP: `start_stop_play`, `character_navigation`, `user_keyboard_input`, `user_mouse_input`, `get_console_output`, `screen_capture`, `execute_luau` (Server/Client) | Flows, UI, booth interactions, error-free output |
| Multi-client | Studio Test → Server + 2–4 clients | Shared jar, approvals, votes, multi-seat booths, disconnects |
| Published DEV experience | Real devices and real friends | Teleports, saves, purchases (test products), performance |
| Exploiter simulation | Scripted remote spam via `execute_luau` on Client datamodel | §5 |

## 2. Device matrix (minimum)
| Device | Why |
| --- | --- |
| Cheap Android phone (baseline) | Performance/memory floor |
| iPhone (notch) | Safe areas, touch |
| Tablet | Aspect ratio |
| Low-end laptop | PC floor |
| Gaming PC | High settings |
| Console (if enabled) | Controller navigation, 10-foot UI |

## 3. Regression checklist (run before every release)
- [ ] Join hub → loading screen → PLAY within 8 s on mid phone
- [ ] New Crew (defaults) → teleport → Lot 13
- [ ] Continue a saved run; Quick Play into an open crew; friend join; party join
- [ ] Tutorial flow for a brand-new profile
- [ ] Dare accept/reroll; Sal buy/reroll/pickup/drop; pawn + buy-back; Bill Box deposit guard; Crew Trailer buttons; kick vote
- [ ] Night: every booth on the current floor (win, loss, push/bank where relevant), Big-stake approval on/off, Rookie limit
- [ ] Every item, including Hype Battery and protection-order rules; Foam Bat hooks
- [ ] Bigsby Walks the Floor; a floor event
- [ ] Closing Count success → summary → next Day; fail → cannon → Keep the Lights On (test product) → Assisted flag
- [ ] Final Choice → Pay; Showdown win; Showdown loss; Endless Night 13
- [ ] Disconnect mid-push; host leaves; everyone quits mid-night (checkpoint restore); server shutdown during a night
- [ ] Purchases: each pass/product in DEV; duplicate-receipt test; subscription status
- [ ] Badges award once; leaderboards submit only for eligible runs
- [ ] Settings persist; Reduce Motion/Flashing work; color patterns visible
- [ ] Localization: switch to another language — no overflow
- [ ] Zero errors in server and client output during the full pass

## 4. Performance checklist (every milestone from M5)
- [ ] MicroProfiler: no recurring script spikes > 8 ms on server; client frame time stable
- [ ] Draw calls and triangles within `11` §5.1 per area
- [ ] Client memory on the baseline phone within target (Performance Stats overlay)
- [ ] Network receive < 50 KB/s average per client during nights
- [ ] Particles within `13` §5 limits

## 5. Exploiter simulation checklist
For each RemoteEvent: fire with wrong types, nil, huge numbers, negative numbers, NaN, very long strings, another player's IDs, from far away, in the wrong state, 50× faster than allowed. **Expected:** no state change, a log entry, kick only for extreme spam. Also verify hidden information never replicates outside documented previews: Pie positions are public before commitment, then only revealed numbers are sent; Ladder Boos, card decks and gem maps follow their own preview rules.

## 6. Definition of done (per item type)
| Work | Done means |
| --- | --- |
| **Booth** | Rules match its file; patterns and anti-abuse implemented; all 4 feel beats; 3 loss gags; tiered wins; difficulty rows; Easy Assist; Showdown target; item and bat hooks; works with touch, mouse/keyboard and controller; unit tests for its logic; 3 playtesters understood it without help |
| **Item** | Matches `06`; server-validated; Hyped value; VFX/SFX; toast; telemetry; tested combos |
| **Screen** | Built from the UI kit; tested at the device matrix; animated; sounds; localized; controller-navigable |
| **3D asset** | Style lock; Roblox specs; reuses textures where possible; performance budget; logged in `art/ASSET_LOG.md` |
| **System/service** | Typed; retries on web calls; failure paths handled; telemetry; tests where logic is pure; no errors in output |
| **Release** | Regression + performance + exploiter checklists green; patch notes written; thumbnails updated if content changed |

## 7. Release checklist
- [ ] All checklists above green in DEV.
- [ ] Version number bumped (`Config/Version.luau`), patch notes in the hub Update Board.
- [ ] Publish DEV → test 15 minutes → publish LIVE.
- [ ] After publish: Creator Hub → restart servers if the update requires it (choose a soft shutdown with the "Midway closing for an update" message).
- [ ] Watch error reports and analytics for 1 hour.

## 8. Bug report template (for players and testers)
```
Title:
Where (hub/Lot 13/floor + booth):
What happened:
What you expected:
Steps to repeat:
Device:
Crew size / Night:
Screenshot or clip:
```

## 9. Friend playtest protocol (weekly)
1. 3–6 players who haven't seen the latest build. Mix ages and devices.
2. Record screens and voice (with permission). Don't explain anything.
3. Watch for: confusion in the first 2 minutes, shared-jar reactions, the cannon reaction, any "this is boring" moment.
4. Ask: best moment? Most confusing moment? Would you play tomorrow?
5. Turn notes into a ranked fix list; fix the top 3 before the next playtest.
