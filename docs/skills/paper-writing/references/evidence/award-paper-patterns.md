# Award-Paper Patterns — structural evidence base

How recent (2018–2025) **award-winning** empirical papers in economics and marketing/IS
actually structure their introductions, conclusions, and results interpretation. This is
the evidence record behind the guidance in [`main-text.md`](../main-text.md) Movements 2–4:
use it when you want to see *how many papers* support a structural rule, or to settle a
"do top papers really do X?" question with verified examples rather than assertion.

**Reorganization note (2026-09-23).** This is an earlier evidence record, retained for provenance. Its references to numbered main-text movements and paragraph defaults describe the former guide. Consult the current [section guides](../main-text.md#section-guides) for drafting; their flexible guidance supersedes conflicting prescriptions below. Moving this record does not constitute re-verification of its papers or counts.

## Provenance

- **Discovery:** award winners taken from the awarding societies' own announcement pages
  (ISMS / INFORMS, AMA/SAGE, Econometric Society, AEA, AIS/INFORMS).
- **Verification:** every paper below was confirmed in **Crossref** (first-author surname,
  title ≥80% match, journal, year). DOIs are the published-version DOIs.
- **Structure extraction:** done only for papers whose **full text was reachable**
  (open-access, author, repository, or working-paper copies). Paywalled winners are listed
  as VERIFIED but their internal structure was **not** analyzed and is **not** guessed.
- **Coverage:** ~51 verified winners across four award families; ~27 full-text structural
  extractions. Compiled 2026-06. Built via the [`literature-review`](../../../literature-review.md)
  skill (Path B → Crossref verification).
- **Caveats carried forward:** a handful of award-year cells could not be closed behind
  JS/Cloudflare-gated society pages (ISR 2024–25, MISQ Paper-of-the-Year 2024–25); one
  MISQ attribution (Kitchens 2020) is unconfirmed; the Kleven et al. published DOI is
  high-confidence but was not reconfirmed in the final Crossref pass. These are flagged in
  place, never filled with a guess.

---

## Cross-family synthesis (the actionable distillation)

These are the patterns that replicated across the **empirical** winners (economics +
empirical-marketing + quantitative-IS). Each is the basis for a rule in `main-text.md`.

### Introduction

1. **Open by overturning a status quo, not by posing a bare question.** ~12 of 14 econ
   winners and all accessible marketing/IS winners open on a received belief, institutional
   arrangement, or striking fact, then turn ("the conventional wisdom is X; we challenge
   it"). None opens cold with the question. → `main-text.md` Para 1 default.
2. **"In this paper we…" lands ¶2–4.** Universal.
3. **The headline answer is withheld to mid-intro (~¶5–9), not ¶1.** The *abstract* leads
   with the magnitude; the *introduction* leads with tension/design and delivers the number
   after the setup. → `main-text.md` Paras 3–4 clarification.
4. **Identification/design previewed explicitly** in the intro (reduced-form papers state
   the threat and how it's cleared; structural papers preview the model + novel
   identification). Universal in econ.
5. **The contribution is bounded** — every econ winner and most marketing winners state
   what they do *not* show ("application-specific", "not a welfare claim", "not the
   long-run youth effect"). → `main-text.md` bound-the-claim rule.
6. **Contribution organized one of three ways:** two-to-four literature strands; split by
   audience ("conceptually… / practically…", "policy / methodological"); or an enumerated
   "First… Second… Third…" list. → `main-text.md` Paras 9–10.
7. **Literature deferred to a late, often enumerated block; roadmap closes the intro**
   (dropped only by some structural/methods papers).

### Results interpretation

1. **Lead with the economic magnitude, not the p-value;** anchor each number to a
   real-world/managerial quantity. Universal.
2. **Separate economic from statistical significance** explicitly.
3. **Benchmark against prior estimates numerically** (13/14 econ winners do this).
4. **Repeat the headline number verbatim** across abstract → intro → conclusion (one
   winner repeats "83% vs. true 29%" identically three times). → `main-text.md` Movement 3.
5. **Handle nulls without over-claiming** — attribute a non-rejection to power/uncertainty,
   bound what it rules out; never declare "no effect."
6. **The punchline carrier varies** — a figure, a repeated number, *or* a decisive table;
   "one figure carries the punchline" is **not** universal in econ. → `main-text.md`
   Movement 3 qualification.
7. **Describe-then-interpret, then a one-line quotable verdict** ("a data problem, not a
   model problem"; "self-regulation is possible").

### Conclusion / Discussion

1. **Four-part shape:** restate → implications → limitations → labeled speculation.
2. **Implications often split by audience/stakeholder** (publishers / advertisers /
   regulators; researchers / industry; theory / practice).
3. **Limitations framed three ways:** an explicit/numbered design-choice list; a
   data-availability *scope* constraint (not a flaw); or woven-in caveats. Scope-or-data
   framing beats confession.
4. **Speculative elevation closes** — tie the specific finding up to a broader principle,
   explicitly flagged as speculative.
5. **Conclusions stay short** — econ winners run 1–5 paragraphs (one is ~140 words).

---

## Observed venue divergences (descriptive — not folded into the skill)

Recorded for completeness. The `main-text.md` guidance deliberately follows the
**econ / empirical-marketing** default above and does **not** adopt these; they are noted
only so the evidence isn't lost.

- **IS journals (MISQ / ISR):** longer, phenomenon-led intros; explicit **research
  questions** (interrogative, an *objective statement*, or **competing-hypothesis pairs**);
  a **conceptual reframe / new construct** pitched as the headline contribution; heavy
  causal hedging. Notable divergence from the textbook description: **enumerated
  contributions sit in the Discussion, not the intro**, and qualitative MISQ work replaces
  the canonical "Theoretical Contributions / Implications / Limitations" headers with
  thematic sentence-headings.
- **Behavioral experiments (JMR / JCR):** **theory-first** — full theoretical development
  and **hypotheses (H1–H3) stated verbatim in the introduction**; an "empirical overview"
  previews the studies; reporting via F-tests, labeled cell means, manipulation checks, and
  **serial mediation / moderation**; the General Discussion splits **theoretical vs.
  managerial** implications into separate named sections.
- **Reporting machinery is tradition-specific:** regression coefficients + SEs (econ);
  F-tests / cell means / serial mediation (behavioral); predictive metrics AUC / ROI
  (data-science empirical); structural counterfactuals with SEs; or "Result 1/2/3"
  statements mapped to RQs (IS experimental).

---

## Verified winners

### Marketing Science — ISMS John D. C. Little Award

| Award yr | Paper | Journal (pub yr) | DOI | Full text |
|---|---|---|---|---|
| 2020 | Johnson, Shriver & Du — Consumer Privacy Choice in Online Advertising | Mktg Sci (2020) | 10.1287/mksc.2019.1198 | N |
| 2021 | Cao & Zhang — Preference Learning and Demand Forecast | Mktg Sci (2021) | 10.1287/mksc.2020.1238 | Y |
| 2022 | Lin — Valuing Intrinsic and Instrumental Preferences for Privacy | Mktg Sci (2022) | 10.1287/mksc.2022.1368 | Y |
| 2023 | Gordon, Moakler & Zettelmeyer — Close Enough? Non-Experimental Ad Measurement | Mktg Sci (2023) | 10.1287/mksc.2022.1413 | Y |
| 2024 | K. T. Li — Frontiers: A Simple Forward Difference-in-Differences Method | Mktg Sci (2024) | 10.1287/mksc.2022.0212 | N |

### Marketing Science / Management Science — ISMS Frank M. Bass Dissertation Paper Award

| Award yr | Paper | Journal (pub yr) | DOI | Full text |
|---|---|---|---|---|
| 2020 | Tuchman — Advertising and Demand for Addictive Goods: E-Cigarette Advertising | Mktg Sci (2019) | 10.1287/mksc.2019.1195 | Y |
| 2021 | Rafieian & Yoganarasimhan — Targeting and Privacy in Mobile Advertising | Mktg Sci (2021) | 10.1287/mksc.2020.1235 | Y |
| 2022 | Dew, Ansari & Toubia — Letting Logos Speak | Mktg Sci (2022) | 10.1287/mksc.2021.1326 | N |
| 2023 | K. T. Li & Van den Bulte — Augmented Difference-in-Differences | Mktg Sci (2023) | 10.1287/mksc.2022.1406 | N |
| 2024 | Yang, Eckles, Dhillon & Aral — Targeting for Long-Term Outcomes | Mgmt Sci (2024) | 10.1287/mnsc.2023.4881 | Y |

### JMR — Paul E. Green / Vithala R. Rao Award (best paper, prior year)

| Award yr | Paper | Journal (pub yr) | DOI | Full text |
|---|---|---|---|---|
| 2025 | Melumad & Meyer — How Listening Versus Reading Alters Interpretations of News | JMR (2025) | 10.1177/00222437241280068 | N |
| 2024 | Huang, Maimaran & Kupor — Price Promotions to Drive Children's Healthy Choices | JMR (2024) | 10.1177/00222437241237483 | N |
| 2023 | Pachali, Kotschedoff, van Lin, Bronnenberg & van Herpen — How Do Nutritional Warning Labels Affect Prices? | JMR (2023) | 10.1177/00222437221105014 | Y |
| 2022 | Shi, Liu & Srinivasan — Hype News Diffusion and Risk of Misinformation (Oz Effect) | JMR (2022) | 10.1177/00222437211044472 | N |
| 2021 | Tunuguntla & Hoban — A Near-Optimal Bidding Strategy for Real-Time Display Ad Auctions | JMR (2021) | 10.1177/0022243720968547 | N |
| 2020 | Kim, Lee & Gupta — Bayesian Synthetic Control Methods | JMR (2020) | 10.1177/0022243720936230 | N |

### JMR — Weitz-Winer-O'Dell Award (long-term contribution, ~5 yrs out)

| Award yr | Paper | Journal (pub yr) | DOI | Full text |
|---|---|---|---|---|
| 2025 | Li & Xie — Is a Picture Worth a Thousand Words? Image Content and Social Media Engagement | JMR (2020) | 10.1177/0022243719881113 | N |
| 2024 | Mende, Scott, van Doorn, Grewal & Shanks — Service Robots Rising | JMR (2019) | 10.1177/0022243718822827 | Y |
| 2024 | Netzer, Lemaire & Herzenstein — When Words Sweat (loan-application text) | JMR (2019) | 10.1177/0022243719852959 | Y |
| 2023 | Ascarza — Retention Futility | JMR (2018) | 10.1509/jmr.16.0163 | N |
| 2022 | Johnson, Lewis & Nubbemeyer — Ghost Ads | JMR (2017) | 10.1509/jmr.15.0297 | N |
| 2021 | Sahni — Advertising Spillovers | JMR (2016) | 10.1509/jmr.14.0274 | N |
| 2020 | Anderson, Lin, Simester & Tucker — Harbingers of Failure | JMR (2015) | 10.1509/jmr.13.0415 | Y (WP) |

### Economics — Frisch Medal (Econometrica, biennial)

| Award yr | Paper | Journal (pub yr) | DOI | Full text |
|---|---|---|---|---|
| 2018 | Ahlfeldt, Redding, Sturm & Wolf — The Economics of Density: Berlin Wall | Econometrica (2015) | 10.3982/ecta10876 | Y |
| 2020 | Ho & Lee — Insurer Competition in Health Care Markets | Econometrica (2017) | 10.3982/ecta13570 | Y |
| 2022 | Brancaccio, Kalouptsidi & Papageorgiou — Geography, Transportation & Endogenous Trade Costs | Econometrica (2020) | 10.3982/ecta15455 | Y |
| 2024 | Egger, Haushofer, Miguel, Niehaus & Walker — General Equilibrium Effects of Cash Transfers (Kenya) | Econometrica (2022) | 10.3982/ecta17945 | Y |

### Economics — AEJ: Applied Economics Best Paper

| Award yr | Paper | Journal (pub yr) | DOI | Full text |
|---|---|---|---|---|
| 2020 | Kleven, Landais & Søgaard — Children and Gender Inequality: Denmark | AEJ: Applied (2019) | 10.1257/app.20180010 | (DOI high-confidence, not reconfirmed) |
| 2021 | Enikolopov, Petrova & Sonin — Social Media and Corruption | AEJ: Applied (2018) | 10.1257/app.20160089 | — |
| 2022 | Meager — Understanding the Average Impact of Microcredit Expansions | AEJ: Applied (2019) | 10.1257/app.20170299 | Y |
| 2023 | Atalay, Phongthiengtham, Sotelo & Tannenbaum — The Evolution of Work in the US | AEJ: Applied (2020) | 10.1257/app.20190070 | Y |
| 2024 | Deshpande, Gross & Su — Disability and Distress | AEJ: Applied (2021) | 10.1257/app.20190709 | Y |
| 2025 | Emanuel & Harrington — Working Remotely? Selection, Treatment & the Market for Remote Work | AEJ: Applied (2024) | 10.1257/app.20230376 | Y |

### Economics — AEJ: Economic Policy Best Paper

| Award yr | Paper | Journal (pub yr) | DOI | Full text |
|---|---|---|---|---|
| 2020 | Deshpande & Li — Who Is Screened Out? Application Costs and Targeting of Disability Programs | AEJ: Policy (2019) | 10.1257/pol.20180076 | Y |
| 2021 | Watzinger, Fackler, Nagler & Schnitzer — How Antitrust Enforcement Can Spur Innovation: Bell Labs | AEJ: Policy (2020) | 10.1257/pol.20190086 | Y |
| 2022 | Andersson — Carbon Taxes and CO2 Emissions: Sweden | AEJ: Policy (2019) | 10.1257/pol.20170144 | Y |
| 2023 | Okunogbe & Pouliquen — Technology, Taxation, and Corruption (e-filing) | AEJ: Policy (2022) | 10.1257/pol.20200123 | Y |
| 2024 | Biasi — The Labor Market for Teachers under Different Pay Schemes | AEJ: Policy (2021) | 10.1257/pol.20200295 | Y |
| 2025 | Gray, Leive, Prager, Pukelis & Zaki — Employed in a SNAP? Work Requirements | AEJ: Policy (2023) | 10.1257/pol.20200561 | Y |

> No formal annual best-paper award exists at AER, QJE, or JPE comparable to the AEJ
> awards (AER's recognitions are author prizes such as the Clark Medal, not paper awards).
> Flagged as not-found rather than invented.

### Management Science — ISS Best IS Paper Award

| Award yr | Paper | Journal (pub yr) | DOI | Full text |
|---|---|---|---|---|
| 2025 | Burtch, He, Hong & Lee — How Do Peer Awards Motivate Creative Content? (Reddit) | Mgmt Sci (2022) | 10.1287/mnsc.2021.4040 | N |
| 2024 | Godinho de Matos & Adjerid — Consumer Consent and Firm Targeting After GDPR | Mgmt Sci (2022) | 10.1287/mnsc.2021.4054 | N |
| 2023 | Gu & Zhu — Trust and Disintermediation: Online Freelance Marketplace | Mgmt Sci (2021) | 10.1287/mnsc.2020.3583 | N |
| 2022 | Acquisti & Fong — An Experiment in Hiring Discrimination via Online Social Networks | Mgmt Sci (2020) | 10.1287/mnsc.2018.3269 | N |

### Information Systems Research — ISS Best Published Paper Award

| Award yr | Paper | Journal (pub yr) | DOI | Full text |
|---|---|---|---|---|
| 2020 | Zhang, Adomavicius, Gupta & Ketter — Recommender Systems via Agent-Based Simulation | ISR (2020) | 10.1287/isre.2019.0876 | N |
| 2021 | Abbasi, Dobolyi, Vance & Zahedi — The Phishing Funnel Model | ISR (2021) | 10.1287/isre.2020.0973 | N |
| 2022 | Gunarathne, Rui & Seidmann — Racial Bias in Customer Service: Twitter | ISR (2022) | 10.1287/isre.2021.1058 | N |
| 2023 | Bauer, von Zahn & Hinz — Expl(AI)ned: Explainable AI and Information Processing | ISR (2023) | 10.1287/isre.2023.1199 | Y (WP) |

> ISR 2024–2025 winners not closed (society page JS-gated); not guessed.

### MIS Quarterly — Paper of the Year

| Award yr | Paper | Journal (pub yr) | DOI | Full text |
|---|---|---|---|---|
| 2021 | Lebovitz, Levina & Lifshitz-Assaf — Is AI Ground Truth Really True? | MISQ (2021) | 10.25300/misq/2021/16564 | Y |
| 2022 | de Lima Salge, Karahanna & Thatcher — Algorithmic Processes of Social Alertness (bots) | MISQ (2022) | 10.25300/misq/2021/15598 | N |
| 2023 | Pujol Priego & Wareham — From Bits to Atoms: Open Source Hardware at CERN | MISQ (2023) | 10.25300/misq/2022/16733 | N |
| (2020) | Kitchens, Johnson & Gray — Understanding Echo Chambers and Filter Bubbles | MISQ (2020) | 10.25300/misq/2020/16371 | Y — **PotY attribution unconfirmed** |

> MISQ runs two distinct awards: *Paper of the Year* vs. the *Davis-Dickson Impact Award*
> (decade-old paper). MISQ PotY 2024–2025 not closed (Cloudflare-gated); not guessed.

---

## Selected full-text skeletons

Condensed structural skeletons for representative accessible papers, as worked evidence
for the synthesis above. (Working-paper versions may differ in section numbering from the
typeset article; the structural *sequence* is intact.)

**Cao & Zhang (Little 2021) — empirical/structural.** Intro (7 parts): problem stakes →
prior solution A (test markets: valid, costly) → prior solution B (stated preference:
cheap, biased) → partial fix + its mixed record → the pivot/tension → "this paper"
(reframe + method) → findings with magnitudes + split "conceptually / practically"
contribution + roadmap. A cost-validity **schematic figure sits in the intro**. Conclusion
(~5 parts): worldview restatement → mechanism + headline → extensions → **four numbered
limitations** → speculative close (Lucas critique). Results lead with economic magnitudes.

**Gordon, Moakler & Zettelmeyer (Little 2023) — empirical.** Intro: RCT status quo →
RCTs unavailable → selection from ad delivery → "can we come close enough?" + data scale →
methods → findings with magnitudes → **three-numbered contribution** with scope caveats →
literature → roadmap. Conclusion restates the three contributions + a forward-looking
**"Next Steps for Researchers and Industry"** (four paths). Headline "83% vs. true 29%"
repeated verbatim abstract → intro → conclusion; verdict "a data problem, not a model
problem."

**Anderson, Lin, Simester & Tucker (O'Dell 2020) — empirical.** Intro (~6): opens on the
conventional wisdom ("more sales = success … fundamental to forecasting models"), then
"we challenge this assumption"; rhetorical puzzle ("how can more sales signal failure?"),
immediately answered; mechanism + brand examples; two identification approaches; "Related
Literature" placed *after* the intro. Conclusion: findings → one managerial paragraph →
two explicit limitations → future work. Predictive reporting (AUC, χ²), economic effect
sizes.

**Netzer, Lemaire & Herzenstein (O'Dell 2024) — empirical/text.** Intro: a two-borrower
**vignette/puzzle** ("which is more likely to default?") → reframes the data problem →
contribution-as-findings + returns to the vignette ("~8× more likely") → explicit
**claim-bound** ("we do not claim defaulters were intentionally deceptive") → roadmap.
Discussion: summary → four enumerated contributions → **Lucas-critique robustness** →
future avenues. Effects framed economically (ROI %, "8×").

**Pachali et al. (Green 2023) — structural.** Intro (~8): status-quo statistic (1.9B
obese) → theory gap (price-setting unstudied) → result up front as a "striking pattern"
(labeled-product prices *rise*, via a composition effect) → counterfactual + welfare angle
→ roadmap. Discussion (compact): findings → integrated policy implications → **three
numbered limitations** → future work folded in. Structural estimates with SEs; mechanism =
economic "composition effect," not a mediator.

**Egger et al. (Frisch 2024) — RCT/GE.** Status-quo/striking-fact opening; "this paper"
by ¶2–4; headline multiplier mid-intro (~¶5–10); explicit GE-identification preview;
candid bound ("do not imply helicopter drops would yield similar results"); roadmap
dropped (flows into §2). Short conclusion + separate Discussion; **labeled speculation**
("plausible, albeit speculative"). Economic-vs-statistical significance split sharply;
multiplier benchmarked against prior 1.5–2.6 range.

**Lebovitz, Levina & Lifshitz-Assaf (MISQ PotY 2021) — qualitative (IS).** Short intro:
"significant shift" hook → discourse problem → 11-month field setting → know-how vs.
know-what tension → findings preview, bleeding into Background Literature. **One rhetorical
RQ**, never enumerated; contributions deferred to the Discussion and **carried by tables**.
Discussion uses **thematic sentence-headings**, no "Limitations/Conclusion" labels.
Narrative process account, quote-driven. (IS-house style — recorded, not adopted.)

**Bauer, von Zahn & Hinz (ISR 2023) — experimental (IS).** Intro (8 moves): topic hook →
black-box problem → regulatory stakes + rise of XAI → gap → **three RQs** (stated
abstractly, then as a loan-officer vignette) → identification challenges → design + roadmap.
Contributions distributed across literature strands, not enumerated in the intro; claim
**bounded** to feature-based XAI. Findings as **three bolded "Result" statements** mapped
1:1 to the RQs; preregistered. (IS-house style — recorded, not adopted.)
