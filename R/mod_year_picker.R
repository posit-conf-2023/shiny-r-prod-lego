#' year_picker UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @importFrom histoslider input_histoslider
mod_year_picker_ui <- function(id){
  ns <- NS(id)
  tagList(
    input_histoslider(
      ns("year_range"),
      label = NULL,
      values = sets$year,
      options = list(
        handleLabelFormat = "0d"
      )
    )
  )
}
    
#' year_picker Server Functions
#'
#' @noRd 
#' 
#' @importFrom shiny reactive req debounce
mod_year_picker_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # observeEvent(input$year_range, {
    #   message(glue::glue("Year Low: {year_range()[1]} Year High: {year_range()[2]}"))
    # })

    # convert years selected to nearest integer
    year_range <- reactive({
      req(input$year_range)
      round(input$year_range, 0)
    }) |> debounce(1000)

    return(year_range)
  })
}
    
## To be copied in the UI
# mod_year_picker_ui("year_picker_1")
    
## To be copied in the server
# mod_year_picker_server("year_picker_1")
