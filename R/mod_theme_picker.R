#' theme_picker UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @param label optional label for theme input. Default is NULL.
#' @noRd 
#'
#' @importFrom shiny NS tagList selectInput conditionalPanel
#' @importFrom shinyWidgets virtualSelectInput prepare_choices
mod_theme_picker_ui <- function(id, label = NULL) {
  ns <- NS(id)

  themes <- dplyr::arrange(themes, name)

  choices_list <- shinyWidgets::prepare_choices(
    themes,
    label = name,
    value = theme_id
  )

  tagList(
    virtualSelectInput(
      ns("virt_theme_id"),
      label = label,
      choices = choices_list,
      selected = themes$theme_id,
      multiple = TRUE,
      search = TRUE
    )
  )
}
    
#' theme_picker Server Functions
#'
#' @noRd 
#' 
#' @importFrom shiny observeEvent reactive req updateSelectInput
#' @importFrom shinyWidgets updatePickerInput updateVirtualSelect
mod_theme_picker_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    return(reactive(input$virt_theme_id))
  })
}
    
## To be copied in the UI
# mod_theme_picker_ui("theme_picker_1")
    
## To be copied in the server
# mod_theme_picker_server("theme_picker_1")
