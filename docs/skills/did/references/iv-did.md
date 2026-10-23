# Optional module: IV with difference-in-differences

Read this only when the study has a proposed encouragement or eligibility instrument distinct from endogenous treatment. Ordinary DiD does not require an IV. This module gives design checks, not a universal estimator for every instrument or treatment path. Sources L13 and L16 are in the [literature guide](literature.md).

Separate **instrument assignment**, **endogenous treatment/uptake**, and **outcome**. A first-stage fit does not make observed adoption timing exogenous. For predetermined exposure \(E_i\) and date \(T_0\), a candidate instrument is

\[
Z_{it}=E_i\,1\{t\ge T_0\}.
\]

A national post indicator alone is absorbed by calendar effects. Multiplying it by endogenous/mismeasured status does not automatically make it valid. Explain differential encouragement, comparison exposure, and competing channels. Predetermination alone is not exogeneity.

With matching sample, weights, controls, timing, and reference, estimate the **first stage** and **outcome reduced form**. A panel illustration is:

\[
D_{it}=\alpha_i^D+\lambda_t^D+\pi Z_{it}+X_i'\gamma_t^D+u_{it},\qquad
Y_{it}=\alpha_i^Y+\lambda_t^Y+\rho Z_{it}+X_i'\gamma_t^Y+v_{it}.
\]

Linear 2SLS instead writes the outcome equation in instrumented \(D\), including the same regressors in its first stage. Fixed effects are compatible with IV. For one instrument and common contrast, \(\theta=\rho/\pi\). Over a dynamic window \(H\), use

\[
\widehat\theta_H=\frac{\sum_{k\in H}a_k\widehat\rho_k}{\sum_{k\in H}a_k\widehat\pi_k},\qquad\sum_{k\in H}a_k=1.
\]

This is a **ratio of averages**, not an average of period-specific ratios. Period-specific ratios can be estimated with joint cross-stage uncertainty. Their causal interpretation needs dynamic assumptions: earlier treatment can affect later outcomes, so a same-period ratio is not automatically the effect of an isolated treatment unit. For other data structures, use compatible group contrasts and sampling assumptions rather than importing person fixed effects.

1. **Identification:** justify counterfactual treatment/outcome trends absent instrument exposure, no anticipation, exclusion, relevance, and appropriate monotonicity/response restrictions. Binary complier LATE/LATT is not automatic for treatment intensity. Distinguish DID-IV from alternative fuzzy-DiD frameworks [L13].
2. **Timing:** index shock effects by the shock. Do not threshold fitted probabilities into invented adoption dates and feed them to ordinary CSDiD as a valid two-stage IV method. Dedicated staggered DID-IV needs its own instrument-defined comparisons and aggregation [L13].
3. **Multiple dates:** document risk sets, exposure history, earlier treatment, later contamination, and common support. Several rollout dates do not mechanically justify a chosen instrument set. Each instrument must encode a defensible contrast; check rank, exclusion, first stages, and heterogeneous-effect weighting before pooling.
4. **Strength:** report first-stage changes and appropriate robust statistics. F above 10 is not a universal certificate [L16]. A squared robust t is useful for a scalar contrast; multi-IV settings require suitable joint/conditional diagnostics. A large control pool does not erase few targets or weight concentration.
5. **Uncertainty:** use appropriate Fieller or Anderson–Rubin inversion with covariance. Do not divide CI endpoints or always rely on a delta approximation. Retain bounded, unbounded, disjoint, and all-real confidence sets; distinguish numerical failures.
6. **Preperiods:** all-zero recorded uptake can make lead tests mechanical/uninformative. Neither insignificant leads nor a significant reduced form is a logical prerequisite for valid IV identification. An imprecise reduced form limits evidence for an outcome effect; it is not itself proof of invalidity.


## Report the components and limits

Show the first-stage effect on treatment, the reduced-form effect on the outcome, and then their compatible IV contrast. The instrument's timing defines the event clock. Preperiod ratios may be undefined or uninformative; post-only ratios are acceptable with both component lead diagnostics retained. Use units such as outcome units per induced treatment unit, and state the population and assumptions behind that interpretation.

Allow confidence sets to be bounded, unbounded, disjoint, or all-real; arrows should denote truncated display of a set, not a precise estimate beyond the axis. Reduced-form trend sensitivity alone is not a trend-robust IV interval. With several instruments, the simple scalar ratio is not a substitute for the estimator's moment conditions and weighting.
