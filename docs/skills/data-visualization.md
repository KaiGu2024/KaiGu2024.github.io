# Agent Skill: Data Visualization

Principles and code patterns for publication-ready figures in Python.

Reference: [Fundamentals of Data Visualization — Claus O. Wilke](https://clauswilke.com/dataviz/)

---

## Core Principles

1. **Choose the right chart type** for the data relationship (see guide below)
2. **Label directly** — avoid legends when possible; annotate points/lines
3. **Use color purposefully** — categorical vs. sequential vs. diverging palettes
4. **Show uncertainty** — always include confidence intervals or error bars
5. **Maximize data-ink ratio** — remove gridlines, borders, and tick marks that add no information

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

## Matplotlib / Seaborn Setup

```python
import matplotlib.pyplot as plt
import seaborn as sns

# Publication style
plt.rcParams.update({
    "font.family":      "serif",
    "font.size":        11,
    "axes.spines.top":  False,
    "axes.spines.right":False,
    "axes.grid":        True,
    "grid.alpha":       0.3,
    "figure.dpi":       150,
})
sns.set_palette("colorblind")  # accessible palette
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
ax.axvline(-0.5, color="red", ls="--", lw=0.8, label="Event")
ax.fill_between(periods, lo, hi, alpha=0.2)
ax.plot(periods, coefs, "o-", ms=5)
ax.set_xlabel("Periods relative to treatment")
ax.set_ylabel("Estimated effect")
ax.legend(frameon=False)
fig.tight_layout()
fig.savefig("event_study.pdf", bbox_inches="tight")
```

---

## Distribution Comparisons

```python
# Ridge plot (stacked densities)
import matplotlib.pyplot as plt
from scipy.stats import gaussian_kde
import numpy as np

groups = df["group"].unique()
fig, axes = plt.subplots(len(groups), 1, figsize=(6, len(groups) * 1.2), sharex=True)
for ax, g in zip(axes, groups):
    x = df.loc[df["group"] == g, "value"]
    xs = np.linspace(x.min(), x.max(), 200)
    ax.fill_between(xs, gaussian_kde(x)(xs), alpha=0.6)
    ax.set_yticks([]); ax.set_ylabel(g, rotation=0, ha="right")
fig.tight_layout(h_pad=-0.5)
```

---

## Color Palettes

```python
# Categorical (colorblind-safe)
import seaborn as sns
palette = sns.color_palette("colorblind")

# Sequential (single hue, low→high)
cmap = plt.cm.Blues

# Diverging (centered at zero)
cmap = plt.cm.RdBu_r

# Named Anthropic-esque warm palette
WARM = ["#c96442", "#e8b89a", "#1a1a1a", "#7a706b", "#e6ddd6"]
```

---

## Saving for Publication

```python
# PDF (vector, for LaTeX)
fig.savefig("figure.pdf", bbox_inches="tight")

# PNG (raster, for slides — 300 dpi)
fig.savefig("figure.png", bbox_inches="tight", dpi=300)

# Both at once
for ext in ["pdf", "png"]:
    fig.savefig(f"figure.{ext}", bbox_inches="tight", dpi=300)
```
