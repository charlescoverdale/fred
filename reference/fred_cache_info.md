# Inspect the local fred cache

Returns information about the local cache: where it lives, how many
files it contains, and how much disk space they take. Useful when
debugging stale results or deciding whether to call
[`clear_cache()`](https://charlescoverdale.github.io/fred/reference/clear_cache.md).

## Usage

``` r
fred_cache_info()
```

## Value

A list with elements `dir`, `n_files`, `size_bytes`, `size_human`, and
`files` (a data frame with `name`, `size_bytes`, and `modified`
columns). Returns the same shape with zero counts if the cache directory
does not yet exist.

## See also

Other configuration:
[`clear_cache()`](https://charlescoverdale.github.io/fred/reference/clear_cache.md),
[`fred_get_key()`](https://charlescoverdale.github.io/fred/reference/fred_get_key.md),
[`fred_request()`](https://charlescoverdale.github.io/fred/reference/fred_request.md),
[`fred_set_key()`](https://charlescoverdale.github.io/fred/reference/fred_set_key.md)

## Examples

``` r
# \donttest{
op <- options(fred.cache_dir = tempdir())
fred_cache_info()
#> $dir
#> [1] "/tmp/RtmpTpOvVy"
#> 
#> $n_files
#> [1] 1
#> 
#> $size_bytes
#> [1] 4096
#> 
#> $size_human
#> [1] "4.0 MB"
#> 
#> $files
#>      name size_bytes            modified
#> 1 downlit       4096 2026-04-26 12:57:06
#> 
options(op)
# }
```
