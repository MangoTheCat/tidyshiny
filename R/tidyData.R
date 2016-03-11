#' Interactively format data
#' 
#' By selecting a data set the user can set all options for working with the \code{gather}
#' function of the \code{tidyr} package. The user is able to visualise the impact of the
#' options set and on return the shiny gadget will return the code required to recreate. 
#' 
#' @param data (Optional) Data frame to be manipulated. If not provided the data from 
#' all data.frame objects in the current environment will be available for selection in the gadget.
#'
#' @author Aimee Gott
#' 
#' @export
tidyData <- function(data) {

  if(missing(data)){
    # Get all of the objects in the global environment
    objects <- ls(pos = 1)
    
    if(length(objects) == 0) stop("No objects found. Please create a data.frame to continue", call. = FALSE)
    # determine which are data frames
    dataChoices <- objects[sapply(objects, function(x) is.data.frame(get(x)))]
  }else {
    dataChoices <- as.character(match.call())[2]
  }
  
  # define the UI for the gadget
  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("Tidy Data"),
    # select from data sets available, text for the key and value
    # multi-select for the columns
    miniUI::miniContentPanel(
      shiny::selectInput("data", "Choose data:", choices = dataChoices),
      shiny::fillRow(height = "15%",
              shiny::textInput("key", "Key:", placeholder = "Variable"),
              shiny::textInput("value", "Value:", placeholder = "Value")
              ),
      shiny::fillRow(height = "15%",
              shiny::selectInput("cols", "Columns:", choices = NULL, multiple = TRUE),
              shiny::checkboxInput("narm", "Removing output rows where value is NA", 
                                  value = FALSE)
      ),
      shiny::tableOutput("gatherData")
    )
  )

  server <- function(input, output, session) {
    # Define reactive expressions, outputs, etc.
    data <- shiny::reactive({
      # get the selected data and update the column options
      shiny::validate(shiny::need(input$data != "", "No data frames found"))
      data <- get(input$data)
      shiny::updateSelectInput(session, "cols", choices = names(data))
      data
      })
    
    # Define a default Key if one isn't supplied
    key <- shiny::reactive({
      
      if(input$key == "") "Key"
      else input$key
      
      })
    
    # Define a default VAlue if one isn't supplied
    value <- shiny::reactive({
      
      if(input$value == "") "Value"
      else input$value
      
      })

    # Apply the gather function to view output
    output$gatherData <- shiny::renderTable({
      data <- data()
      
      # apply gather to the selected columns
      tidyr::gather_(data, key_col = key(),
                     value_col = value(),
                     gather_cols = input$cols, 
                     na.rm = input$narm)
      })

    # When the Done button is clicked, return a value
    shiny::observeEvent(input$done, {
      
      cols <- input$cols
      
      call <- buildGather(data = input$data, 
                  key = key(),
                  value = value(),
                  cols = cols,
                  na.rm = input$narm)
      
        # return function call
      if(rstudioapi::isAvailable()){
        shiny::stopApp(rstudioapi::insertText(call))
      } else{
        shiny::stopApp(call)
        }
    })
  }

  # Run the app in the dialog viewer
  shiny::runGadget(ui, server, viewer = shiny::dialogViewer("Tidy Data",
                                                            width = 800))
}

