# 21 — What Makes a Roblox Game Succeed (research summary and design consequences)

> Research done October 2026. Each finding ends with what we do about it, so success factors are built in from the start, not bolted on.

## 1. How Roblox decides who sees your game
- Roblox's **Recommended For You** algorithm now measures retention over **day 1, days 2–7 and days 8–28** (expanded from a 7-day view in June 2026). Roblox says games that create long-term value "through retention, co-play, and spend" get more opportunity, and it shares the signals and their weights in the Creator Analytics **Home Recommendations** dashboard. (Roblox newsroom, June 2026)
- Roblox found that overweighting short-term engagement let games with flashy thumbnails but little depth displace better games, which is why long-term signals now matter more.
- Roblox focuses on **per-user** engagement, not totals, and does **not** count users acquired from ads, curation, friends, search or social media in the ranking stage of Recommended for You (Roblox Discovery docs). Ads buy players; only *retained* players buy recommendations.
- Two spend signals feed recommendations: **7-day spend days per user** and **7-day Robux spent per user** (GameAnalytics citing Roblox).

**We do:** design for 28-day retention (saves, daily systems, seasons), co-play (shared jar, crews, friend joins), and repeat small purchases (Crew Treats, Star packs, seasonal pass) rather than one-time big purchases only.

## 2. Benchmarks: session length is a ladder (GameAnalytics 2025 Roblox report)
| Session length tier | Median D1 | Top-10% D1 | Median sessions/day |
| --- | --- | --- | --- |
| 0–3 min | 4.3% | 9.3% | 1.3 |
| 4–6 min | 6.2% | 11.7% | 1.0 |
| 7–12 min | 7.9% | 11.6% | 1.0 |
| 13–18 min | 10.2% | 15.0% | 1.0 |
| 19–24 min | 11.5% | 18.2% | 1.8 |
| 25+ min | 10.8% | 18.9% | 2.2 |

- Games under ~7 minutes struggle; "hits emerge at 19+ minutes."
- Players increasingly return several times a day; top players went from 4.5 to 6.0 sessions/day (P90) in a year, driven by re-entry design, idle progress and Roblox's 2025 push for friend co-play.
- Spending is top-heavy: median payers spend under $1/day; the top 5% spend $20+/day.
- About half of players use both PC and mobile; mobile-only and PC-only players are both large groups; console is ~2%.

**We do:** a run naturally lasts 30–80 minutes (≥ 19-minute sessions); 5-minute nights make quick re-entries satisfying; daily systems create same-day returns; premium cosmetics and a season pass serve high spenders while 25–99 Robux items convert first-time payers; every screen works on phone and PC.

## 3. What recent mega-hits had in common
- **Grow a Garden** (2025) reached ~22 million concurrent players. It started small (made in days by a young developer), then grew through very frequent updates (about every 5–7 days during growth), seasonal events with limited-time content, social sharing and content creators, and cross-game "admin" events. (RoLearn analysis; news coverage)
- **Steal a Brainrot** rode a meme trend to ~25 million CCU, then fell over 99% from peak as the trend faded, staying alive through relentless updates. Analysts describe two layers of success on Roblox: sustainable social worlds with deep retention, and viral trend games with high churn. (RoWatcher)
- "Virality gets you to the peak; retention determines where you land after it." (RoLearn)
- 13 of the top 20 most-visited games turned over in about 9 months (Dubit) — new games can break through if engagement is strong.
- Our own earlier research: trend-only games kept as little as 1–11% of their peak; depth games (e.g., Secure the Airport, which added upgrades and bosses) kept ~71%.

**We do:** combine a viral hook (the shared jar, screaming friends, the cannon — highly clippable) with depth (17 booths, items, 12-night runs, Endless, seasons). Plan an update cadence from day one (`22`).

## 4. The "done outside Roblox before and worked" check
- Gamble With Your Friends sold over 1 million copies in under two weeks and 2 million in about five weeks, peaking at ~42,800 concurrent players on Steam. Its audience includes many kids who can't buy an $8 PC game — a classic gap a free Roblox version can fill.
- BUCKSHOT (a Roblox adaptation of Buckshot Roulette) shows tense "risk it with friends" games last on Roblox.
- The original's own reviews say it gets more fun after the first hour as power-ups and cosmetics appear → we surface items and cosmetics early.

## 5. First minutes decide everything
- Casual players leave within ~2 minutes if they don't find the fun (GameAnalytics). The 2025 report's checklist starts with "Win the first two minutes."

**We do:** crew launched in under 60 s, a free tutorial item, an Easy Assist first play that almost always wins, no text walls (`03` §11, `07` §12).

## 6. Store page and thumbnails
- Thumbnail personalization (upload 2+ thumbnails) raised the qualified play-through rate by about 8.5% on average in Roblox's tests. Thumbnails must show the real experience. Recommended size 1920×1080; icon square 512×512+; test at small sizes (~150 px tiles).
- Community analysis suggests a single high-contrast subject with a visible character face beats busy scenes.

**We do:** 3–5 thumbnails rotated with each update, an icon built around Bigsby's face (`11` §8–9).

## 7. Monetization levers Roblox now provides
- **Creator Rewards:** 5 Robux per eligible Active Spender who plays 10+ minutes in a day, plus a 35% revenue share on new/reactivated users you bring in (share links, direct links, name search).
- **Managed Pricing** (price optimization + regional pricing; regional prices range 30–100% of default). Regional pricing raised paying users substantially in early tests (e.g., +26% Brazil, +52% Philippines).
- **Rewarded video ads** for 13+ users, opt-in.
- Subscriptions, passes, products, private servers.

**We do:** all of the above (`15`), with prices fetched dynamically.

## 8. Platform safety changes that shape design
- Age checks required to chat (since January 2026) → quick-chat wheel for everyone.
- Kids/Select publishing framework → design for Minimal/Mild, plan for a 16+ trial phase (`20`).

## 9. AI-assisted development is normal now
- Roblox reports 44% of its top 1,000 creators use Roblox Assistant or third-party AI tools via MCP; Studio has a built-in MCP server with tools for scripts, Luau execution, playtesting, input simulation, mesh/material/procedural model generation and asset search.

**We do:** build with an AI coding agent connected to Studio and Blender (see `SETUP_CONNECTIONS.md`), with the human acting as director and playtester.

## 10. The success checklist (built in from day one)
- [ ] Crew in < 60 s, first win in < 3 minutes.
- [ ] Shared stakes visible to everyone; social moments every minute.
- [ ] Runs that naturally last 19+ minutes; 5-minute nights for re-entry.
- [ ] Daily calendar, daily tasks, featured rack, season pass, weekly leaderboards.
- [ ] Saves that bring friend groups back.
- [ ] Clippable signature moment (the Big Cannon) and a share link everywhere.
- [ ] Cosmetic-only monetization with cheap first purchases and premium options.
- [ ] Mobile-first UI, quick-chat, performance on cheap phones.
- [ ] Analytics funnels from the first playable build.
- [ ] Update cadence planned before launch.

## Sources
- Roblox: Optimizing Discovery (June 2026) — https://about.roblox.com/newsroom/2026/06/optimizing-discovery-great-games-reach-millions-players-roblox
- Roblox docs: Discovery — https://create.roblox.com/docs/en-us/discovery
- GameAnalytics: 2025 Roblox Benchmark Report — https://www.gameanalytics.com/reports/2025-roblox-report
- RoLearn: Grow a Garden CCU record analysis — https://rolearn.dev/insights/grow-a-garden-ccu-record-analysis
- RoWatcher: Is the brainrot trend dying? — https://rowatcher.com/news/is-the-brainrot-trend-dying-what-ccu-data-from-three-top-games-reveals
- Dubit: How we build hit Roblox games — https://dubit.io/blog/how-we-build-hit-roblox-games
- Roblox docs: Thumbnails — https://create.roblox.com/docs/production/publishing/thumbnails
- Roblox docs: Creator Rewards — https://create.roblox.com/docs/creator-rewards
- Roblox docs: Managed pricing — https://create.roblox.com/docs/production/monetization/managed-pricing
- Roblox newsroom: Regional pricing launch — https://about.roblox.com/newsroom/2025/04/roblox-launches-regional-pricing-for-in-experience-items
- Roblox DevForum: More creators can use Rewarded Video ads — https://devforum.roblox.com/t/more-creators-can-now-use-rewarded-video-ads/3838678
- Roblox: Studio is going agentic (April 2026) — https://about.roblox.com/newsroom/2026/04/roblox-studio-going-agentic
- Roblox docs: Studio MCP server — https://create.roblox.com/docs/en-us/studio/mcp
- Roblox docs: Kids and Select — https://create.roblox.com/docs/en-us/production/publishing/kids-and-select
- Roblox DevForum: Age check requirement to chat — https://devforum.roblox.com/t/age-check-requirement-to-chat-now-live-globally/4226101
- Gamereactor: GWYF sells a million copies — https://www.gamereactor.eu/the-latest-friendslop-hit-is-here-as-gamble-with-your-friends-sells-a-million-copies-in-less-than-two-weeks-1716843/
- WN Hub: GWYF passes 2 million — https://wnhub.io/news/finance/item-51060
