# Set the FRED API key

Sets the API key used to authenticate requests to the FRED API. The key
persists for the current R session. Alternatively, set the
`FRED_API_KEY` environment variable in your `.Renviron` file.

## Usage

``` r
fred_set_key(key)
```

## Arguments

- key:

  Character. A 32-character FRED API key.

## Value

Invisible `NULL`.

## Details

Register for a free API key at
<https://fredaccount.stlouisfed.org/apikeys>.

## Examples

``` r
if (FALSE) { # \dontrun{
fred_set_key("your_api_key_here")
} # }
```
