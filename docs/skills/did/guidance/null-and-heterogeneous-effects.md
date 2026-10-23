# Null averages and heterogeneous effects

A null average can coexist with an effect concentrated in one subgroup or with positive and negative effects that offset. Treat this as a substantive direction worth investigating. Keep the overall specification as a benchmark and ask which baseline conditions change the response. This workflow also applies when the average is nonzero; an overall significance test is not a gate for studying heterogeneity.

## Define the claim and conditions

Distinguish an estimate close to zero with a narrow interval from an imprecise estimate that permits large effects. Use a justified substantive equivalence range if claiming an effect is negligible. Apply the same distinction to a subgroup described as having no effect.

Choose a small set of modifiers from mechanisms, institutions, or prior evidence. Define group membership before treatment and record when each hypothesis or cutoff was chosen relative to viewing outcomes. Preserve continuous modifiers when useful instead of searching many cutoffs. Grouping by treatment-induced behavior answers a different selection or mediation question. Outcome-informed discoveries can be pursued, with exploratory status and independent validation where feasible.

## Estimate and compare effects

1. **Define comparable targets.** State each subgroup's treatment contrast, outcome units, horizon, cohort support, eligible controls, and weights. Use comparisons supported by the assignment process. A subgroup-by-treatment interaction alone does not make a staggered TWFE specification robust to heterogeneous effects; follow the estimator guidance in the [main skill](../SKILL.md#4-match-the-estimator-to-the-design).
2. **Test the difference.** Estimate subgroup effects and their direct contrast, such as \(\tau_A-\tau_B\), with an interval. Use joint covariance or joint resampling that respects assignment clusters, shared controls, and fitted components. One subgroup's significant effect and another's insignificant effect do not establish a difference. Opposite point-estimate signs also need uncertainty before supporting a sign-reversal claim. [L19]
3. **Explain the average.** For a common target partitioned into exhaustive, nonoverlapping subgroups, use its population weights to aggregate subgroup effects. Report subgroup shares and contributions. Separate dilution by a small affected subgroup, offsetting effects, and low precision. Different samples, horizons, cohort weights, or a conventional TWFE coefficient need not reproduce that average. Reconcile those differences before claiming cancellation. [L1]
4. **Account for the search.** Retain all planned subgroup results and record explored modifiers and thresholds. Use inference appropriate to the tested family or an independent confirmation sample when making confirmatory claims after a broad search. A compelling interaction is a finding to assess, not a reason to discard the pooled null.

## Evaluate the trend assumption for the actual claim

Flat pooled pre-trends can mask opposing subgroup discrepancies. Examine pre-treatment treated-versus-comparison contrasts within the groups whose causal effects are being claimed. Assess their size and uncertainty, support, composition, and the estimator used. Do not require every lead to be insignificant or use a visual pass/fail rule. See [main skill §5](../SKILL.md#5-separate-identification-magnitude-and-precision) and L8.

Observed subgroup pre-trends do not automatically end the investigation. Diagnose them, then choose a defensible comparison or conditional-trend model, assess sensitivity to plausible deviations, or retain an exploratory/descriptive interpretation. A trend adjustment needs a justified extrapolation assumption; the significance of the adjusted interaction is not its validation. Apply sensitivity analysis to the subgroup effect or contrast actually being claimed, retaining the covariance it needs. [L11]

**A relative effect can have a different identifying assumption from each subgroup's effect.** In a justified triple-difference design, common untreated trend bias across subgroup DiDs can cancel in their difference. Explain why that restriction is plausible and examine preperiod evidence for the differential contrast. This can support an effect difference without identifying either subgroup's absolute effect. Do not label a comparison subgroup unaffected merely because its estimate is insignificant, or infer positive and negative causal effects from the relative contrast alone. [L20]

## Present the result

Lead with the overall estimate, then the condition under which responses differ, followed by subgroup estimates and the direct contrast with uncertainty. A compact table or coefficient plot can carry this argument. Follow [main skill §6](../SKILL.md#6-present-the-supported-conclusion-and-preserve-the-audit-trail) for optional event-study figures and disclosure of diagnostic evidence; no separate event-study panel is required for every subgroup.

For example, when supported: “The average effect is close to zero. The effect is positive among A and negative among B, and their weighted contributions largely offset.” If B's interval remains wide, describe its effect as imprecisely estimated instead. If only the relative contrast is identified, say “The effect is larger in A than B.” State a material trend limitation once, alongside its consequence for that claim.

Sources [L1, L8, L11, L19, L20] are in the [literature guide](../references/literature.md). The sequence above is a practical synthesis, not a new estimator or a requirement to run every method.
