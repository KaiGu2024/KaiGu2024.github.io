# Relationship and evidence semantics

Use this reference to choose edges and distinguish theoretical meaning from measurement and empirical identification. The paper's notation is the starting point; if it is ambiguous, state a reconstruction instead of silently changing its meaning.

## Edge decision table

| Intended meaning | Depiction | Qualification |
|---|---|---|
| Proposed causal influence | `X → Y` | Direction is a causal hypothesis; design/assumptions determine whether it is identified. |
| Predictive/regression dependence | `X → Y` labeled “predicts” or “regression” | Do not infer causality from the arrow or a significant coefficient. |
| Covariance in SEM/path model | `X ↔ Y` labeled covariance | May represent correlated exogenous variables or disturbances; does not by itself establish a common cause. |
| Latent confounding in a causal graph | `X ↔ Y`, with legend “unobserved common cause” | Shorthand for `X ← U → Y`; not reciprocal causation. |
| Explicit common cause | `C → X` and `C → Y` | Show the noncausal path relative to the focal X→Y effect. |
| Mediation | `X → M → Y`, plus direct X→Y only if posited | Mark M unmeasured when appropriate; a total treatment effect does not validate M. |
| Moderation/effect heterogeneity | A connector labeled “moderates” points to the X→Y link, or show an interaction | It is not a standard DAG edge; identify it as conceptual moderation in the legend. |
| Reciprocal causal influences | Two separate directed paths or time-indexed X(t)→Y(t+1), Y(t)→X(t+1) | State temporal assumptions; do not call a cyclic model a DAG. |
| Generic measurement correspondence | Gray dashed connector without heads | State “operationalized by”; not an estimated structural effect. |
| Reflective measurement | Construct → indicator, in the measurement layer | State the measurement assumption; add errors only as the paper specifies. |
| Formative/composite measurement | Indicators → construct/composite | Do not reverse to match the preferred top-to-bottom layout. |
| Taxonomy, domain, criteria, membership | Containment, bracket, or labeled noncausal connector | No causal interpretation and no fabricated dependent variables. |

## Roles are not interchangeable

A confounder in the common-cause case influences both exposure and outcome; association with both is not a causal definition. A control is a variable conditioned on in the analysis. Controls may address confounding, improve precision, or introduce bias. A mediator transmits an effect; a collider is a common effect of two variables. Neither is automatically an appropriate confounder adjustment. Select controls relative to the target effect and causal structure; do not translate a regression's entire control list into common-cause arrows.

A moderator indexes variation in an effect. Even under randomized treatment, an observed moderator can identify subgroup treatment effects under suitable conditions without identifying what would happen if that moderator were manipulated. Prior timing or nonrandom assignment does not turn a moderator into a confounder.

## Identification annotation

For the focal empirical claim, state compactly:

- What varies, at what unit, and whether assignment is randomized.
- Which contrast is identified and which inputs/moderators remain observed.
- Whether constructs are latent or directly measured, separately from whether exposures were manipulated. Avoid “all variables observed” as shorthand for “observational study” when latent constructs are modeled.
- What the method assumes: for example parallel trends, continuity/no simultaneous change at a threshold, exclusion, or no unmeasured confounding as actually relevant.
- Which diagnostics support assumptions and which alternatives remain; a diagnostic does not prove an assumption.

If a paper says “regression discontinuity,” locate the actual running variable, cutoff/intervention timing, comparison window, and assignment mechanism. Preserve the authors' label while explaining what the implemented analysis does. A threshold used to categorize a moderator does not by itself constitute a discontinuity design.

Distinguish uncertainty about the theory, uncertainty about measurement, and uncertainty about identification. Use short text tags rather than overloading line style: solid/dashed lines already carry structural/measurement meanings. Only include effect sizes, signs, or coefficient labels if they are central and traceable to the same specification; a conceptual figure need not reproduce an entire results table.

## Authoritative notation references

- Johannes Textor, *Drawing and Analyzing Causal DAGs with DAGitty*, July 18, 2023, §§2 and 5.5: https://www.dagitty.net/manual-3.x.pdf. Directed edges, latent common causes, and adjustment logic. DOI not supplied.
- Official lavaan documentation, *Model syntax 1*, undated: https://www.lavaan.ugent.be/tutorial/syntax1.html. Latent-variable, regression, and covariance distinctions. DOI not supplied.

These are notation references, not evidence about the focal paper. Read additional authoritative sources if a paper uses an unfamiliar graphical formalism rather than guessing its semantics.
