context("Generate correct gather function call")

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
               "tidyr::gather(data= badNaming ,key= Key ,value= Value ,na.rm= FALSE ,`2015`, `2016`)")
  
  })