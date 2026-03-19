# Calculate MID Importance (midnight extension)

This function wraps and masks
[`midr::mid.importance`](https://ryo-asashi.github.io/midr/reference/mid.importance.html)
to automatically attach the "midimp2" class, enabling extended plotting
capabilities.

## Usage

``` r
mid.importance(object, ...)
```

## Arguments

- object:

  a "mid" object.

## Value

`mid.importance()` returns an object of class "midimp". This is a list
containing the following components:

- importance:

  a data frame with the calculated importance values, sorted by default.

- predictions:

  the matrix of the fitted or predicted MID values. If the number of
  observations exceeds `max.nsamples`, this matrix contains a sampled
  subset.

- measure:

  a character string describing the type of the importance measure used.

For a "mids" collection object, `mid.importance()` returns a collection
object of class "midimps"-"midlist".

## Details

The MID importance of a component function \\g_S\\, where \\S\\
represents a single feature \\\\j\\\\ or a feature pair \\\\j, k\\\\, is
defined as the mean absolute effect on the predictions within the given
data:

\$\$\mathbf{I}(g_S) = \frac{1}{n} \sum\_{i=1}^n
\|g_S(\mathbf{x}\_{i,S})\|\$\$

Terms with higher importance values have a larger average impact on the
model's overall predictions. Because all components (main effects and
interactions) are measured on the same scale as the response variable,
these values provide a direct and comparable measure of each term's
contribution to the model.

## See also

[`ggmid.midimp2`](https://ryo-asashi.github.io/midnight/reference/ggmid.midimp2.md),
[`mid.importance`](https://ryo-asashi.github.io/midr/reference/mid.importance.html)

## Examples

``` r
data(airquality, package = "datasets")
mid <- interpret(Ozone ~ .^2, data = airquality, lambda = 1)
#> 'model' not passed: response variable in 'data' is used

# Calculate MID importance using median absolute contribution
imp <- mid.importance(mid, data = airquality)
print(imp)
#> 
#> MID Importance based on 153 Observations
#> 
#> Measure: Mean Absolute Contribution
#> 
#> Importance:
#>             term importance order
#> 1           Temp   13.87964     1
#> 2           Wind   10.33988     1
#> 3        Solar.R    5.02987     1
#> 4            Day    4.89338     1
#> 5          Month    2.15840     1
#> 6   Solar.R:Wind    0.45055     2
#> 7       Temp:Day    0.40191     2
#> 8       Wind:Day    0.38748     2
#> 9  Solar.R:Month    0.38573     2
#> 10    Wind:Month    0.38059     2
#> 11     Month:Day    0.31367     2
#> 12     Wind:Temp    0.29737     2
#> 13   Solar.R:Day    0.28360     2
#> 14  Solar.R:Temp    0.21667     2
#> 15    Temp:Month    0.14529     2

# Calculate MID importance using root mean square contribution
imp <- mid.importance(mid, measure = 2)
print(imp)
#> 
#> MID Importance based on 111 Observations
#> 
#> Measure: Root Mean Square Contribution
#> 
#> Importance:
#>             term importance order
#> 1           Temp   16.23318     1
#> 2           Wind   14.77135     1
#> 3        Solar.R    7.25789     1
#> 4            Day    5.69615     1
#> 5          Month    2.66095     1
#> 6     Wind:Month    0.56416     2
#> 7   Solar.R:Wind    0.55387     2
#> 8  Solar.R:Month    0.51838     2
#> 9       Wind:Day    0.51729     2
#> 10      Temp:Day    0.48825     2
#> 11     Month:Day    0.47409     2
#> 12     Wind:Temp    0.41887     2
#> 13   Solar.R:Day    0.32822     2
#> 14  Solar.R:Temp    0.30586     2
#> 15    Temp:Month    0.20071     2
```
