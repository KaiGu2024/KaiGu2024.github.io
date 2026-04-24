# The Household Impact of Generative AI: Evidence from Internet Browsing Behavior

**Authors:** Michael Blank, Gregor Schubert, Miao Ben Zhang | **Venue:** Working Paper (arXiv) | **Year:** 2026 | **Link:** https://arxiv.org/abs/2603.03144

---

## One-liner

Using Comscore panel data on 200,000+ U.S. households and a pre-ChatGPT browsing exposure IV, this paper shows that ChatGPT adoption raises digital leisure time by ~150 log points while leaving productive browsing unchanged, implying a 76%–176% efficiency gain on productive digital tasks at home.

---

## Research Question

How does generative AI (specifically ChatGPT) affect U.S. households' time allocation between productive and leisure online activities at home, and how large are the implied non-market productivity gains?

---

## Motivation & Contribution

- **Gap:** Empirical evidence on GenAI's economic impact focuses almost entirely on workplaces (productivity, jobs, firms). Yet 33.7% of Americans use GenAI outside work vs. 26.4% at work — the home setting is at least as economically significant, but largely unstudied.
- **Prior approach limits:** Surveys and lab experiments give snapshots but miss behavior context; chatbot interaction data (Anthropic, OpenAI) lacks context outside the chatbot.
- **What's novel:** (1) First large-scale revealed-preference evidence on household GenAI adoption and its impact on time use. (2) Novel LLM-based website classification into productive vs. leisure. (3) A household-level exposure instrument built from pre-ChatGPT browsing. (4) Adapts Aguiar et al. (2021) time-allocation model to quantify implied productivity gains from behavioral changes.

---

## Data

- **Source:** Comscore Internet Browsing Panel — comprehensive desktop/laptop browsing from household-owned machines
- **Sample size:** ~200,000+ households; regression sample = 42,886 (balanced, with income and age data and browsing in both pre- and post-ChatGPT periods)
- **Unit of observation:** Household × month (browsing intensity) or household × quarter (IV regressions)
- **Time period:** January 2021 – December 2024; benchmarking period = 2021; post-ChatGPT = after November 30, 2022
- **Geography:** U.S.; MSA-level geographic controls
- **Demographics:** Household income (8 bins), age of household head (11 bins), household size, MSA
- **Key variable availability:** All website visits with timestamps and duration; URL classification into productive/leisure via LLM. ChatGPT adoption measured as ever visiting chatgpt.com or openai.com
- **Limitations:** Desktop/laptop only — excludes mobile (likely underestimates total GenAI use). Sample somewhat over-represents low (<$60K) and high (>$200K) income; over-represents age 45–54. Weights applied to match 2022 ACS.

---

## Identification / Research Design

- **Strategy:** Instrumental variables (IV) with a long-difference design (2024 vs. 2022)
- **Instrument:** Household-level pre-ChatGPT GenAI exposure = share of 2021 browsing time on websites where ≥4 out of 5 activities can be performed by ChatGPT (computed from LLM-classified website activity overlap)
- **First stage:** 1 SD higher log exposure → 2.5pp higher probability of ever using ChatGPT by 2024 (KP F-stat = 104)
- **Key identifying assumption:** Conditional on income × age × MSA FEs and broad browsing composition controls, variation in pre-2022 browsing exposure to ChatGPT-substitutable sites does not independently predict 2024 browsing outcomes (exclusion restriction)
- **Threats:** Households that browsed more productive sites in 2021 may have other unobserved characteristics driving 2024 behavior; partially addressed by "Bartik share control" and website category exposure controls
- **Pre-trends check:** Dynamic quarterly IV shows no differential trends in browsing behavior in the four quarters before ChatGPT release
- **Robustness checks:** OLS vs. IV comparison; dynamic vs. long-difference specs; alternative exposure thresholds; controlling for adoption via other tools

---

## Key Variables

| Role | Variable | Definition |
|------|----------|------------|
| Treatment | Ever used ChatGPT by 2024 (dummy) | Visited chatgpt.com or openai.com at least once |
| Treatment (intensive) | ChatGPT duration share (%) | Share of total browsing time on ChatGPT |
| Outcome (main) | Δ log leisure browsing duration | Long difference 2024 vs. 2022 |
| Outcome (main) | Δ log productive browsing duration | Long difference 2024 vs. 2022 |
| Outcome | Δ leisure share of browsing | Change in proportion of time on leisure sites |
| Instrument | HHGenAIExp (household GenAI exposure) | Σ_j φ_{ij} · 1[E_j ∈ {4,5}] over Jan–Dec 2021 |
| Controls | Income bin × age bin × MSA FEs | Saturated demographic-by-region fixed effects |
| Controls | Bartik share control | Share of browsing on sites with any GenAI exposure label |
| Controls | Website category exposure | GenAI exposure predicted from Comscore content category × household browsing shares |

---

## Main Results

**Adoption patterns:**
- By Q4 2024: 16.3% of all households have ever used ChatGPT (vs. 9.3% in Q4 2023 — nearly doubled in a year)
- Adoption share of browsing time: 0.40% in Q4 2024 (vs. 0.14% in Q4 2023)
- High-income households adopt at 20.3% vs. 13.3% for low-income by Q4 2024; young at 24.1% vs. old at 10.6%
- Adoption gap by income and age is **widening**, not converging — a growing "generative AI divide"

**IV causal effects of ChatGPT adoption on browsing (Table VI):**
- Log leisure browsing duration: **+1.512** (≈4.5× increase, significant at 5%)
- Log productive browsing duration: **+0.011** (economically and statistically zero)
- Leisure share of browsing: **+30.7pp** (significant at 1%)
- Productive share of browsing: **−21.5pp** (significant at 1%)
- Log total browsing duration: +1.243** (significant at 5%)

**Reduced-form (1 SD exposure):** Total browsing +3%, leisure browsing +4%; productive unchanged (Table V cols 3–6)

---

## Mechanisms

1. **What categories decline/rise (Table VII):** Search browsing −0.177** and news browsing −0.039*** — the categories most directly substitutable by ChatGPT. Gaming +0.099***. Education, shopping, finance, job search: no significant change.

2. **High-frequency ChatGPT use context (Figure 9 / Table VIII):**
   - During the 30-minute ChatGPT use window: **80.1% productive** tasks, 7.6% leisure — vs. 54.9% productive, 21.3% leisure for matched never-users (+25.2pp productive, −13.7pp leisure gap)
   - Sites over-represented around ChatGPT use: google.com (+16pp), instructure.com (+4.7pp), canva.com, quillbot.com, quizlet.com, indeed.com, linkedin.com, pearson.com
   - Sites under-represented: YouTube, MSN, Facebook, Amazon, eBay — i.e., entertainment and shopping

3. **Together:** ChatGPT is primarily a tool for productive online tasks. Efficiency gains on those tasks free up time that is reallocated to leisure. The productive browsing share falls because productive tasks become a **time necessity** (Engel elasticity β_z = 0.931 < 1) — households hit diminishing returns and shift freed time to leisure luxuries (β_ℓ = 1.374 > 1).

---

## Robustness & Limitations

**Headline robustness:**
- Dynamic (quarterly IV) and long-difference specs yield consistent results; pre-trends are flat
- OLS and IV estimates move in the same direction; IV is larger (consistent with attenuation in OLS from measurement error or adoption heterogeneity)
- First-stage KP F-stat = 104, far above standard weak-instrument threshold
- Results robust to alternative exposure thresholds and to controlling for website category exposure

**Limitations:**
- **Mobile excluded:** Only captures desktop/laptop browsing; likely underestimates total GenAI use and total leisure reallocation
- **No workplace link:** Cannot distinguish whether household exposure complements or substitutes for workplace productivity gains
- **Sample representativeness:** Comscore panel over-represents extreme income deciles and age 45–54; weights applied, but external validity to full U.S. population requires caution
- **High-frequency context approach:** Noisy if households use ChatGPT without adjacent website visits, or if they multi-task. Qualitative direction is reliable but magnitudes should be interpreted cautiously

---

## Implications

**Policy:**
- Policies to improve digital literacy and subsidize GenAI access among older and lower-income households could equalize non-market productivity gains; inaction risks the "generative AI divide" widening further
- Welfare assessment of GenAI must account for non-market (household) productivity, not just labor market effects

**Theory:**
- Validates Aguiar et al. (2021) time-allocation framework in a new technology context
- Establishes that productive digital tasks behave as time necessities (Engel elasticity < 1) while leisure tasks are time luxuries — a key parameter for future household productivity models
- Raises the question of whether home GenAI use complements workplace GenAI use and how to measure the interaction

**Future research:**
- Link household and workplace GenAI adoption (do home adopters also adopt at work? Are there spillovers?)
- Mobile device data: full-picture time reallocation
- Dynamic effects: human capital accumulation, effects on education/skill development
- Long-run effects on inequality if the AI divide persists

---

## Discussion Questions

1. **Identification:** The exclusion restriction requires that 2021 browsing patterns don't independently predict 2024 browsing behavior conditional on controls. What plausible stories could violate this? Do you find the Bartik control and pre-trend evidence convincing?

2. **Interpretation of "productive":** The paper equates "productive" browsing with non-market work (education, job search, research) and "leisure" with entertainment/social media. Is this the right distinction? Could some "leisure" browsing be productive (e.g., reading news for civic knowledge) and some "productive" browsing be wasteful?

3. **Magnitude and external validity:** The implied 76%–176% efficiency gain is 2–4x larger than workplace estimates. Do the authors' explanations (novice users, multi-site tasks) fully account for this? What else could explain the gap, and does it make you more or less credulous?

4. **Generative AI divide:** The adoption gap by income and age is widening. Does this necessarily imply growing welfare inequality? What would we need to know to determine whether this is a policy problem vs. a normal technology diffusion pattern?

5. **Measurement and mobile:** The paper only captures desktop/laptop browsing, missing mobile. How might mobile usage patterns differ, and in which direction would including mobile change the results? Does this limitation affect your confidence in the main IV estimates?

6. **Welfare and model limitations:** The paper infers productivity gains from time reallocation alone, with no data on "output." Under what conditions could the same behavioral pattern (more leisure, same productive browsing time) reflect lower welfare rather than higher? Does the mechanism evidence rule this out?
