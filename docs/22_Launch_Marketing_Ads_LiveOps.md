# 22 — Publishing, Launch, Ads, Marketing and Live Ops

> From "it works in Studio" to "it makes money every week." Steps marked **(You)** need the human owner; the AI agent can't do them (identity, payments, legal acceptance).

## 1. One-time account setup (You)
1. Create a **Roblox Community (group)** to own the game (e.g., "Lot 13 Studios"). Group ownership keeps revenue and permissions clean if collaborators join later.
2. On your account: **age check**, **government ID verification** (you're 18+), **2-Step Verification**.
3. Decide how to meet the all-ages requirement: keep **Roblox Plus/Premium for 2 consecutive months** before publishing to all ages, **or** pay the **1,000 Robux refundable publishing fee** (`20` §2.2).
4. Set up **DevEx** eligibility (ID-verified, DevEx account) — also needed for Audience Expansion rewards.
5. Create two experiences under the group: **DEV** (private) and **LIVE**.

## 2. Pre-launch checklist (agent + You)
- [ ] All Phase gates passed (`23`), definition of done for every shipped feature (`24`).
- [ ] Maturity & Compliance Questionnaire completed honestly → expect **Mild** (You).
- [ ] Game name, description, genre, devices (PC, phone, tablet, console if tested) set (You, agent drafts text).
- [ ] Icon + 3–5 thumbnails uploaded; thumbnail personalization started (You uploads; agent prepares files).
- [ ] Game passes, developer products, subscription created in Creator Hub; IDs put in `Config/Environment` LIVE (You creates; agent wires).
- [ ] Badges created and IDs wired.
- [ ] Private servers enabled with price.
- [ ] Managed Pricing opt-in decision logged.
- [ ] Social links set on the game page (only allowed platforms; respect age-gating).
- [ ] Analytics funnels verified in DEV.
- [ ] Load test: 6-player crews × several servers in DEV with friends.
- [ ] `BindToClose` save tested (shut down servers in DEV).
- [ ] Right to Erasure procedure documented.

## 3. Launch sequence
### Phase A — Closed playtest (Limited → Playtesters)
- 2–3 weeks. Friends, classmates, small Discord. Goal: fun and bugs. Weekly builds.
- Gate: new testers finish Night 1 without help ≥ 90%; friend groups ask to play again.

### Phase B — Public soft launch (16+ trial phase)
- Set Audience → **Public**. Under the 2026 framework the game is visible only to age-checked 16+ users until it passes evaluation (250 unique plays by highly engaged age-checked users within 60 days).
- Drive the first players: your own network, short-form video, a small ad budget (§4) targeting older audiences.
- Gate to "full launch push": D1 ≥ 13.5%, avg session ≥ 19 min, crash rate < 0.5%. If not met, fix before spending more.

### Phase C — All-ages eligibility
- After evaluation passes (or via the expedited review fee if you plan a timed launch), the game reaches Kids and Select accounts. This is when organic recommendations can really grow.

### Phase D — Growth and live ops (§5–7)

## 4. Paid ads on Roblox (Ads Manager)
Ads Manager (Creator Hub → Ads) runs:
- **Sponsored experiences** on the Home page,
- **Search ads** on keywords (e.g., "carnival", "co-op", "minigames", "with friends"),
- **Immersive ads** (portal ads inside other experiences),
- bids are **CPM** (cost per thousand impressions) with daily budgets and placement/brand-suitability settings.

Plan:
1. **Test budget** in Phase B: small daily budget for 7 days on sponsored experiences + search ads, 2–3 creatives (use thumbnail concepts). Measure cost per play and, more importantly, **D1 retention of ad-acquired players**.
2. **Rule:** don't scale ads until organic metrics hit the gates. Remember: players acquired from ads aren't counted in the ranking stage of Recommended for You — only their *retention* afterward helps.
3. Scale gradually (+25% budget per week) while D1 of ad cohorts stays near organic.
4. Refresh creatives every update. Pause ads that drop below your D1 target.
5. Optional: the Ads API (Open Cloud) can manage campaigns programmatically later.

## 5. Organic marketing (free and powerful)
| Channel | What to post | Cadence |
| --- | --- | --- |
| YouTube Shorts / TikTok / Instagram Reels | Cannon launches, last-second quota saves, "friend pushes Rocket Ride to 12x" clips, Foam Bat bonk tricks | 3–5 per week |
| Roblox Community (group) | Update announcements, codes, polls | Every update |
| Discord (13+, per Discord's terms) | Patch notes, bug reports, fan art, events | Ongoing |
| X / social | Short clips, codes | 2–3 per week |
| Content creators | Invite Roblox YouTubers/TikTokers to a private server session with an exclusive costume code for their viewers; Roblox's **Video Stars** program members can earn Creator Rewards for bringing players | After soft launch metrics are good |

- Always use the game's **share link** (it powers Audience Expansion rewards).
- **Codes:** give Stars or cosmetics only (never Tickets/Tokens). Example: launch code "PAYUP" (500 Stars). One code per update; announce in the Community and Discord.
- In-game "Cannon Cam" and crew photos encourage players to share their own clips.

## 6. Update cadence (live ops)
| Period | Cadence | Content |
| --- | --- | --- |
| Launch weeks 1–8 | **Weekly** update | Fixes, balance, 1 small feature or cosmetic drop, new thumbnail when relevant |
| Every 2 weeks | Content update | New cosmetics, new dares, a booth variant, a weekend event |
| Every ~6 weeks | Season | New Carnival Pass, a seasonal re-skin or new floor/booth, new music |
| Every quarter | Major update | New booth(s), new floor or mode (e.g., a new "Act V: The Night Market"), new items |

In-game **Update Board** in the hub shows the latest patch notes; the game title bracket tag announces updates ("[NEW FLOOR]") — only true claims.

## 7. Live-ops calendar template (adjust to launch date)
| When | Event | Content |
| --- | --- | --- |
| Launch week | Grand Opening | Launch code, opening confetti, free "Opening Night" hat for first-week players |
| Every weekend | Double Stars Weekend (some weekends) | ×2 earned Stars |
| October | Haunted Midway | Halloween re-skin, Boo Ladder variant, pumpkin jar skin, spooky-silly costumes |
| December | Frostbite Fair | Snow re-skin, Snowball Hoops, winter costumes, gift calendar |
| Spring | Sir Waddles Day | Duck everything, Duck Derby bonus Stars |
| Summer | Summer Fireworks | Fireworks finale, new cannon styles |
| Anytime | "Bigsby's Big Night" live event | Developer hosts a scheduled event: Bigsby appears in all hubs, announces a 1-hour crew challenge with a global progress bar (e.g., crews worldwide win 10 million Tickets) unlocking a free cosmetic for everyone |

## 8. Community management
- Clear rules, moderators (trusted friends) with admin ranks, bug report template, response within 48 hours.
- Never promise dates you can't hit.
- Celebrate players: "Crew of the Week" from the leaderboard on social media (with permission; display names only).

## 9. Scaling up later (after proven metrics)
- Hire or partner selectively for specific polish (e.g., a pro composer or animator) if revenue allows.
- Consider publishers/studios that invest in proven Roblox games (only after strong retention data).
- Sell our hats as real Roblox avatar items (UGC program eligibility required).
