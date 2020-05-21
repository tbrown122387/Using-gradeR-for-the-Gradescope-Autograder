library(testthat)

# first test
test_that("first", {
  
  expect_equal( sum(myVector), 6) #22.17444, tolerance=1e-4)

})

# second test
test_that("second", {

  expect_true(is.character(myString))
  expect_true(len(myString) > 2)

})

# third test
test_that("third", {

  expect_equal(nrow(myDataFrame), 2)
  expect_equal(myDataFrame[1,1], 700.01, tolerance=1e-3)

})
