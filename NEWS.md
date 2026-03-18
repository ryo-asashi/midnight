# midnight (development version) 0.1.1.90x

- Added `mixup()` for creating synthetic data using Mixup algorithm.
- Reduced dependencies to other packages.
- Added `fastLmMatrix()`, a wrapper function of `RcppEigen::fastLm()` supporting matrix responses.
- Renamed and Updated the `ggmid.midimp` wrapper (for better alignment with **midr** 0.6.0).

# midnight 0.1.0

- Added wrapper method for `ggmid.mid.importance` with new types: "violin", "beeswarm", "sinaplot".
- Renamed main functions (from `mid_surrogate()` to `mid_reg()`).
- Added `persp.mid()`.
- Added the "moon" and "moonlit" color themes
- Added the package document.
- Updated wrapper fit function `fit_mid_mid()` to improve memory efficiency.
- Opened pkgdown website and added favicons.
- Added `mid_surrogate()` and `make_mid_mid()`.
- Created the package hex logo.
