# Curated FRED series catalogue and category browser.
#
# These functions provide offline discoverability for the most-used FRED
# series and the FRED category tree. No API call is required to read the
# catalogue or the top-level categories.


#' Browse a curated catalogue of popular FRED series
#'
#' Returns a data frame of around 50 of the most widely used FRED series
#' organised by economic category. The catalogue is curated and embedded in
#' the package: no API call is made. Use it as a starting point for common
#' workflows or as a quick reference when you cannot remember a series ID.
#'
#' Filter by category, by free-text query, or both. Free-text matches against
#' the series ID, title, and description (case-insensitive substring match).
#'
#' @param category Character. Optional category filter. One of `"GDP & Output"`,
#'   `"Employment"`, `"Inflation"`, `"Interest Rates"`, `"Housing"`,
#'   `"Financial"`, `"Money & Credit"`, `"Trade & FX"`, `"Consumer"`,
#'   `"Government & Fiscal"`. Multiple categories may be passed.
#' @param query Character. Optional free-text filter (e.g. `"unemployment"`,
#'   `"mortgage"`).
#'
#' @return A `fred_tbl` (a `data.frame` subclass) with columns `id`, `title`,
#'   `frequency`, `units`, `category`, `description`.
#'
#' @family catalogue
#' @export
#' @examples
#' # Full catalogue
#' fred_catalogue()
#'
#' # Inflation series only
#' fred_catalogue(category = "Inflation")
#'
#' # Free-text search
#' fred_catalogue(query = "mortgage")
#'
#' # Combined
#' fred_catalogue(category = "Interest Rates", query = "treasury")
fred_catalogue <- function(category = NULL, query = NULL) {
  cat <- .fred_catalogue_data()

  if (!is.null(category)) {
    if (!is.character(category)) {
      cli::cli_abort("{.arg category} must be a character vector.")
    }
    valid_cats <- unique(cat$category)
    bad <- setdiff(category, valid_cats)
    if (length(bad)) {
      cli::cli_abort(c(
        "Unknown {.arg category} value{?s}: {.val {bad}}.",
        "i" = "Valid values: {.val {valid_cats}}."
      ))
    }
    cat <- cat[cat$category %in% category, , drop = FALSE]
  }

  if (!is.null(query)) {
    if (!is.character(query) || length(query) != 1L) {
      cli::cli_abort("{.arg query} must be a single character string.")
    }
    pat <- tolower(query)
    matches <- grepl(pat, tolower(cat$id), fixed = TRUE) |
               grepl(pat, tolower(cat$title), fixed = TRUE) |
               grepl(pat, tolower(cat$description), fixed = TRUE)
    cat <- cat[matches, , drop = FALSE]
  }

  rownames(cat) <- NULL
  new_fred_tbl(cat, query = list(
    endpoint = "catalogue",
    catalogue_filter = list(category = category, query = query)
  ))
}


#' Browse the FRED category tree
#'
#' Pretty-prints the FRED category tree. With no arguments, shows the eight
#' top-level FRED categories from a built-in static reference (no API call).
#' Pass a `category_id` to drill into its children, which fetches from the API
#' (and is cached). Use this to discover where series live before searching
#' inside a category with [fred_category_series()].
#'
#' @param category_id Integer. Category to browse. Default `0` (root). The
#'   root prints from a static reference and does not call the API.
#' @param depth Integer. How many levels deep to recurse. Default `1` (only
#'   immediate children). Higher values trigger one API call per parent
#'   category visited.
#'
#' @return A `fred_tbl` of categories at the requested level (invisibly).
#'
#' @family catalogue
#' @export
#' @examples
#' \donttest{
#' # Top-level categories (no API call)
#' fred_browse()
#'
#' op <- options(fred.cache_dir = tempdir())
#' # Drill into "National Accounts" (id 32992)
#' fred_browse(32992)
#' options(op)
#' }
fred_browse <- function(category_id = 0L, depth = 1L) {
  category_id <- as.integer(category_id)
  depth <- as.integer(depth)
  if (length(category_id) != 1L || is.na(category_id)) {
    cli::cli_abort("{.arg category_id} must be a single integer.")
  }
  if (length(depth) != 1L || is.na(depth) || depth < 1L) {
    cli::cli_abort("{.arg depth} must be a positive integer.")
  }

  if (category_id == 0L) {
    cats <- .fred_top_categories()
    cat("FRED top-level categories\n")
    cat("-------------------------\n")
    for (i in seq_len(nrow(cats))) {
      cat(sprintf("  %6d  %s\n", cats$id[i], cats$name[i]))
    }
    cat("\nUse fred_browse(id) to drill into a category.\n")
    return(invisible(new_fred_tbl(cats, query = list(
      endpoint = "browse", category_id = 0L
    ))))
  }

  children <- fred_category_children(category_id)
  if (nrow(children) == 0L) {
    cli::cli_inform("Category {.val {category_id}} has no children.")
    return(invisible(new_fred_tbl(children, query = list(
      endpoint = "browse", category_id = category_id
    ))))
  }

  cat(sprintf("FRED category %d children\n", category_id))
  cat("------------------------\n")
  .print_browse_node(children, depth = depth, indent = 0L)

  invisible(new_fred_tbl(children, query = list(
    endpoint = "browse", category_id = category_id, depth = depth
  )))
}


#' @noRd
.print_browse_node <- function(children, depth, indent) {
  pad <- strrep("  ", indent)
  for (i in seq_len(nrow(children))) {
    cid <- as.integer(children$id[i])
    name <- children$name[i]
    cat(sprintf("%s%6d  %s\n", pad, cid, name))
    if (depth > 1L) {
      sub <- tryCatch(
        fred_category_children(cid),
        error = function(e) NULL
      )
      if (!is.null(sub) && nrow(sub) > 0L) {
        .print_browse_node(sub, depth = depth - 1L, indent = indent + 1L)
      }
    }
  }
  invisible(NULL)
}


#' Static FRED top-level category reference
#'
#' Eight top-level categories as documented at
#' https://fred.stlouisfed.org/categories. Embedded so `fred_browse()` works
#' offline.
#' @noRd
.fred_top_categories <- function() {
  data.frame(
    id = c(32991L, 10L, 32992L, 1L, 32455L, 32263L, 3008L, 33060L),
    name = c("Money, Banking, & Finance",
             "Population, Employment, & Labor Markets",
             "National Accounts",
             "Production & Business Activity",
             "Prices",
             "International Data",
             "U.S. Regional Data",
             "Academic Data"),
    stringsAsFactors = FALSE
  )
}


#' Curated catalogue of around 50 widely used FRED series
#'
#' Embedded reference of the most-used FRED series across ten economic
#' categories. Updated when meaningfully changed; not auto-synced with FRED.
#' @noRd
.fred_catalogue_data <- function() {
  rows <- list(
    # GDP & Output
    list("GDP",        "Gross Domestic Product",                     "Q", "Bil. of $",      "GDP & Output",        "Headline nominal GDP, BEA NIPA"),
    list("GDPC1",      "Real Gross Domestic Product",                "Q", "Bil. chained $", "GDP & Output",        "Real GDP, chained 2017 dollars"),
    list("GDPPOT",     "Real Potential Gross Domestic Product",      "Q", "Bil. chained $", "GDP & Output",        "CBO estimate of potential output"),
    list("GDPDEF",     "GDP Implicit Price Deflator",                "Q", "Index 2017=100", "GDP & Output",        "Broad inflation measure from NIPA"),
    list("INDPRO",     "Industrial Production: Total Index",         "M", "Index 2017=100", "GDP & Output",        "Federal Reserve industrial production"),
    list("CUMFNS",     "Capacity Utilization: Manufacturing",        "M", "Percent",        "GDP & Output",        "Federal Reserve capacity utilisation"),

    # Employment
    list("UNRATE",     "Unemployment Rate",                          "M", "Percent",        "Employment",          "BLS headline U-3 unemployment rate"),
    list("PAYEMS",     "Total Nonfarm Payrolls",                     "M", "Thousands",      "Employment",          "BLS Establishment Survey"),
    list("CIVPART",    "Labor Force Participation Rate",             "M", "Percent",        "Employment",          "BLS labour force participation"),
    list("EMRATIO",    "Employment-Population Ratio",                "M", "Percent",        "Employment",          "BLS employment to population ratio"),
    list("ICSA",       "Initial Claims",                             "W", "Number",         "Employment",          "Weekly initial unemployment insurance claims"),
    list("JTSJOL",     "Job Openings: Total Nonfarm",                "M", "Thousands",      "Employment",          "JOLTS job openings"),
    list("AHETPI",     "Average Hourly Earnings of Production Workers","M","Dollars/hr",    "Employment",          "BLS production and nonsupervisory wages"),

    # Inflation
    list("CPIAUCSL",   "CPI for All Urban Consumers: All Items",     "M", "Index 1982-84=100","Inflation",         "BLS headline CPI, seasonally adjusted"),
    list("CPILFESL",   "CPI for All Urban Consumers: Less Food and Energy","M","Index 1982-84=100","Inflation",   "BLS core CPI"),
    list("PCEPI",      "Personal Consumption Expenditures: Chain-type Price Index","M","Index 2017=100","Inflation","BEA headline PCE deflator"),
    list("PCEPILFE",   "PCE Excluding Food and Energy: Chain-type Price Index","M","Index 2017=100","Inflation",   "BEA core PCE deflator (Fed target)"),
    list("PPIACO",     "Producer Price Index by Commodity: All Commodities","M","Index 1982=100","Inflation",      "BLS PPI all commodities"),
    list("T10YIE",     "10-Year Breakeven Inflation Rate",           "D", "Percent",        "Inflation",           "Market-implied 10y inflation expectations"),

    # Interest Rates
    list("FEDFUNDS",   "Effective Federal Funds Rate",               "M", "Percent",        "Interest Rates",      "Monthly average effective fed funds rate"),
    list("DFF",        "Federal Funds Effective Rate",               "D", "Percent",        "Interest Rates",      "Daily effective fed funds rate"),
    list("DGS2",       "Market Yield on 2-Year Treasury",            "D", "Percent",        "Interest Rates",      "Constant-maturity 2y Treasury yield"),
    list("DGS10",      "Market Yield on 10-Year Treasury",           "D", "Percent",        "Interest Rates",      "Constant-maturity 10y Treasury yield"),
    list("DGS30",      "Market Yield on 30-Year Treasury",           "D", "Percent",        "Interest Rates",      "Constant-maturity 30y Treasury yield"),
    list("T10Y2Y",     "10-Year Treasury Constant Maturity Minus 2-Year","D","Percent",     "Interest Rates",      "Yield-curve slope, classic recession indicator"),
    list("MORTGAGE30US","30-Year Fixed Rate Mortgage Average",       "W", "Percent",        "Interest Rates",      "Freddie Mac PMMS 30y mortgage rate"),

    # Housing
    list("CSUSHPISA",  "S&P CoreLogic Case-Shiller National Home Price Index","M","Index Jan 2000=100","Housing",  "National house price index"),
    list("HOUST",      "Housing Starts: Total New Privately Owned",  "M", "Thousands",      "Housing",             "Census housing starts"),
    list("PERMIT",     "New Privately Owned Housing Units Authorized","M","Thousands",      "Housing",             "Census building permits"),
    list("EXHOSLUSM495S","Existing Home Sales",                      "M", "Number",         "Housing",             "NAR existing home sales"),

    # Financial
    list("SP500",      "S&P 500",                                    "D", "Index",          "Financial",           "S&P 500 closing price"),
    list("VIXCLS",     "CBOE Volatility Index: VIX",                 "D", "Index",          "Financial",           "Implied volatility on S&P 500 options"),
    list("NASDAQCOM",  "NASDAQ Composite Index",                     "D", "Index",          "Financial",           "NASDAQ closing price"),
    list("NFCI",       "Chicago Fed National Financial Conditions Index","W","Index",       "Financial",           "Broad financial conditions, zero-mean"),
    list("STLFSI4",    "St. Louis Fed Financial Stress Index",       "W", "Index",          "Financial",           "Composite financial stress, zero-mean"),

    # Money & Credit
    list("M2SL",       "M2",                                         "M", "Bil. of $",      "Money & Credit",      "Broad money stock"),
    list("TOTALSL",    "Total Consumer Credit Owned and Securitized","M","Bil. of $",       "Money & Credit",      "G.19 consumer credit total"),
    list("BUSLOANS",   "Commercial and Industrial Loans, All Commercial Banks","M","Bil. of $","Money & Credit",   "C&I bank lending"),

    # Trade & FX
    list("BOPGSTB",    "Trade Balance: Goods and Services",          "M", "Mil. of $",      "Trade & FX",          "BEA monthly trade balance"),
    list("DEXUSEU",    "U.S. Dollars to Euro Spot Exchange Rate",    "D", "USD per EUR",    "Trade & FX",          "Daily noon-buying USD/EUR"),
    list("DEXUSUK",    "U.S. Dollars to U.K. Pound Spot Exchange Rate","D","USD per GBP",   "Trade & FX",          "Daily noon-buying USD/GBP"),
    list("DTWEXBGS",   "Nominal Broad U.S. Dollar Index",            "D", "Index Jan 2006=100","Trade & FX",       "Federal Reserve broad trade-weighted USD"),
    list("DCOILWTICO", "Crude Oil Prices: West Texas Intermediate",  "D", "USD per barrel", "Trade & FX",          "WTI spot price"),

    # Consumer
    list("PCE",        "Personal Consumption Expenditures",          "M", "Bil. of $",      "Consumer",            "Headline nominal PCE"),
    list("RSAFS",      "Advance Retail Sales: Retail and Food Services","M","Mil. of $",    "Consumer",            "Census retail sales advance estimate"),
    list("UMCSENT",    "University of Michigan: Consumer Sentiment", "M", "Index 1966=100", "Consumer",            "Michigan consumer sentiment headline"),
    list("PI",         "Personal Income",                            "M", "Bil. of $",      "Consumer",            "BEA personal income"),

    # Government & Fiscal
    list("GFDEBTN",    "Federal Debt: Total Public Debt",            "Q", "Mil. of $",      "Government & Fiscal", "Treasury total public debt outstanding"),
    list("GFDEGDQ188S","Federal Debt: Total Public Debt as % of GDP","Q","Percent",         "Government & Fiscal", "Debt-to-GDP ratio"),
    list("FYFSGDA188S","Federal Surplus or Deficit as % of GDP",     "A", "Percent",        "Government & Fiscal", "Annual fiscal balance share of GDP"),
    list("DGS3MO",     "3-Month Treasury Constant Maturity Rate",    "D", "Percent",        "Interest Rates",      "Constant-maturity 3-month Treasury yield")
  )

  out <- do.call(rbind, lapply(rows, function(r) {
    data.frame(id = r[[1]], title = r[[2]], frequency = r[[3]],
               units = r[[4]], category = r[[5]], description = r[[6]],
               stringsAsFactors = FALSE)
  }))
  rownames(out) <- NULL
  out
}
