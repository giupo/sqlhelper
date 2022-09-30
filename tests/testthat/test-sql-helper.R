test_that("just for full coverage, ignore me", {
  expect_equal(.junk(), 0)
})

test_that("get_sql fails if config_path doesn't exists", {
  path <- "/non/esisto"
  expect_false(file.exists(path))
  expect_error(get_sql("A/B", config_path = path))
})

test_that("get_sql fails if keys arent slash-separated", {
  expect_error(get_sql("A-B"))
})

test_that("get_sql works with simple queries", {
  expect_error(sql <- get_sql("simple/SELECT_TEST0"), NA)
  expect_equal(sql, "select * from psql")

  expect_error(sql <- get_sql("simple/SELECT_TEST1"), NA)
  expect_equal(sql, "select * from pippo")
})


test_that("get_sql works with simple glue parametrized queries", {
  con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
  on.exit(DBI::dbDisconnect(con))
  expect_error(sql <- get_sql("glue/query", list(
    .con = con,
    name = c("A", "B")
  )), NA)
  expect_equal(as.character(sql), "select * from test where name in ('A', 'B')")

  expect_error(sql <- get_sql("simple/SELECT_TEST1"), NA)
  expect_equal(sql, "select * from pippo")
})

test_that("get_sql works with simple whisker parametrized queries", {
  expect_error(sql <- get_sql("whisker/query", list(
    name = "bubba"
  )), NA)
  expect_equal(as.character(sql), "select * from test where name = 'bubba'")
})


test_that("get_sql raise an error if no query is found", {
  expect_error(get_sql("NON/ESISTO"),
  "'NON/ESISTO' doesn't define a query in")
})

test_that("I can handle multiline queries", {
  expect_equal(get_sql("multi/line"), "select * from dual")
})

test_that("I can handle multiline arrays queries", {
  expect_equal(get_sql("multiline/array"), "select * from dual")
})


test_that("I trim down the query string", {
  expect_equal(get_sql("trim/down"), "select * from dual")
})

test_that("get_sql fails if params isn't a list", {
  expect_error(get_sql("trim/down", 1), "params must be a named list")
  expect_error(get_sql("trim/down", "ciao"), "params must be a named list")
})

test_that("get_sql fails if params isn't a named list", {
  expect_error(get_sql("trim/down", list(1, 2, 3)),
    "params must be a named list")
})
