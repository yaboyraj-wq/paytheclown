# 19 — Analytics and KPIs

> You can't improve what you don't measure. Analytics are built in from the first playable version, not added after launch.

## 1. Tools
- **Roblox Creator Analytics** (Creator Hub): retention (D1, D7, D30), engagement (session length, sessions per user), monetization (ARPDAU, payer conversion), acquisition and the **Home Recommendations** dashboard (shows the signals Roblox's algorithm uses for your game), performance, errors.
- **AnalyticsService** (in-game), wrapped by `TelemetryService`:
  - `LogOnboardingFunnelStepEvent` — first-time user funnel.
  - `LogFunnelStepEvent` — recurring funnels (each run, each shop visit).
  - `LogEconomyEvent` — every source and sink of Stars (and Tokens/Tickets as custom resources).
  - `LogCustomEvent` — gameplay events.
  - Check the current AnalyticsService API and limits in Roblox docs before building.

## 2. North-star and guardrail metrics

| Metric | Target at launch | Why |
| --- | --- | --- |
| D1 retention | ≥ 13.5% | Top quarter of 19–24 min session games (GameAnalytics 2025) |
| D7 retention | ≥ 2.8% | Same |
| D30 retention | ≥ 0.8% | Same tier, healthy long tail |
| Avg session length | ≥ 19 min | "Hit" tier |
| Sessions per DAU | ≥ 2.0 | Hit-tier median |
| % of sessions in crews with 2+ players | ≥ 50% | Co-play signal |
| New user → first crew launch within 60 s | ≥ 90% | Onboarding |
| New user → first night survived | ≥ 85% | Night 1 must be fun and winnable |
| Payer conversion (daily) | 1–3% | Assumption, measure |
| ARPPU per day | ≥ $1.7 (median of tier) | GameAnalytics 2025 |
| Crash/error rate | < 0.5% of sessions | Quality |
| Teleport failure rate | < 1% | Quality |

## 3. Onboarding funnel (first session; `LogOnboardingFunnelStepEvent`)
1. `joined_hub`
2. `loading_done`
3. `play_pressed`
4. `crew_launched`
5. `arrived_lot13`
6. `tutorial_item_received`
7. `departed_night1`
8. `first_booth_played`
9. `first_win`
10. `night1_result` (success/fail)
11. `night2_started`
12. `run_ended_or_left`

Look for the biggest drop between steps and fix that step first.

## 4. Recurring funnels (`LogFunnelStepEvent`)
- **Run funnel:** run_created → night1 … night12 → final_choice → ending (shows where crews die; feeds balance).
- **Shop funnel:** store_opened → item_previewed → purchase_prompted → purchase_completed.
- **Sal's funnel:** shop_opened → item_bought → item_picked_up → item_used.

## 5. Economy events (`LogEconomyEvent`)
- Stars: sources (`NIGHT`, `WIN`, `DARE`, `ENDING`, `DAILY_CALENDAR`, `DAILY_TASK`, `PASS`, `AD`, `PURCHASE`, `CODE`, `TREAT`) and sinks (`COSMETIC_<category>`).
- Tokens (custom resource): sources (`NIGHT`, `SURPLUS`, `DARE`, `PAWN`, `MAGNET`, `START`), sinks (`ITEM_<id>`, `SHOP_REROLL`, `DARE_REROLL`, `BUYBACK`).
- Tickets (custom resource, aggregated per night to stay within limits): `BOOTH_PAYOUT`, `STAKE`, `QUOTA`, `BILL_DEPOSIT`, `PAWN_POPPER`, `TICKET_RAIN`, `REWIND`.

## 6. Custom gameplay events (sampled if volume is high)
`booth_play_resolved` (booth, floor, night, stake bucket, multiplier, crew size, items) · `booth_push` / `booth_bank` (step) · `item_used` (item, hyped) · `big_stake_toast` (approved/blocked) · `bat_bonk` (target type) · `pawn` (piece) · `bill_deposit` (bucket) · `night_result` (night, success, jar÷quota ratio) · `cannon` · `keep_lights_on_offered/bought` · `final_choice` (pay/showdown) · `showdown_result` · `ending` · `crew_kick_vote` · `afk_marked` · `quickplay_wait_seconds`.

## 7. Weekly review ritual (the user + agent, every week after soft launch)
1. Check retention (D1/D7) vs targets and vs last week.
2. Check the Home Recommendations dashboard signals.
3. Find the biggest onboarding funnel drop → one fix.
4. Check run funnel: which night kills most crews → compare with simulator targets (`04` §11.1) → tune.
5. Check booth returns per tier → any booth above its expert cap or below 0.9 for average players → tune.
6. Check store funnel → one merchandising improvement.
7. Write findings and changes in `27_Decisions_Log.md`.

## 8. Experiments
- Thumbnails: Roblox **thumbnail personalization** (upload 3–5; it shows the best one per user).
- Prices: **Managed Pricing** price tests.
- Gameplay: feature flags with a deterministic user bucket (`hash(userId) % 100 < X`) for small tests (e.g., Night 1 quota 400 vs 300). Only one gameplay experiment at a time; log the bucket in events.
