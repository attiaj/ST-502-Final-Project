# Murder in Los Angeles: A Statistical Analysis of Crime Data from 2020 to 2024

**ST 502 Final Project — Jacob Attia, Zoe King, Zach Wiebe**

## Overview

This project investigates the characteristics of homicide victims in Los Angeles using crime data from 2020 to 2024, sourced from the [LA City Open Data Portal](https://data.lacity.org/Public-Safety/Crime-Data-from-2020-to-2024/2nrs-mtv8). We focus exclusively on cases labeled criminal homicide (crime code 110), analyzing victim age, sex, ethnicity, geographic location, and reporting delay.

The central question is: **what demographic and geographic characteristics are associated with disproportionate homicide victimization in LA?**

We address this through two complementary approaches:
- **Parameter estimation** — fitting a Gamma distribution to victim age via MLE and Bayesian inference
- **Hypothesis testing** — proportion tests, chi-squared tests, and Fisher's exact test to assess demographic disparities

---

## Data

**`Crime_Data.RData`** — A trimmed subset of the LA crime dataset filtered to criminal homicide cases (n = 1,568). Contains the following variables:

| Variable | Description |
|---|---|
| `AreaCode` | Numeric LAPD division code |
| `AreaName` | Name of LAPD division (21 areas) |
| `VictAge` | Victim age in years (0 = unknown) |
| `VictSex` | Victim sex: M, F, X (unknown) |
| `VictDescent` | Victim ethnicity (coded: H = Hispanic, B = Black, W = White, etc.) |
| `Days Between Report and Occurrence` | Days elapsed between the homicide and when it was reported |

---

## Code Files

### `AgeFitWiebe.R`
Fits a Gamma distribution to victim age using manually derived MLE estimators. Produces a histogram with the fitted density overlaid and runs a chi-squared goodness of fit test to assess the distributional assumption.

### `TimeFitWiebe.R`
Fits an Exponential distribution to the reporting delay variable (`Days Between Report and Occurrence`). Derives the MLE for the rate parameter and assesses fit via chi-squared test.

### `TimeVsSexWiebe.R`
Tests whether reporting delay differs by victim sex using Fisher's exact test. Constructs a 2×2 contingency table (Male/Female × Fast/Slow reporting) and reports the p-value.

### `zoes_code.R`
Comprehensive hypothesis testing across demographic variables:
- Chi-squared test comparing victim descent proportions to LA Census demographics
- ANOVA-based tests for whether victim age differs by sex, descent, and area
- Z-test for proportions testing whether P(victim is female) = 0.5
- Chi-squared test for independence between ethnicity and reporting speed

### MLE and Bayesian Estimation (Jacob — see report appendix)
- Fits a Gamma distribution to victim age using `fitdistrplus`
- Derives MLEs analytically for shape (α) and rate (β) parameters
- Implements Metropolis-Hastings MCMC from scratch to sample the joint posterior p(α, β | x)
- Compares posterior means and 95% credible intervals to MLE estimates
- Produces trace plots and goodness of fit diagnostics (Q-Q, CDF, P-P plots)

---

## Report

**`main.tex`** — Full project report in LaTeX. Compile with pdflatex. Requires the following image files in the same directory:

| File | Description |
|---|---|
| `agenormalgamma.png` | Histogram with Normal and Gamma density fits overlaid |
| `qqplot.png` | Q-Q plot of victim age vs fitted Gamma |
| `cdfplot.png` | Empirical vs theoretical CDF |
| `ppplot.png` | P-P plot |
| `victbysex.png` | Bar chart of victim counts by sex |
| `lademog.png` | Side-by-side LA demographics vs victim descent proportions |
| `expprops.png` | Expected murder proportions by area (based on physical size) |
| `realprop.png` | Actual murder proportions by area |
| `123342.png` | Per-area proportion test results |
| `area map.png` | Map of LA precincts color-coded by over/underrepresentation |

**`502_Poster.pptx`** — Presentation poster summarizing the project findings.

---

## Key Findings

- Victim age follows an approximate Gamma distribution with MLE estimates α̂ = 6.35, β̂ = 0.17, implying a mean age of ~37.4 years
- Bayesian estimation via Metropolis-Hastings confirms these estimates with 95% credible intervals (5.92, 6.81) for α and (0.158, 0.182) for β
- Women are significantly underrepresented among homicide victims relative to their share of the LA population
- Black residents are significantly overrepresented as victims; Asian, White, and Other groups are underrepresented; Hispanic victimization is proportional to population share
- Murders are concentrated in central and southern precincts (Central, Rampart, 77th Street, Newton, Southeast, Olympic) well beyond what their physical area would predict
- Female victims are reported significantly more slowly than male victims (Fisher's exact p = 0.004); reporting speed also varies significantly by ethnicity

---

## Dependencies

**R packages required:**
```r
library(tidyverse)
library(fitdistrplus)
```

---

## References

- City of Los Angeles Data. (2020). Crime Data from 2020 to 2024. lacity.org
- LAPD Divisions. Los Angeles Geohub. geohub.lacity.org
- U.S. Census Bureau. (2024). QuickFacts: Los Angeles city, California.
