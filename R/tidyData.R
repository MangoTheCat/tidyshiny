#' Interactively format data
#' 
#' By selecting a data set the user can set all options for working with the \code{gather}
#' function of the \code{tidyr} package. The user is able to visualise the impact of the
#' options set and on return the shiny gadget will return the code required to recreate. 
#'
#' @author Aimee Gott
#' 
#' @export
tidyData <- function() {

  # Get all of the objects in the global environment
  objects <- ls(pos = 1)
  # determine which are data frames
  dataChoices <- objects[sapply(objects, function(x) is.data.frame(get(x)))]

  # define the UI for the gadget
  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("Tidy Data"),
    # select from data sets available, text for the key and value
    # multi-select for the columns
    miniUI::miniContentPanel(
      shiny::selectInput("data", "Choose data:", choices = dataChoices),
      shiny::fillRow(height = "15%",
              shiny::textInput("key", "Key:", placeholder = "Variable"),
              shiny::textInput("value", "Value:", placeholder =  "Value")
              ),
      shiny::selectInput("cols", "Columns:", choices = NULL, multiple = TRUE),
      shiny::tableOutput("gatherData")
    )
  )

  server <- function(input, output, session) {
    # Define reactive expressions, outputs, etc.
    data <- shiny::reactive({
      # get the selected data and update the column options
      data <- get(input$data)
      shiny::updateSelectInput(session, "cols", choices = names(data))
      data
      })

    output$gatherData <- shiny::renderTable({
      data <- data()
      # apply gather to the selected columns
      tidyr::gather_(data, key_col = input$key,
                     value_col = input$value,
                     gather_cols = input$cols)
      })

    # When the Done button is clicked, return a value
    shiny::observeEvent(input$done, {
      cols <- paste0(input$cols, collapse = ",")
      call <- paste0("gather(data=", input$data,
                     ",key=", input$key,
                     ",value=", input$value,
                     ",",cols, ")")
        # return function call
        shiny::stopApp(rstudioapi::insertText(call))
    })
  }

  # Run the app in the dialog viewer
  shiny::runGadget(ui, server, viewer = shiny::dialogViewer("Tidy Data",
                                                            width = 800))
}
