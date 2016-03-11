context("Generate correct gather function call")

testData <- data.frame(ID = 1:5,
                       A = 6:10,
                       B = 11:15)

test_that("Correctly returns an executable gather function call", {

  call <- buildGather("testData",
                      key = "Column",
                      value = "Obs",
                      cols = c("A", "B"),
                      na.rm = TRUE)

  expect_equal(call,
               "tidyr::gather(data = testData, key = Column, value = Obs, na.rm = TRUE, A, B)")

  callOut <- try(eval(parse(text = call)), silent = TRUE)

  expect_false(class(callOut) == "try-error")

  expectedOut <- data.frame(ID = 1:5,
                            Column = rep(c("A", "B"), each = 5),
                            Obs = 6:15,
                            stringsAsFactors = FALSE)

  expect_equal(callOut, expectedOut)

  })


test_that("If no columns are selected a valid function call is returned", {


  expect_warning(buildGather("testData",
                             key = "Column",
                             value = "Obs",
                             cols = NULL,
                             na.rm = TRUE), "No columns selected")

  call <- suppressWarnings(buildGather("testData",
                                       key = "Column",
                                       value = "Obs",
                                       cols = NULL,
                                       na.rm = TRUE))

  expect_equal(call,
               "tidyr::gather(data = testData, key = Column, value = Obs, na.rm = TRUE)")

  callOut <- try(eval(parse(text = call)), silent = TRUE)

  expect_false(class(callOut) == "try-error")

  expectedOut <- data.frame(Column = rep(c("ID", "A", "B"), each = 5),
                            Obs = 1:15,
                            stringsAsFactors = FALSE)

  expect_equal(callOut, expectedOut)

  })


testNA <- data.frame(ID = 1:5,
                       A = c(NA, 7:10),
                       B = c(11:14, NA))

test_that("Missing values are correctly removed", {

  call <- buildGather("testNA",
                      key = "Column",
                      value = "Obs",
                      cols = c("A", "B"),
                      na.rm = TRUE)

  expect_equal(call,
               "tidyr::gather(data = testNA, key = Column, value = Obs, na.rm = TRUE, A, B)")

  callOut <- try(eval(parse(text = call)), silent = TRUE)

  expect_false(class(callOut) == "try-error")

  expectedOut <- data.frame(ID = c(2:5, 1:4),
                            Column = rep(c("A", "B"), each = 4),
                            Obs = 7:14,
                            stringsAsFactors = FALSE)
  row.names(expectedOut) <- 2:9

  expect_equal(callOut, expectedOut)

  ## Do not remove missing values
  call <- buildGather("testNA",
                      key = "Column",
                      value = "Obs",
                      cols = c("A", "B"),
                      na.rm = FALSE)

  expect_equal(call,
               "tidyr::gather(data = testNA, key = Column, value = Obs, na.rm = FALSE, A, B)")

  callOut <- try(eval(parse(text = call)), silent = TRUE)

  expect_false(class(callOut) == "try-error")

  expectedOut <- data.frame(ID = 1:5,
                            Column = rep(c("A", "B"), each = 5),
                            Obs = c(NA, 7:14, NA),
                            stringsAsFactors = FALSE)

  expect_equal(callOut, expectedOut)


  })


## Issue #3
test_that("Columns named as numbers are correctly returned", {

  badNaming <- data.frame(ID = c(1,2,3),
                          `2015` = c(4,5,6),
                          `2016` = c(7,8,9),
                          check.names=FALSE)

  call <- buildGather("badNaming",
                      "Key",
                      "Value",
                      cols = c("2015", "2016"),
                      na.rm = FALSE)

  expect_equal(call,
               "tidyr::gather(data = badNaming, key = Key, value = Value, na.rm = FALSE, `2015`, `2016`)")

  callOut <- try(eval(parse(text = call)), silent = TRUE)

  expect_false(class(callOut) == "try-error")

  expectedOut <- data.frame(ID = 1:3,
                            Key = rep(c("2015", "2016"), each = 3),
                            Value = 4:9,
                            stringsAsFactors = FALSE)

  expect_equal(callOut, expectedOut)

  })
