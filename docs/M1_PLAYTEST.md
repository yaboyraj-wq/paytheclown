# M1 playtest — Pay the Clown!

The gray-box prototype is ready for your **three friend-group sessions**. This is
the fun gate: do people laugh, argue about the shared jar, and ask for another night?
M2 waits for your feedback and go-ahead.

## Confirm the sandbox

Use **Pay the Clown [DEV]**, PlaceId **100356893013946**, GameId **10769806964**.
The game refuses to run elsewhere. Code is synced into this Studio place through
Rojo. The booths appear when you press Play; Edit mode can still show the baseplate.
The prototype has no saves. Ending the server resets the run.

## Quick local check: 2–4 players on your computer

These are separate simulated players on one computer. Friends on other computers
need the DEV invitation steps below.

1. Open the confirmed DEV place in Studio. Stop any running test.
2. In **Plugins → Rojo**, confirm the connection to `localhost:34872` is active.
   The server is already running for this work session. If it has stopped, open
   PowerShell in the repository folder and run:

   ```powershell
   & "$env:USERPROFILE\.rokit\bin\rojo.exe" serve dev.project.json
   ```

   Then use **Rojo → Connect**, review the sync, and accept it.
3. For desktop controls, leave **Test → Device Simulator** unchecked.
4. Select **Test → Start Test Session → Server and Clients**, then click the blue
   Play triangle near the upper-left corner.
5. In the new **Server** window, choose **Test → Add Clients**. Repeat until you
   have 2–4 client windows. Allow each window to finish loading. If Studio starts
   clients automatically, count those first.
6. In every client, check that the HUD lists the crew and the same jar. Click
   **READY** in every client. With two players, Night 1's quota is **1,200**;
   with four, it is **620**.
7. Switch between client windows to play different booths. Spend from one and
   check that the other windows update. Let one night finish, then ready up again.
8. Use **Test → End Session** in the server window to finish the local test.

This exact Server/Add Clients workflow was exercised with two clients. Four-player
quota math is unit-tested; a four-client session has not yet been run.

## Play with friends on separate computers — DEV only

You handle these account and publishing steps. No DEV publication or access changes
were performed by the agent.

1. Stop Studio testing, confirm the DEV name/IDs above, and choose **File → Publish
   to Roblox** to update this existing DEV place. Do not choose a different experience.
2. In Studio's **Collaborate** window, search each tester's Roblox username, grant
   **Play** access, and save. Testers do not need Edit access.
   [Roblox collaborator permissions](https://create.roblox.com/docs/projects/collaboration).
3. In Creator Hub, select **Pay the Clown [DEV] → Configure → Settings → Audience →
   Limited → Playtesters → Save Changes**. Current rules require owner eligibility,
   age verification and the content questionnaire. A Private audience currently
   excludes Play-only testers; keep access restricted to the tester list.
   [Roblox publishing and audience instructions](https://create.roblox.com/docs/production/publishing/publish-games-and-places#audience).
4. If Roblox blocks this step, finish the account requirements yourself. Do not
   purchase anything for this test; send me the blocker if needed.
5. Open the [DEV game page](https://www.roblox.com/games/100356893013946) and join first.
   Friends open your Roblox profile and click **Join Experience**. This requires
   your join visibility to allow them and their playtest permission to be saved.
   [Roblox joining instructions](https://en.help.roblox.com/hc/en-us/articles/203314220-How-to-follow-or-join-another-player-in-experiences).
6. Wait until everyone appears in the crew strip before pressing READY. Use 2–4
   players for these sessions. Everyone should see the same jar and night timer.

Roblox's publishing page has an older opening paragraph about Private access;
its dedicated Audience and Private-games sections describe the newer Limited
playtester flow used above. Requirements were checked on 2026-10-07.

## What to do in each session

1. Let friends find their way for the first two minutes. Note where they get stuck.
2. Everyone presses **READY**. At night, walk to a booth pad, press **E**, choose
   a stake and press **GO**. Stakes come from everyone's shared jar.
3. Try all three booths. Reels uses three timed stops. Block Toss uses aim, spin
   and a held/released toss. Pie uses a visible setup preview, then PUSH/BANK.
4. Try a large stake. Friends crews use the documented heads-up-only default:
   the toast warns everyone, but does not give them a binding veto. Approval-on
   behavior was separately verified in the server tests.
5. Play through the full five-minute timer, Final Call, and Closing Count. Watch
   whether clearing Bigsby's quota bar or getting launched creates a reaction.
6. Play another night or use the host's **PLAY AGAIN** after a loss. Run three
   sessions in total; use ordinary controls rather than admin shortcuts.

At Closing Count, check that a successful crew keeps the entire jar and gains
Tokens. The next quota responds to that retained balance. Solo starts at 780;
four players start at 1,900. The fixed Bill and Bill Box are awaiting M6 redesign.

Pie now reveals exactly one tile per pick: the opening pays 1x and additional
safe picks grow the payout. Watch whether PUSH/BANK creates tension. Note whether
the physical Reels' timing and Block Toss's aim feel learnable, whether new runs
feel varied, and whether the shared stake warning arrives in time.

## DEV shortcuts for you

Open Roblox chat with **/**, type a command below, then press Enter. Commands are
intercepted by TextChatService. They work only in this DEV environment: for any
Studio test player, or for your verified owner account in a published DEV server.

| Command | What it does |
| --- | --- |
| `/ptc jar 1000` | Set the shared jar to 1,000 Tickets |
| `/ptc skip` | Depart from Day or finish the current timed phase |
| `/ptc night 4` | Return to Day before Night 4, keeping the jar |
| `/ptc pass` | Force the current night to pass; fill a quota shortfall if needed |
| `/ptc fail` | Force the current night to fail and proceed toward the cannon |

Use pass/fail after the night has started. Night values accept 1–100. Ticket values
must be whole numbers between 0 and 9,999,999,999. All money changes enter the audit log.

## Send back these notes

- Best moment, most confusing moment, and whether they wanted another night.
- Crew size, device, booth/night, and steps for any bug. A screenshot or clip helps.
- Whether Pie's new one-pick pacing and Reels' visual timing are fun before M2.

Record voice or screens only with the players' permission. Final art, audio,
shops, items, saving and endings belong to later milestones; judge the loop now.
