# Changelog

## midnight 0.2.0

### New Features

- Introduced
  [`nightfall()`](https://ryo-asashi.github.io/midnight/reference/nightfall.md)
  and
  [`daybreak()`](https://ryo-asashi.github.io/midnight/reference/nightfall.md)
  to seamlessly toggle the package’s extended features, including
  dynamic S3 method registration, custom color themes, and
  high-performance OLS solvers.
- Added
  [`fastLmMatrix()`](https://ryo-asashi.github.io/midnight/reference/fastLmMatrix.md),
  an optimized wrapper around
  [`RcppEigen::fastLm()`](https://rdrr.io/pkg/RcppEigen/man/fastLm.html)
  that efficiently handles multivariate (matrix) responses.

### Minor Improvements

- Renamed and updated the `ggmid.midimp` wrapper to ensure perfect
  alignment with `midr` (\>= 0.6.0).
- Streamlined the package structure by significantly reducing hard
  dependencies (`Imports`).

## midnight 0.1.0

### Modeling Interfaces (tidymodels)

- Introduced
  [`mid_reg()`](https://ryo-asashi.github.io/midnight/reference/mid_reg.md)
  as the primary `parsnip` engine for MID models (formerly
  `mid_surrogate()`).
- Added underlying engine utilities (`make_mid_mid()`) and optimized
  `fit_mid_mid()` to improve memory efficiency.

### Visualizations & Themes

- Extended the `ggmid.mid.importance` method to support modern
  distribution plots: `"violin"`, `"beeswarm"`, and `"sinaplot"`.
- Added
  [`persp.mid()`](https://ryo-asashi.github.io/midnight/reference/persp.mid.md)
  for 3D perspective visualizations.
- Added custom aesthetic color themes: `"moon"` and `"moonlit"`.

### Documentation & Infrastructure

- Launched the official `pkgdown` website with custom favicons.
- Designed and added the package hex logo.
- Added comprehensive package-level documentation.
