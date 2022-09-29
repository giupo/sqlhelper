
#' Reads the config file where the SQL is stored
#'
#' @param config_path path to the file
#' @returns a `configr` representation of the TOML file

.read_config <- function(
    config_path = system.file("ini/sql.toml", package = "sqlhelper")) {
  stopifnot(file.exists(config_path))
  configr::read.config(config_path)
}

read_config <- memoise::memoise(.read_config)


#' Returns the SQL
#'
#' @param keys a slash separated key string (eg: "section/query")
#' @param params a named list with the params to substitue in the query
#' @param config_path path to the INI/TOML file where SQL is stored
#' @return a string containing the SQL query
#' @examples
#'   get_sql("simple/SELECT_TEST0")
#'   get_sql("whisker/query", list(name = "Dwayne"))
#' @export

get_sql <- function(keys, params = NULL,
  config_path = system.file("ini/sql.toml", package = "sqlhelper")) {
  ln <- "sqlhelper::get_sql"
  config <- read_config(config_path)

  if (!grepl("/", keys)) {
    stop("'/' missing in keys")
  }

  tokens <- unlist(stringr::str_split(keys, "/"))
  sql <- config
  while (length(tokens) != 0) {
    token <- tokens[[1]]
    sql <- sql[[token]]
    tokens <- tokens[-1]
  }

  if (length(sql) == 0 || all(nchar(sql) == 0)) {
    stop(glue::glue("'{keys}' doesn't define a query in {config_path}"))
  }

  if (length(sql) > 1) {
    sql <- paste(sql, collapse = " ")
  }
  # \patch to remove \\n from multilines values
  rutils::.trace("remove \\\\n from sql", name = ln)
  sql <- gsub("\\\\n", " ", sql)
  sql <- stringr::str_trim(sql)



  rutils::.debug("Query for %s: %s", keys, sql, name = ln)

  if (is.null(params)) {
    return(sql)
  }


  if (!is.list(params) || is.null(names(params))) {
    stop("params must be a named list")
  }

  sql <- whisker::whisker.render(sql, params)

  if (".con" %in% names(params)) {
    con <- params[[".con"]]
    params[[".con"]] <- NULL
    glue::glue_data_sql(sql, .x = params, .con = con)
  } else {
    sql
  }
}


.junk <- function() {
  memoise::memoise(function() {
    # damn you, R CMD check
  })
}
