# Research section brainstorm

Date: 2026-07-21

## Bottom line

The four current projects are more coherent than the website presently suggests. They share one economic transformation: generative AI is becoming an intermediary between information producers, firms, and users. It does not merely help people search or write. It increasingly determines which information is retrieved, synthesized, cited, acted upon, and economically rewarded.

The clearest umbrella is:

> **The economics of AI-mediated information markets**

Within that umbrella, organize the work into two streams:

1. **AI-mediated discovery and choice**: referral traffic, traditional search displacement, shopping recommendations, conversion attribution, product visibility, source selection, and consumer welfare.
2. **Data access and knowledge production**: publisher restrictions on AI crawlers, the emergence of data-access intermediaries and licensing markets, and the effects of AI-assisted production on the quality and diversity of knowledge.

This structure is preferable to the current **AI divide / AI and information ecosystems** split because the stated active projects do not presently center on unequal adoption across demographic groups. If the AI-divide project remains active, it can be reintroduced later as a distinct project. It should not lead the current website unless it is supported by work visitors can see.

## The intellectual spine

The agenda can be expressed as a single feedback loop:

> AI systems mediate discovery and choice -> attention and revenue are reallocated -> publishers and firms change access and production decisions -> the information available to AI systems changes.

This loop connects the demand and supply sides of the agenda:

- On the **demand side**, AI search changes where information needs are resolved, which sources and products enter users' consideration sets, and which intermediaries receive attention and economic value.
- On the **supply side**, publishers and contributors react by changing crawler access, licensing, and content production. These responses alter the coverage, quality, and diversity of the information ecosystem on which AI systems depend.

This is the distinctive research identity. The agenda is not simply “applications of AI.” It studies AI as part of the market architecture governing information flows.

## Recommended website draft

This is the strongest full version for the current site:

> I study how generative AI is reorganizing digital information markets. My research asks what happens when AI systems move beyond supporting search and content production to become intermediaries between users, firms, and information producers. I examine how this shift reallocates attention and economic value, changes consumer choice, and feeds back into the supply, quality, and diversity of online information.
>
> My current work develops along two related streams. **AI-mediated discovery and choice** examines how conversational search changes referral traffic and competition with traditional search engines, and how AI shopping recommendations reshape the consumer journey. This work asks how influence should be measured when choices are formed inside a chat interface, which products and sources receive visibility, and whether lower search costs improve matching and consumer welfare or instead narrow consideration sets and concentrate demand. **Data access and knowledge production** studies why publishers restrict AI crawlers, whether those restrictions are effective, and how emerging data-access intermediaries shape licensing, bargaining, and the composition of the web available to AI systems. It also examines how platforms' adoption of AI-assisted content tools affects productivity, novelty, and collective diversity, with particular attention to geographic and cultural representation in knowledge commons.
>
> To study these questions, I combine economic theory and causal inference with computational audits, machine learning, and natural language processing, using large-scale clickstream, web, and text data.

Why this version works:

- Paragraph 1 supplies one research identity rather than a list of topics.
- Paragraph 2 maps every current project into one of two memorable streams.
- Paragraph 3 names methods that are visibly connected to the questions.
- The economic outcomes are explicit: attention, value, choice, welfare, bargaining, information quality, and diversity.

## Shorter website draft

Use this if the full version feels too dense next to the working-paper cards:

> I study the economics of AI-mediated information markets. My research examines how generative AI, increasingly positioned between information producers and users, reallocates attention and economic value and changes the production, distribution, and consumption of information.
>
> One stream studies **AI-mediated discovery and choice**, including referral traffic, competition with traditional search, shopping recommendations, conversion attribution, product visibility, and consumer welfare. A second studies **data access and knowledge production**, including publisher restrictions on AI crawlers, emerging markets for data access, and the effects of AI-assisted content production on novelty, collective diversity, and geographic and cultural representation. I combine economic theory and causal inference with computational audits, machine learning, and natural language processing using large-scale clickstream, web, and text data.

## Minimal version

Use this if the site should foreground the papers rather than the agenda:

> I study how generative AI is changing digital information markets. My work examines AI as an intermediary for search and consumer choice and as an infrastructure for data access and knowledge production. I focus on how these changes affect attention, referral traffic, product and publisher visibility, consumer welfare, and the quality and diversity of online information.
>
> I combine economic theory and causal inference with computational audits, machine learning, and natural language processing using large-scale clickstream, web, and text data.

## Alternative stream labels

### Recommended

- **AI-mediated discovery and choice**
- **Data access and knowledge production**

These are specific, parallel, and broad enough to survive changes in individual projects.

### More economics-forward

- **AI intermediation and consumer search**
- **The supply and governance of digital information**

This version signals economics more strongly but is less accessible to a general website visitor.

### More conceptual

- **AI as an information intermediary**
- **AI and the information supply side**

This makes the demand/supply structure clearest, but “information supply side” sounds more like a seminar framing than polished website prose.

### Not recommended

- **AI divide**: it does not describe the four current projects.
- **AI and information ecosystems**: accurate but too broad to distinguish your contribution.
- **AI search / AI data / AI content** as three headings: descriptive, but it fragments a coherent agenda into technologies rather than economic mechanisms.
- **Future of the web**: memorable but too expansive and difficult to defend.

## Project-by-project framing

### 1. AI search and referral traffic

#### Core economic change

Traditional search largely routed users from a query to a ranked set of websites. Generative search can resolve the information need inside the intermediary and return only selective citations. The shift is therefore from **link-based intermediation** to **answer-based intermediation**.

#### Strong research question

> When generative search resolves information needs inside the intermediary, how does it reallocate attention among publishers, users, and traditional search engines, and what does that imply for the production and diversity of information on the open web?

#### Literature-anchored terms

- generative search or conversational search
- information intermediation
- traditional-search displacement
- within-intermediary resolution
- outbound referral or referral traffic
- traffic allocation
- zero-click information seeking, when precisely defined
- publisher monetization and content-production incentives
- readership expansion versus business stealing
- the referral bargain, useful as a project-specific coined phrase because the current paper defines it

#### Avoid

- “AI answers humans' information needs”: use “resolves users' information needs.”
- “What happens to publishers?”: name traffic, monetization, audience relationships, entry, quality, or content investment.
- treating citations as equivalent to referrals: a citation is visibility; an outbound click is traffic. Their economic value can differ sharply.

### 2. AI search and consumer shopping

#### Core economic change

AI search can operate as a **choice intermediary**: it elicits preferences conversationally, constructs a consideration set, synthesizes product information, and recommends a small set of options. This is not merely another referral channel. Some persuasive and informational effects occur inside the interface before any observable click.

#### Strong research question

> How does AI-mediated product discovery reshape the path to purchase, and how should firms measure channel influence when product consideration and preference formation occur inside a conversational interface?

#### Measurement terminology

“Attribution ratio” is not the best term. Use:

- **conversion attribution** for the general problem;
- **multi-touch attribution** for allocating credit across observed touchpoints;
- **incremental or causal attribution** when estimating the effect of a channel relative to its absence;
- **assisted conversion** when an upstream source affects a purchase completed through another channel;
- **path to purchase**, **purchase funnel**, or **consumer journey** for the sequence of states and touchpoints.

The project has a sharp measurement wedge: AI may influence consideration and preferences without generating a click, so click-based paths become incomplete. Last-click attribution is not simply biased toward the last channel; it can miss an upstream AI-mediated exposure that occurred entirely within the intermediary.

#### Welfare terminology and outcomes

- consumer search costs
- product–consumer match quality
- consideration-set formation and breadth
- price discovery and price dispersion
- product discovery, including long-tail discovery
- demand concentration and seller visibility
- platform steering and self-preferencing
- recommendation diversity and stability
- consumer surplus or welfare, only when the design supports a welfare calculation

The key welfare trade-off is not automatically “AI improves welfare.” A recommender can reduce search costs and improve matching while narrowing the consideration set, steering users toward particular sellers, or concentrating demand.

#### Product and citation audit

Separate three outcomes:

1. **Product selection**: which products or brands are mentioned or recommended?
2. **Product ranking and framing**: in what order and with what claims are they presented?
3. **Source selection and use**: which domains are cited, and do those sources substantively affect the answer?

Relevant heterogeneity includes prompt language, market, product category, query specificity, price tier, source type, model, and time. Because generative search outputs can be unstable, repeated executions and repeated measurement waves are part of the estimand, not merely robustness checks.

For source types, distinguish **owned media**, **earned/editorial media**, **retailer or marketplace pages**, **user-generated content**, and **sponsored or commercial sources** where observable.

#### Better language for the ablation idea

The question is whether a citation is **functionally relied upon**, not merely whether it appears. Use:

- source reliance or citation dependence
- leave-one-source-out ablation
- source-class ablation
- counterfactual source removal
- citation faithfulness for whether a cited source supports a claim
- citation completeness for whether claims that require support receive citations

An operational definition of a “decorative citation” could be:

> a cited source whose removal does not materially change the recommended set, ranking, or supporting claims, conditional on the remaining retrieved information.

Do not infer from this result alone that the behavior is caused by pretraining or RLHF. In a black-box system, invariance under source removal may reflect memorized knowledge, redundant retrieval, a separate ranking stage, post-hoc citation assignment, or alignment behavior. Training- or RLHF-based explanations should be labeled mechanisms to distinguish, not conclusions delivered by a single ablation.

### 3. AI data and “the missing web”

#### Core economic change

The open web is becoming an endogenously selected input into AI systems. Publishers can signal or enforce use-specific access restrictions, crawlers differ in compliance, and infrastructure providers can mediate access or payment. The economic object is therefore not only web scraping; it is the **governance and supply of AI data**.

#### Strong research question

> As publishers restrict AI crawlers, which parts of the web remain accessible to different AI uses, how effective are these restrictions, and what are the downstream consequences for data composition, information quality, and competition among AI providers?

#### Decompose access carefully

Distinguish at least:

- training crawlers;
- search or indexing crawlers;
- retrieval-time crawlers;
- user-triggered fetching or agents.

Publishers may permit one use while restricting another. Calling a domain simply “open” or “closed” discards the economically interesting variation.

Also distinguish:

- declared restrictions in `robots.txt` or terms of service;
- active blocking at the network or reverse-proxy layer;
- observed crawler compliance;
- successful access despite a stated restriction.

#### Terminology

- AI data commons
- selective participation or use-specific access
- crawler restrictions and crawler compliance
- Robots Exclusion Protocol
- endogenous data availability
- selection in training-data supply
- data provenance and data-use rights
- content licensing and bargaining
- data-access market or AI data market
- data-access intermediary

“The Missing Web” is an evocative project title. In formal prose, define it as the part of economically valuable online content that becomes unavailable to particular AI uses because access restrictions are selective and endogenous.

#### How to describe Cloudflare

“Market maker” is too specific unless the analysis shows that Cloudflare matches buyers and sellers, enables transactions, and contributes to price formation. Safer terms are:

- **data-access intermediary**;
- **access-control platform**;
- **licensing intermediary**;
- **market-design infrastructure for AI data**, if the focus is on rules and transaction design;
- **two-sided data-access platform**, if both publishers and AI firms participate and cross-side effects are central.

The downstream outcomes can include publisher bargaining power, transaction costs, access fragmentation, price discovery, data quality, entry barriers, and concentration among AI firms. A central hypothesis is that restricting high-quality content may worsen the composition of accessible data while strengthening firms that already possess proprietary corpora or bilateral licenses.

### 4. AI for knowledge production

#### Core economic change

AI-assisted tools lower the marginal cost of content production but may cause many contributors to draw on similar model priors. The central object is a **productivity–diversity trade-off at the ecosystem level**.

#### Strong research question

> When knowledge platforms introduce AI-assisted content tools, do productivity gains expand the knowledge commons, or do shared model priors make contributions more similar and reduce novelty, long-tail coverage, and geographic and cultural representation?

#### Outcomes that should remain separate

- individual productivity or contribution volume
- individual content quality
- novelty relative to prior content
- pairwise similarity or semantic convergence
- collective diversity across contributions
- topic and long-tail coverage
- geographic and cultural representation
- contributor entry, retention, and displacement
- verification and moderation burden

The distinction between **individual quality** and **collective diversity** is crucial. Generative AI can improve the average contribution while making the set of contributions more alike. This is stronger and more precise than saying “the knowledge commons becomes flat.”

#### Literature-anchored terms

- AI-assisted content production or human–AI co-production
- content homogenization
- collective diversity
- generative monoculture
- semantic convergence
- novelty and content differentiation
- geographic and cultural representation
- local or long-tail knowledge coverage
- knowledge commons
- platform governance
- verification burden

Use **algorithmic monoculture** cautiously. That literature often describes many decision-makers relying on the same prediction system. **Generative monoculture** or **content homogenization** is closer when the outcome is reduced diversity in generated content.

## Terminology anchoring table

| Draft expression | Verdict | Recommended term | Reason |
|---|---|---|---|
| AI search | keep/define | generative search or conversational search | More precise when the system retrieves and synthesizes an answer. |
| humans' information needs | anchor | users' information needs | Standard information-search language. |
| resolves needs inside chat | anchor | within-intermediary resolution | Names the mechanism without colloquial wording. |
| attribution ratio | anchor | conversion attribution / multi-touch attribution / causal attribution | Established marketing terminology; choose according to the estimand. |
| last-click method | anchor | last-click attribution | Standard term. |
| AI as recommender system | choose | AI-mediated product discovery / conversational recommendation | Better captures search, synthesis, and recommendation in one interface. |
| citations differ | specify | source selection, citation allocation, source diversity, citation faithfulness | “Differ” does not identify the outcome. |
| citations are decorative | coin/define | low citation dependence under source ablation | “Decorative” is intuitive but needs a counterfactual operational definition. |
| earned media | keep | earned/editorial media | Established marketing term; add “editorial” for general readers. |
| publishers blocking crawler bots | anchor | publisher-imposed AI crawler restrictions | Clear actor and object. |
| do the blocks work? | anchor | crawler compliance and enforcement effectiveness | Separates voluntary protocol compliance from active blocking. |
| the missing web | coin/define | selectively inaccessible web / endogenous data exclusion | Keep as a title, define in formal prose. |
| Cloudflare as a market maker | choose | data-access intermediary / access-control platform | “Market maker” imposes a stronger market role than may be observed. |
| downstream economics | specify | effects on data composition, model quality, publisher bargaining, and AI-market concentration | Name the actual outcomes. |
| content convergence | anchor | content homogenization / semantic convergence | Both are measurable constructs. |
| less novelty | keep | novelty | Keep distinct from similarity and diversity. |
| geo-cultural local content | anchor | geographic and cultural representation / local-knowledge coverage | Cleaner and more measurable. |
| knowledge commons flat | anchor | reduced collective diversity and long-tail coverage | Converts a metaphor into estimable outcomes. |

## Literature anchors

These sources are anchors for terminology and positioning, not a claim that every source belongs in every eventual paper.

### Information intermediation and referral traffic

- Shi, Zhu, and Gu, [“Answering Without Referring: How AI Search Rewrites the Web's Economic Bargain”](https://arxiv.org/abs/2607.07652). Direct anchor for within-interface resolution, traditional-search displacement, outbound referrals, and the referral bargain.
- Jeon and Nasr, [“News Aggregators and Competition among Newspapers on the Internet”](https://doi.org/10.1257/mic.20140151), *AEJ: Microeconomics* (2016). Anchors the readership-expansion versus business-stealing trade-off and downstream publisher quality incentives.
- Aggarwal et al., [“GEO: Generative Engine Optimization”](https://doi.org/10.1145/3637528.3671900), KDD (2024). Anchors generative-engine visibility as a distinct object from conventional search ranking.
- Kirsten et al., [“Characterizing Web Search in the Age of Generative AI”](https://aclanthology.org/2026.findings-acl.526/), ACL Findings (2026). Anchors retrieval footprints, source diversity, synthesis, and output stability as dimensions distinguishing generative from traditional search.

### Shopping, attribution, and citations

- Li and Kannan, [“Attributing Conversions in a Multichannel Online Marketing Environment”](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=2621304), *Journal of Marketing Research* (2014). Anchors multi-touch attribution, incremental channel value, carryover, spillovers, and the shortcomings of last-click attribution.
- Abhishek, Fader, and Hosanagar, [“Media Exposure through the Funnel”](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=2158421). Anchors multi-stage attribution and latent states in the purchase funnel.
- Chen, Shi, and Zhong, [“Predictive Accuracy, Consumer Search, and Personalized Recommendation”](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=4298841). Anchors the participation-drawing versus search-narrowing effects of recommendations.
- Derakhshan et al., [“Product Ranking on Online Platforms”](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3130378). Anchors consideration-set effects, platform ranking, and consumer welfare.
- Liu, Zhang, and Liang, [“Evaluating Verifiability in Generative Search Engines”](https://aclanthology.org/2023.findings-emnlp.467/), EMNLP Findings (2023). Anchors citation recall/completeness and citation precision/correctness.
- Kumar and Lakkaraju, [“Manipulating Large Language Models to Increase Product Visibility”](https://arxiv.org/abs/2404.07981). Anchors product visibility and strategic manipulation in LLM recommendations.

### AI crawler access and data markets

- Longpre et al., [“Consent in Crisis: The Rapid Decline of the AI Data Commons”](https://arxiv.org/abs/2407.14933). Anchors the AI data commons, crawler restrictions, consent signals, and changes in accessible web data.
- Liu et al., [“Somesite I Used to Crawl”](https://arxiv.org/abs/2411.15091). Anchors creator agency, the efficacy of crawler controls, and reverse-proxy enforcement.
- Kim et al., [“Scrapers Selectively Respect robots.txt Directives”](https://arxiv.org/abs/2505.21733). Anchors crawler compliance as an empirical outcome distinct from declared restrictions.
- Zhu, [“Selective Participation in the AI Data Commons”](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=6438640). Anchors use-specific selectivity, publisher quality, and endogenous composition of accessible data.
- Gans, [“Market Power in Artificial Intelligence”](https://www.nber.org/papers/w32270), NBER Working Paper 32270 (2024). Anchors data markets, data trading across firm boundaries, and AI market power.
- Cloudflare's [Pay Per Crawl description](https://blog.cloudflare.com/introducing-pay-per-crawl/) documents the emerging infrastructure. It is a primary source about the product, not independent evidence of its economic effects.

### Knowledge production and diversity

- Doshi and Hauser, [“Generative AI Enhances Individual Creativity but Reduces the Collective Diversity of Novel Content”](https://www.science.org/doi/10.1126/sciadv.adn5290), *Science Advances* (2024). Anchors the distinction between individual creative performance and collective diversity.
- Raghavan, [“Competition and Diversity in Generative AI”](https://arxiv.org/abs/2412.08610). Anchors equilibrium content homogeneity, competition, and content differentiation.
- Wu, Black, and Chandrasekaran, [“Generative Monoculture in Large Language Models”](https://arxiv.org/abs/2407.02209), ICLR (2025). Anchors “generative monoculture” as narrowing of output diversity relative to the source distribution.
- Liu et al., [“Measuring Geographic Diversity of Foundation Models”](https://arxiv.org/abs/2404.07612). Anchors geographic representation and inter-regional disparities as measurable outcomes.
- The Workshop on Governing Knowledge Commons provides a concise [definition of knowledge commons](https://knowledge-commons.net/about-knowledge-commons/) centered on community governance of shared knowledge resources.

## What to remove or relocate from the current website

1. **Remove “The AI divide” from the lead unless that line of work is genuinely active.** None of the four projects supplied for this revision studies demographic differences in adoption or welfare.
2. **Remove or relocate the political ideology paragraph.** It currently opens a third agenda that is disconnected from the displayed working papers. If it remains important, place it in one short final sentence as a broader interest, or connect it concretely to cultural representation in AI-mediated knowledge production.
3. **Replace “measure and estimate effects.”** The two verbs are redundant, and the phrase says little about the empirical strategy. “Using large-scale clickstream, web, and text data” makes the methods paragraph more concrete.
4. **Do not list every sub-question on the website.** The full project map belongs in paper abstracts, a research statement, or future project cards. The website's research-interest prose should establish the common mechanism and stakes.

## Suggested one-line research identity

Preferred:

> I study the economics of AI-mediated information markets, with a focus on digital intermediation, consumer search, data access, and knowledge production.

More accessible:

> I study how generative AI is changing the way information is produced, discovered, and valued online.

More economics-forward:

> I study how AI intermediation reallocates attention and value and how those changes feed back into the supply of data and digital content.

## Editorial recommendation

Use the recommended three-paragraph website draft. It is specific enough to distinguish the research agenda, broad enough to accommodate all four projects, and short enough that the working papers remain the evidence. Keep “The Missing Web” and “the referral bargain” as memorable project-level language, but anchor the website's umbrella in established terms: information intermediation, consumer search, conversion attribution, data access, content production, and collective diversity.
