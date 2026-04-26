# Plot a fred_tbl

Time-series plot for a `fred_tbl`. Detects long or wide format, draws
one line per series, and optionally shades NBER recession periods. Uses
base graphics so no extra dependencies are pulled in.

## Usage

``` r
# S3 method for class 'fred_tbl'
plot(
  x,
  recessions = TRUE,
  legend = TRUE,
  col = NULL,
  type = "l",
  main = NULL,
  xlab = "",
  ylab = "value",
  ...
)
```

## Arguments

- x:

  A `fred_tbl`.

- recessions:

  Logical. If `TRUE` (default), shade NBER recession periods that
  overlap the plotted date range.

- legend:

  Logical. If `TRUE` (default) and there are multiple series, add a
  top-left legend.

- col:

  Character. Optional vector of colours, one per series. Default uses a
  fixed six-colour qualitative palette, or HCL colours for \>6 series.

- type:

  Character. Plot type, passed to
  [`graphics::lines()`](https://rdrr.io/r/graphics/lines.html). Default
  `"l"` (line).

- main, xlab, ylab:

  Plot labels. Sensible defaults are inferred.

- ...:

  Other arguments passed to the initial
  [`graphics::plot()`](https://rdrr.io/r/graphics/plot.default.html)
  call.

## Value

`x`, invisibly.

## Details

For long-format input (`date`, `series_id`, `value`), one line per
`series_id`. For wide-format input (`date` plus one numeric column per
series), one line per numeric column.

## Examples

``` r
# \donttest{
op <- options(fred.cache_dir = tempdir())
if (FALSE) { # \dontrun{
  gdp <- fred_series("GDPC1", from = "2000-01-01")
  plot(gdp)

  panel <- fred_series(c("UNRATE", "CIVPART"), from = "2000-01-01",
                       format = "wide")
  plot(panel)
} # }
options(op)
# }
```
