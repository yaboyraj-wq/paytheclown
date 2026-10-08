# 20 — Roblox Compliance, Safety and Publishing Requirements

> These rules come from Roblox's Creator Hub documentation as checked in October 2026. Roblox changes policies often: **re-check every linked page before launch** and log any change in `27_Decisions_Log.md`.

## 1. Who can see the game (2026 framework)

Roblox now has three account tiers:

| Account type | Who | Content ratings they can play | Chat |
| --- | --- | --- | --- |
| Roblox Kids | Ages 5–8 | Minimal, Mild | Off by default; parent can enable after age check |
| Roblox Select | Ages 9–15 (self-declared 9+ until age-checked) | Minimal, Mild, Moderate | Off for self-declared; introduced gradually after age check |
| Roblox | Age-checked 16+ | All except Restricted (18+) | On by default where available |

Our target rating is **Minimal or Mild** so the game can reach all three tiers.

## 2. Publishing requirements (what the owner must do)

### 2.1 To publish publicly to 16+ (first step)
- Account in good standing and at least 2 days old.
- Complete an **age check** (facial age estimation or government ID).
- Complete the **Maturity & Compliance Questionnaire** (Creator Hub → Audience → Maturity & Compliance).

### 2.2 To reach all ages, including Kids and Select (our main audience)
1. Account verified: **government ID if 18+** (the owner is 20), facial age estimation if under 18.
2. **2-Step Verification** enabled on the account.
3. One of: an active **Roblox Plus or Premium subscription held for 2 consecutive months**, **or** a one-time **refundable publishing fee of 1,000 Robux** per game (refunded per Roblox's rules if the game stays in good standing; not refunded if the game is permanently moderated).
4. **Evaluation process:**
   - **Trial phase:** the game is first available only to **age-checked users 16+**.
   - Roblox analyzes engagement from "highly engaged" players (account age, play history, platform spend) to make sure it isn't bots.
   - Safety review of the game's moderation reports and gameplay.
   - **Threshold:** **250 unique plays by highly engaged age-checked users within 60 days** → eligible for Kids and Select.
   - Track progress in Creator Hub → Audience Reach dashboard.
5. Optional **expedited review**: a refundable **50,000 Robux** fee gives a faster safety review (about 48 hours; refundable after 90 days per Roblox's conditions).

**Design consequence:** the first players will be 16+. The launch version must be fun for teens and adults (Hard mode, leaderboards, banter), and the soft launch should target a 16+ audience (`22`).

### 2.3 Private testing
- "Private" games are restricted to people with **Edit** permission. To let playtesters in, meet the public requirements and set **Audience → Limited → Playtesters** (Limited games aren't discoverable publicly).
- Since March 2026, collaborating in Team Create requires an age check.

## 3. Maturity & Compliance Questionnaire — how we answer (honestly)
Answer every question accurately for what players can actually encounter. Expected answers for our design (verify against the live questionnaire wording):

| Category | Our content | Likely answer |
| --- | --- | --- |
| Violence | Cartoon slapstick: bonks, pies, cannon launch into a lake; no injury, no weapons, no blood | Mild/cartoon, infrequent → aim for Minimal or Mild |
| Blood | None | None |
| Fear | Funhouse floor: silly ghost-clown pop-ups, spooky-silly music | Mild fear |
| Crude humor | Whoopee cushions, raspberry sounds | Mild crude humor |
| Gambling | **No games of chance.** All booths are skill games; Tickets are earned in-game and can't be bought or cashed out; no casino imagery | Answer accurately per the questionnaire's definitions; do not depict playable gambling |
| Romance, alcohol, drugs, profanity | None (Fizz Pop is soda) | None |
| Social features | Text chat via TextChatService, optional voice, quick-chat | Disclose |
| Paid random items | None for Robux | None |

Expected label: **Mild**. If a feature would push the rating to Moderate, change the feature.

## 4. Chat and communication rules
- **All player-to-player text must go through `TextChatService`** (Roblox requirement for age-based chat). Don't build custom text chat.
- Since January 2026, users must complete an **age check to chat**; chat is age-grouped. Many younger players can't chat at all → our **quick-chat wheel** with predefined strings and icons is essential (`10` §5.3).
- Never display unfiltered user text. Crew names come from word lists; no free-text naming.
- Use Roblox's matchmaking signals that account for chat eligibility where available (Roblox added a Text Chat matchmaking signal to default matchmaking).

## 5. External links and socials
- Roblox requires age checks to access social media links. In-game, only show social handles allowed by `PolicyService` (`AllowedExternalLinkReferences`) for that player; otherwise hide them. Never show clickable external links in-game.

## 6. Monetization compliance
- No paid random items (and check `ArePaidRandomItemsRestricted` for any future feature).
- No misleading offers, fake scarcity, or pressure tactics.
- Prices from `MarketplaceService` (regional).
- Rewarded ads only through Roblox's Rewarded Video API; only 13+ users see ads.
- Ads we run must follow Roblox's Advertising Standards.

## 7. Thumbnails, icon, name and description
- Thumbnails must represent the actual experience (no fake content, no content from other IP).
- Name: keep it stable; at most one or two emojis; no keyword spam. Recommended listing: **"🎪 Pay the Clown! [Carnival With Friends]"** (bracket tag can change with updates, e.g., "[NEW FLOOR]").
- Description: first sentence summarizes the game; include honest keywords (carnival, co-op, friends, minigames, skill games, party game); no spam, no other games' names.

## 8. Intellectual property
- Everything original (see `25`). No names, art, audio, logos, UI or code from Gamble With Your Friends or any other game/brand.
- AI-generated assets must not imitate protected characters, brands, or artists' specific works.
- Keep `art/ASSET_LOG.md` (how each asset was made and the human creative choices) for ownership records.

## 9. Data privacy
- Collect only what's needed (`17` §8). Honor Roblox Right to Erasure requests.

## 10. Safety features in our design (summary)
- Quick-chat for everyone; Honk mode never blocks reporting.
- Bonk opt-out; kick votes in public crews; Rookie stake limits; big-stake approval in public crews.
- No real gambling, no alcohol, no blood, no horror.
- Admin tools restricted to group ranks; bans via Roblox's Ban API with reasons.
