
# sqlhelper

<!-- badges: start -->
[![R-CMD-check](https://github.com/giupo/sqlhelper/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/giupo/sqlhelper/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of sqlhelper is to provide a store for sql statemens and
retrieval by key in a key-value store (based on TOML files)

## Installation

You can install the development version of sqlhelper like so:git s

``` r
devtools::install_github("giupo/sqlhelper")
```

## Example

I hate SQL in R packages and files. I hate SQL strings embedded in my code, any code.
What could I do for it? Store it somewhere (an INI or a TOML file) and use a function
to retrieve like a key/value store the sql.

For instance, having a file like the following:

```ini
[section]
query = select * from dual
```

and in your code you can do:

``` r
my_get_sql <- function(...) {
  sqlhelper::get_sql(..., config_path = "/path to your SQL")
}
```

Or even better:

```r
my_get_sql <- function(...) {
  sqlhelper::get_sql(..., config_path = system.file("path", package="yourpackge"))
}
```

This will let you develop your code like :

```r

neat_function_using_sql <- function(bla, bla, bla) {
  con <- ...
  sql <- my_get_sql("sectin/query", list(
    param1 = "hello",
    param2 = "world",
    con = con
  ))

  DBI::dbGetQuery(con, sql)
}
```
