% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sqlhellper.r
\name{.read_config}
\alias{.read_config}
\title{Reads the config file where the SQL is stored}
\usage{
.read_config(config_path = system.file("ini/sql.toml", package = "sqlhelper"))
}
\arguments{
\item{config_path}{path to the file}
}
\value{
a \code{configr} representation of the TOML file
}
\description{
Reads the config file where the SQL is stored
}
