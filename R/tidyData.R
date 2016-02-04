#' Allow users to search a package for a function
#'
#' @export
tidyData <- function() {

  # Get all of the objects in the global environment
  objects <- ls(pos = 1)
  dataChoices <- objects[sapply(objects, function(x) is.data.frame(get(x)))]

  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("Tidy Data"),
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
      data <- get(input$data)
      shiny::updateSelectInput(session, "cols", choices = names(data))
      data
      })

    output$gatherData <- shiny::renderTable({
      data <- data()
      tidyr::gather_(data, key_col = input$key,
                     value_col = input$value,
                     gather_cols = input$cols)
      # data()
      })

    # When the Done button is clicked, return a value
    shiny::observeEvent(input$done, {
      cols <- paste0(input$cols, collapse = ",")
      call <- paste0("gather(data=", input$data,
                     ",key=", input$key,
                     ",value=", input$value,
                     ",",cols, ")")
        # return text for function call
        shiny::stopApp(rstudioapi::insertText(call))
    })
  }

  # Run the app in the dialog viewer
  shiny::runGadget(ui, server, viewer = shiny::dialogViewer("Tidy Data",
                                                            width = 800))
}
