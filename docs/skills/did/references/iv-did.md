# Optional module: IV with difference-in-differences

Use this module for a proposed encouragement or eligibility instrument distinct from endogenous treatment. Sources L13 and L16 are in the [literature guide](literature.md).

Separate **instrument assignment**, **endogenous treatment/uptake**, and **outcome**. For predetermined exposure \(E_i\) and date \(T_0\), a candidate instrument is

\[
Z_{it}=E_i\,1\{t\ge T_0\}.
\]

A national post indicator alone is absorbed by calendar effects. Assess instrument exogeneity using the differential encouragement, measurement of exposure, comparison group, and competing channels.

With matching sample, weights, controls, timing, and reference, estimate the **first stage** and **outcome reduced form**. A panel illustration is:

\[
D_{it}=\alpha_i^D+\lambda_t^D+\pi Z_{it}+X_i'\gamma_t^D+u_{it},\qquad
Y_{it}=\alpha_i^Y+\lambda_t^Y+\rho Z_{it}+X_i'\gamma_t^Y+v_{it}.
\]

Linear 2SLS instead writes the outcome equation in instrumented \(D\), including the same regressors in its first stage. Fixed effects are compatible with IV. For one instrument and common contrast, \(\theta=\rho/\pi\). Over a dynamic window \(H\), use

\[
\widehat\theta_H=\frac{\sum_{k\in H}a_k\widehat\rho_k}{\sum_{k\in H}a_k\widehat\pi_k},\qquad\sum_{k\in H}a_k=1.
\]

The window estimand is a **ratio of averages**. For period-specific ratios, retain joint cross-stage uncertainty and specify carryover assumptions linking earlier treatment to later outcomes. For other data structures, use compatible group contrasts and sampling assumptions.

1. **Identification:** justify counterfactual treatment/outcome trends absent instrument exposure, no anticipation, exclusion, relevance, and monotonicity/response restrictions. Define the local effect for binary uptake or treatment intensity, distinguishing DID-IV from alternative fuzzy-DiD frameworks [L13].
2. **Timing:** index shock effects by the shock. Do not threshold fitted probabilities into invented adoption dates and feed them to ordinary CSDiD as a valid two-stage IV method. Dedicated staggered DID-IV needs its own instrument-defined comparisons and aggregation [L13].
3. **Multiple dates:** document risk sets, exposure history, earlier treatment, later contamination, and common support. Check each instrument's contrast, rank, exclusion, first stage, and heterogeneous-effect weighting before pooling.
4. **Strength:** report first-stage changes and appropriate robust statistics, accounting for few targets and weight concentration. Use scalar or joint/conditional diagnostics as appropriate; F above 10 is not a universal strength criterion [L16].
5. **Uncertainty:** use appropriate Fieller or Anderson–Rubin inversion with joint covariance rather than dividing CI endpoints. Retain bounded, unbounded, disjoint, and all-real confidence sets; distinguish numerical failures.
6. **Preperiods:** all-zero recorded uptake can make lead tests uninformative. Assess identification through the assumptions in item 1; interpret an imprecise reduced form as limited evidence about the outcome effect.


## Report the components

Show the first-stage effect on treatment, the reduced-form effect on the outcome, and then their compatible IV contrast. The instrument's timing defines the event clock. Preperiod ratios may be undefined or uninformative; post-only ratios are acceptable with both component lead diagnostics retained. Use units such as outcome units per induced treatment unit, and state the population and assumptions behind that interpretation.

Use arrows for confidence sets truncated by the display axis. Trend-robust IV inference needs a joint procedure for treatment and outcome trends; with several instruments, use the estimator's moment conditions and weighting.
