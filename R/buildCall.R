#' Build gather call
#' 
#' Build the return function call for the gather function from supplied user inputs
#' 
#' @param data A character string of the data.frame name
#' @param key A character string
#' @param value A character string
#' @param cols A vector of character strings
#' @param na.rm A logical value
#' 
#' @author Aimee Gott
buildGather <- function(data, key, value, cols, na.rm){
  
  if(is.null(cols)){
    colCall <- ")"
    warning("No columns selected, generated code will result in all columns gathered", 
            call. = FALSE)
  } else{
    cols <- lapply(cols, as.name)
    colCall <- paste(cols, collapse = ", ")
    colCall <- paste0(",", colCall, ")")
  }
  
  call <- paste("tidyr::gather(data=", data,
                ",key=", key,
                ",value=", value,
                ",na.rm=", na.rm)
  
  call <- paste(call, colCall)
  
  call 
}