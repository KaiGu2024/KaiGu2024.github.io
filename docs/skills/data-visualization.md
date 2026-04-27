# Agent Skill: Data Visualization

Principles and code patterns for publication-ready figures in Python.

References: [Data Visualization: A Practical Introduction — Kieran Healy](https://socviz.co/) · [Lecture Slides — Yiqing Xu](https://yiqingxu.org/teachings/resources/data_visual.pdf)

---

## Core Principles

1. **Choose the right chart type** for the data relationship (see guide below)
2. **Label directly** — annotate lines/points in place; never add a separate legend box
3. **Use color purposefully** — categorical vs. sequential vs. diverging; always colorblind-safe
4. **Show uncertainty** — always include confidence intervals or error bars
5. **Maximize data-ink ratio** — remove gridlines, borders, and tick marks that add no information
6. **Y-axis starts at baseline** — always begin at 0 (or 100% for indexed series); a truncated axis exaggerates effects

---

## Personal Figure Standards

These rules apply to all figures produced for research:

1. **Y-axis baseline**: Start at 0 (or 100 for indexed/normalized series). Only deviate if the entire range of the data is far from zero AND the deviation within the data is the primary story — and always disclose this explicitly.

2. **Direct annotation, no legends**: Label each line or group at its endpoint or most legible point along the curve. A legend box forces the reader's eye to travel; annotation keeps meaning at the data.

3. **High DPI**: Set `figure.dpi=600` for all final exports. This is the Science/Nature minimum for revised manuscript submission.

4. **Enlarged fonts for high DPI**: At 600 DPI, default matplotlib font sizes (8–10pt) render too small in print. Use:
   - Axis labels: 13–14 pt
   - Tick labels: 11–12 pt
   - Inline annotations: 10–11 pt
   - Panel title (if needed): 14–16 pt

---

## Chart Type Guide

| Relationship | Chart |
|---|---|
| Distribution (one var) | Histogram, density, violin |
| Distribution (compare groups) | Ridge plot, overlaid density |
| Two continuous vars | Scatter, hexbin (large N) |
| Category vs. continuous | Bar (mean ± CI), strip + box |
| Time series | Line with shaded CI |
| Correlation matrix | Heatmap |
| Causal estimate | Coefficient plot (dot + CI) |
| Geographic | Choropleth |

---

## Matplotlib / Seaborn Setup (600 DPI Standard)

```python
import matplotlib.pyplot as plt
import seaborn as sns

plt.rcParams.update({
    # Font
    "font.family":       "sans-serif",
    "font.sans-serif":   ["Helvetica", "Arial", "DejaVu Sans"],
    "font.size":         13,          # base — tick labels
    "axes.labelsize":    14,          # axis labels
    "axes.titlesize":    15,
    "xtick.labelsize":   12,
    "ytick.labelsize":   12,
    # Layout
    "axes.spines.top":   False,
    "axes.spines.right": False,
    "axes.grid":         True,
    "grid.alpha":        0.25,
    "grid.linewidth":    0.6,
    # Resolution
    "figure.dpi":        600,
    "savefig.dpi":       600,
    "savefig.bbox":      "tight",
})
sns.set_palette("colorblind")  # Okabe-Ito colorblind-safe palette
```

---

## Direct Line Annotation (no legend)

```python
import matplotlib.pyplot as plt
import numpy as np

fig, ax = plt.subplots(figsize=(7, 4))

for label, ys, color in zip(groups, series, palette):
    ax.plot(xs, ys, color=color, lw=1.8)
    # Annotate at the last point
    ax.text(
        xs[-1] + 0.2, ys[-1],
        label,
        color=color,
        fontsize=11,
        va="center",
    )

ax.set_xlabel("Year")
ax.set_ylabel("Outcome (%)")
ax.yaxis.set_major_formatter(plt.FuncFormatter(lambda y, _: f"{y:.0f}%"))
# No ax.legend() call
fig.tight_layout()
fig.savefig("figure.pdf")
```

---

## Coefficient / Event-Study Plot

```python
import numpy as np

fig, ax = plt.subplots(figsize=(7, 4))
periods = np.arange(-4, 5)
coefs   = [...]   # point estimates
lo, hi  = [...], [...]  # 95% CI bounds

ax.axhline(0, color="black", lw=0.8)
ax.axvline(-0.5, color="red", ls="--", lw=0.8)
ax.text(-0.5 + 0.1, ax.get_ylim()[1] * 0.95, "Event", color="red", fontsize=10)
ax.fill_between(periods, lo, hi, alpha=0.18)
ax.plot(periods, coefs, "o-", ms=5, lw=1.8)
ax.set_xlabel("Periods relative to treatment")
ax.set_ylabel("Estimated effect")
fig.tight_layout()
fig.savefig("event_study.pdf")
```

---

## Distribution Comparisons

```python
# Ridge plot (stacked densities)
from scipy.stats import gaussian_kde
import numpy as np

groups = df["group"].unique()
fig, axes = plt.subplots(len(groups), 1, figsize=(6, len(groups) * 1.2), sharex=True)
for ax, g in zip(axes, groups):
    x = df.loc[df["group"] == g, "value"]
    xs = np.linspace(x.min(), x.max(), 200)
    ax.fill_between(xs, gaussian_kde(x)(xs), alpha=0.6)
    ax.set_yticks([])
    ax.set_ylabel(g, rotation=0, ha="right", fontsize=12)
fig.tight_layout(h_pad=-0.5)
```

---

## Color Palettes

```python
# Categorical colorblind-safe (Okabe-Ito)
import seaborn as sns
palette = sns.color_palette("colorblind")   # 8-color Okabe-Ito

# Sequential (single hue)
cmap = plt.cm.Blues                         # or "viridis" for perceptual uniformity

# Diverging (centered at zero)
cmap = plt.cm.RdBu_r

# Warm accent palette (Anthropic-style)
WARM = ["#c96442", "#e8b89a", "#1a1a1a", "#7a706b", "#e6ddd6"]
```

**Colorblind test**: Check every figure with [Color Oracle](https://colororacle.org/) or `plt.cm.gray` before submission.

---

## Journal Standards Reference

From *Science* (AAAS) revised manuscript guidelines:
- **DPI**: 300–600 minimum; vector formats (PDF, EPS, AI) preferred
- **Font**: Sans-serif only (Helvetica / Arial); no Symbol fonts
- **Label size**: 7–8 pt in the *final printed figure* — scale up proportionally for high-DPI exports
- **Line weight**: Avoid hairlines; minimum ~0.5 pt; prefer 1 pt for data lines
- **Direct annotation preferred**: "Remove unnecessary labels from the figure itself; explain in the caption"
- **Panel labels**: uppercase A, B, C at upper-left; 10–12 pt bold

From *Marketing Science* / *Management Science* (INFORMS):
- **DPI**: 300 minimum for photos; supply graphs as vector if possible
- **Grayscale test**: Figures publish in color online but must convert cleanly to B&W for print; use line-style variation (solid, dashed, dotted) in addition to color
- **Colorblind palette**: Okabe-Ito (categorical) or Viridis family (sequential/diverging)

---

## Saving for Publication

```python
# PDF (vector — for LaTeX, preferred by journals)
fig.savefig("figure.pdf", bbox_inches="tight")

# TIFF / PNG at 600 DPI (for journal submission portals)
fig.savefig("figure.tiff", bbox_inches="tight", dpi=600)
fig.savefig("figure.png",  bbox_inches="tight", dpi=600)

# Both at once
for ext in ["pdf", "png", "tiff"]:
    fig.savefig(f"figure.{ext}", bbox_inches="tight", dpi=600)
```

---

## Report

See [Report format](report.md).

**Definition (measure):** Figures produced (count, types, output paths); format and DPI; whether colorblind check was run.  
**Analyses:** Chart types chosen and rationale; annotation strategy (direct vs. legend); journal standard compliance (DPI, font, line weight).  
**Takeaway:** Visual message conveyed; any deviations from personal figure standards or journal requirements that require human sign-off.
