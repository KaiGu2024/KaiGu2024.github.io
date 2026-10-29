# Figure titles and panel labels: focused exemplar audit

Checked 2026-10-29. This is a purposive comparison of three papers, not a systematic review or a frequency estimate of journal practice. The question is how exhibit titles divide information with panels and notes. Current instructions live in [Results](../sections/results.md#exhibit-titles-and-panel-subtitles) and visualization's [annotations guide](../../../visualization/references/annotations.md#exhibit-titles-and-latex-panels).

## Sources and verification

Used the literature-review skill's Path B: inspect primary full texts, then check DOI metadata against Crossref. All three titles, author lists, publication years, and venues matched. The Gordon et al. text inspected is a dated prepublication version; its figure wording is not represented as a newly checked final journal version. Publisher HTML captions and notes and the Gordon PDF text supply the observations below; this is not a typography or graphical-layout audit.

| Paper | Version inspected and verification |
|---|---|
| Brynjolfsson, Li, and Raymond (2025), *Generative AI at Work*, Quarterly Journal of Economics | [Published article](https://academic.oup.com/qje/article/140/2/889/7990658), Figures I, II, IV, and V and their notes. [Crossref](https://api.crossref.org/works/10.1093/qje/qjae044): VERIFIED, issued 2025-02-04. |
| Gordon, Moakler, and Zettelmeyer (2023), *Close Enough? A Large-Scale Exploration of Non-Experimental Approaches to Advertising Measurement*, Marketing Science | [arXiv v2](https://arxiv.org/pdf/2201.07055v2), manuscript dated September 21, 2022; Figures 10 and 11, printed pp. 29 and 34 (PDF pages 30 and 35). [Crossref](https://api.crossref.org/works/10.1287/mksc.2022.1413): VERIFIED, issue date July 2023. |
| Winkler, Hotz-Behofsits, Wlömert, Papies, and Liaukonytė (2026), *Does TikTok promote or cannibalize music streaming? Estimands and identification with heavy-tailed outcomes*, Quantitative Marketing and Economics | [Published article](https://link.springer.com/article/10.1007/s11129-026-09312-2), Figures 3 and 4. [Crossref](https://api.crossref.org/works/10.1007/s11129-026-09312-2): VERIFIED, issued 2026-08-10. |

## Observed naming choices

| Display | Observed title or division of information | Transferable lesson |
|---|---|---|
| Outcome distributions | Brynjolfsson et al., Figure I: “Raw Productivity Distributions, by AI Treatment.” The note maps panels to distinct outcome measures and explains the treatment-status groups. | A distribution title can name the quantity family and grouping; panels and notes identify individual measures and groups. |
| Event study | Brynjolfsson et al., Figure II names the display type and productivity; its note explains the outcome, coefficient interpretation, estimation, intervals, and inference. | A compact title can rely on a precise note. This source does not establish our outcome-only axis convention as a universal rule. |
| Subgroup estimates | Brynjolfsson et al., Figure IV: “Heterogeneity of AI Impact, by Tenure at Deployment.” Its note maps panels to outcomes and defines tenure before access to AI. | The grouping dimension is informative; the word heterogeneity alone would not be. An umbrella title can work when panels supply the outcomes. |
| Time paths | Brynjolfsson et al., Figure V names experience curves and deployment cohorts; the note explains tenure and access timing. | Name the substantive trajectory and comparison groups; a time-path title need not state a causal finding. |
| Method comparison | Gordon et al., Figure 10 names experimental lift and the two observational estimators being compared. Panels separate purchase-funnel positions. Figure 11 is titled “Absolute Percentage Error by Event Funnel.” | Name the estimated quantity or error criterion and the comparison. A method name is useful when methods are the object of comparison. |
| Joint distribution | Winkler et al., [Figure 3](https://link.springer.com/article/10.1007/s11129-026-09312-2/figures/3) names both platform measures and their decile cross-classification. | For a joint grid, identify both dimensions; the surrounding labels or note must also identify what the cells measure. |
| Subgroup effects without the word heterogeneity | Winkler et al., [Figure 4](https://link.springer.com/article/10.1007/s11129-026-09312-2/figures/4): “Treatment Effects by Pre-Treatment TikTok Virality.” | Effects plus a comparison dimension is a workable descriptive title. Our preference adds an explicit outcome when it is not clear from the panel context. |

## Decisions and limits

The user's preferred `Effects on [outcome] by [dimension]` pattern is a house default, compatible with these examples rather than mandated by them. Use descriptive titles and let the analysis establish the conclusion. The requirement for a direct test before claiming subgroup differences comes from the existing Results guidance and the user's instruction; it is not an inference from how these papers word titles.

The examples motivate separating common subject, panel distinction, and interpretive note. TeX ownership of titles and letters, outcome-only event-study axes, and sentence-case figure text remain local conventions. Retain them even when a source uses different capitalization or embeds a title in an image.

The visualization guide also supplies adaptable scatterplot and counterfactual title examples. Those are editorial extensions, not types established by this audit. Conceptual diagrams retain their own construct and arrow guidance. For a new specialized display or a binding journal convention, inspect a relevant exemplar or official author instructions before asserting a broader rule.
