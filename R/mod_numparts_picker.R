#' numparts_picker UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_numparts_picker_ui <- function(id, label = NULL){
  ns <- NS(id)
  tagList(
    selectInput(
      ns("numparts_range"),
      label = label,
      choices = c(
        "All" = "all",
        "Small (1-50)" = "small",
        "Medium (51-200" = "medium",
        "Large (201+)" = "large"
      ),
      selected = "all",
      multiple = FALSE
    )
  )
}
    
#' numparts_picker Server Functions
#'
#' @noRd
#' 
#' @importFrom shiny reactive debounce req
mod_numparts_picker_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    numparts_range <- reactive({
      req(input$numparts_range)
      derive_parts_range(input$numparts_range)
    })

    return(numparts_range)
  })
}
    
## To be copied in the UI
# mod_numparts_picker_ui("numparts_picker_1")
    
## To be copied in the server
# mod_numparts_picker_server("numparts_picker_1")
