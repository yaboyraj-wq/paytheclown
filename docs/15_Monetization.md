# 15 — Monetization (complete)

> Principle: **sell looks, convenience, celebration and status — never outcomes.** In a game where friends share one jar, a bought win cheapens everyone's effort, and fair games keep players longer (which the Roblox algorithm rewards). Spend design is built in from the first version because Roblox's recommendation system uses spend signals (7-day spend days per user and 7-day Robux spent per user) alongside retention and co-play.

## 1. Hard rules
1. Robux never buys Tickets, Tokens, items, booth results, quota changes, or anything that changes a booth outcome.
2. The only gameplay-adjacent purchase is **Keep the Lights On** (once per run; run marked Assisted; off leaderboards).
3. No paid random items (no loot boxes, no gacha) for Robux. The Surprise Crate is Tokens-only and shows its odds.
4. No fake countdown timers, no "only 2 left!" lies, no pressure popups during nights, no guilt messages.
5. All prices are fetched at runtime (Managed Pricing can change them by region and through price tests). Never hard-code Robux prices in UI.
6. Every purchase is processed server-side, idempotently, and logged.

## 2. Revenue streams (all of them)

| Stream | What | Status for launch |
| --- | --- | --- |
| Developer products | Repeatable purchases (Star packs, Crew Treats, Keep the Lights On, direct cosmetic buys) | Launch |
| Game passes | One-time purchases (VIP, 2x Stars, Starter Pack, Carnival Pass per season) | Launch |
| Subscription | Carnival Club, monthly | Launch (if eligible) |
| Private servers | Hub private servers | Launch |
| Creator Rewards | Automatic Robux from Roblox for engaging Active Spenders | Automatic (design for it) |
| Rewarded video ads | Opt-in ads for 13+ users for small Star rewards | When eligible |
| Avatar items sold in-experience | Our hats/accessories as real Roblox avatar items | Later (needs UGC eligibility) |
| Brand deals / sponsorships | Event collaborations | Later, after scale |

### 2.1 Creator Rewards (free money for good design)
Roblox's Creator Rewards program (official docs, 2026):
- **Daily Engagement Rewards:** Roblox pays creators **5 Robux** for each eligible Active Spender who spends **at least 10 minutes** in the experience in a day (it must be one of their first qualifying experiences that day; read the docs for exact rules).
- **Audience Expansion Rewards:** a **35% revenue share** on a new or reactivated user's first $100 of qualifying purchases anywhere on Roblox in their first 60 days, if they joined through your share link, direct link, or by searching your game's name, played 10+ minutes, and the game keeps 100+ DAU; requires an ID-verified account in good standing and a valid DevEx account.
- **What this means for design:** sessions of 10+ minutes matter (our nights are ~7 minutes, so most players pass 10 minutes in their second night); always market with the game's **share link**; never encourage alt accounts (prohibited).

### 2.2 Rewarded video ads
- Roblox's Rewarded Video ads API is available to eligible creators (eligibility shows in Game Settings). Only users **13+** see ads; the API reports whether an ad is available.
- Our placement: in the hub, a "Watch an ad for 15 Stars" button (max 3 per day), and on the night summary "Double tonight's Stars" (once per day). Never gate progress, never in Lot 13 or during nights, never auto-play.
- If unavailable for a user, the buttons don't appear.

### 2.3 DevEx (cashing out)
- You keep **70%** of Robux spent on your passes and products (Roblox keeps 30%).
- DevEx converts earned Robux to cash. Rates per Roblox docs as of mid-2026: **$0.0038 per Robux** standard, with a higher **$0.0054** rate for eligible purchases by U.S. players 18+; minimum **30,000 earned Robux** to cash out. Check the current DevEx page before planning.
- Requires ID verification, age 13+ (18+ or parental permission per DevEx terms), and a DevEx account.

## 3. Product catalog (starting prices; Managed Pricing may adjust)

### 3.1 Game passes (one-time)
| ID | Name | Price (Robux) | Grants |
| --- | --- | --- | --- |
| `GP_STARTER` | Starter Pack | 99 | Ringmaster Top Hat + Golden Jar skin + 1,000 Stars. Offered once after a player's first run ends; always in the store. |
| `GP_VIP` | VIP Pass | 299 | Gold name tag + VIP icon, VIP Balcony access, +10% earned Stars, 6 save slots (instead of 3), exclusive "Golden Ticket Jacket" costume, VIP-only emote |
| `GP_2X_STARS` | 2x Stars | 399 | Doubles earned Stars (not purchased) |
| `GP_EMOTE_PACK` | Showtime Emote Pack | 149 | 5 exclusive emotes |
| `GP_PASS_S1` | Carnival Pass — Season 1 | 399 | Premium track for Season 1 (new pass each season) |

### 3.2 Developer products (repeatable)
| ID | Name | Price | Grants |
| --- | --- | --- | --- |
| `DP_STARS_S` | Handful of Stars | 99 | 500 Stars |
| `DP_STARS_M` | Bag of Stars | 199 | 1,100 Stars |
| `DP_STARS_L` | Bucket of Stars | 449 | 2,600 Stars |
| `DP_STARS_XL` | Wagon of Stars | 899 | 5,500 Stars |
| `DP_STARS_XXL` | Big Top of Stars | 1,799 | 12,000 Stars |
| `DP_TREAT_CANDY` | Crew Treat: Cotton Candy Rain | 25 | Visual treat over the whole crew + every other crew member gets +10 Stars; buyer's name shown |
| `DP_TREAT_FIREWORKS` | Crew Treat: Fireworks Show | 49 | Fireworks over the floor + every other crew member gets +25 Stars |
| `DP_TREAT_CONFETTI` | Crew Treat: Confetti Cannon | 75 | Giant confetti cannon + every other member +40 Stars + a crew photo moment |
| `DP_KEEP_LIGHTS_ON` | Keep the Lights On | 49 | After a missed quota: waive tonight's quota once per run (run becomes Assisted) |
| `DP_COSMETIC_*` | Direct-buy cosmetics | 49–399 | Specific cosmetic (also buyable with Stars) — saved permanently in the profile |

Crew Treats can be bought only during a Day or after a night summary (never mid-night), max 3 per player per Day.

### 3.3 Subscription
| ID | Name | Price | Grants |
| --- | --- | --- | --- |
| `SUB_CLUB` | Carnival Club | $4.99/month (closest Roblox subscription price tier) | +100 Stars every day you log in, one exclusive costume each month (kept forever), Club name tag color, 1 streak saver per month, 1 extra Daily Task reroll per day |

Per Roblox's Subscriptions docs (checked mid-2026), creators earn 70% of the first month's price and 100% of later months (after platform/store fees as described there). Check the docs for current eligibility and payout rules before launch.

### 3.4 Private servers
- Hub private servers: **100 Robux/month** (price may be regionalized automatically).

## 4. Where offers appear (merchandising rules)
| Moment | Offer | Rule |
| --- | --- | --- |
| Hub, always | Store button | Never auto-opens |
| After first run ends | Starter Pack card | Once per player, dismissible forever |
| Cannon summary | Keep the Lights On | 10-second card; only once per run |
| Thrift Tent | Featured rack, direct-buy prices next to Star prices | Organic |
| Night summary | "Double tonight's Stars" (rewarded ad, 13+) | Once per day |
| Level up every 10 levels | Nothing (pure reward) | No upsell on celebrations |

Max **one** non-store offer popup per session besides Keep the Lights On.

## 5. Implementation rules (server)

### 5.1 Developer products: `MarketplaceService.ProcessReceipt`
1. Set exactly one `ProcessReceipt` callback (in `MonetizationService`).
2. Check the receipt's `PurchaseId` against a `Receipts` DataStore (or the player's profile receipt list). If already granted → return `PurchaseGranted`.
3. If the player is not in the server → return `NotProcessedYet` (Roblox will retry).
4. Grant the product into the player's profile (session-locked profile; see `17`).
5. **Save** the profile including the `PurchaseId`. Only after the save succeeds → return `PurchaseGranted`. If anything fails → `NotProcessedYet`.
6. Log an economy event (source: `DEV_PRODUCT`).

### 5.2 Game passes
- On join, check ownership with `UserOwnsGamePassAsync` (cache, retry on failure).
- Listen to `PromptGamePassPurchaseFinished` to grant immediately when bought in-game.
- Never trust the client's claim of ownership.

### 5.3 Subscriptions
- Check `GetUserSubscriptionStatusAsync` on join and on `UserSubscriptionStatusChanged`; prompt with `PromptSubscriptionPurchase`. Grant daily benefits on login if active.

### 5.4 Prices
- Display prices via `GetProductInfoAsync` / `GetDeveloperProductsAsync` (they return regional prices when Managed Pricing is on). Cache 5 minutes.
- Opt products into **Managed Pricing** (price optimization + regional pricing) once the game has enough traffic for tests.

### 5.5 Policy checks
- Use `PolicyService:GetPolicyInfoForPlayerAsync` and respect: `ArePaidRandomItemsRestricted` (we have none, but keep the check for future features), `AllowedExternalLinkReferences` (only show social handles allowed for that player), `IsPaidItemTradingAllowed` (we have no trading), and any ad eligibility fields.

## 6. Revenue expectations (honest math)

How Robux becomes dollars for you, roughly: a player pays about $0.0125 per Robux; you keep 70% of Robux; DevEx pays about $0.0038 per Robux. So you receive roughly **20–21% of what players spend** (more with the 18+ U.S. rate).

Benchmarks (GameAnalytics 2025 Roblox report, games with 19–24 minute sessions): ARPPU per day median ≈ $1.71, top quartile ≈ $2.61. Paying conversion on Roblox games is commonly in the low single-digit percent of daily players (assumption — measure your own).

| DAU | Payers (2%) | Player spend/day (× $1.71) | Your cash/day (~21%) | Per year |
| --- | --- | --- | --- | --- |
| 1,000 | 20 | $34 | ≈ $7 | ≈ $2,600 |
| 10,000 | 200 | $342 | ≈ $72 | ≈ $26,000 |
| 100,000 | 2,000 | $3,420 | ≈ $720 | ≈ $260,000 |

Plus Creator Rewards (for example, if 20% of DAU are qualifying Active Spenders: 10,000 DAU × 20% × 5 Robux = 10,000 Robux/day ≈ $38/day at $0.0038). These are rough planning numbers, not promises. Retention and DAU matter far more than prices.

## 7. Monetization analytics (see `19`)
Track: store opens, item previews, prompt shown/purchased/cancelled per product, first-purchase funnel (which product), payer conversion by cohort, ARPDAU, ARPPU, 7-day spend days per user, refunds/chargebacks (watch for abuse), rewarded-ad views and completions.
