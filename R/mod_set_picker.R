#' set_picker UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @importFrom shinyWidgets virtualSelectInput prepare_choices
mod_set_picker_ui <- function(id, label = "Select a set"){
  ns <- NS(id)
  tagList(
    virtualSelectInput(
      ns("virt_set_num"),
      label = label,
      choices = c(),
      multiple = FALSE,
      search = TRUE,
      hasOptionDescription = TRUE
    )
  )
}
    
#' set_picker Server Functions
#'
#' @noRd 
#' @importFrom shinyWidgets updateVirtualSelect prepare_choices
mod_set_picker_server <- function(id, sets_rv){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # derive choices for set selection input
    set_choices <- reactive({
      req(sets_rv())
      prepare_choices(
        sets_rv(),
        label = name,
        value = set_num,
        description = year
      )
    })

    observeEvent(sets_rv(), {
      req(set_choices())
      updateVirtualSelect(
        "virt_set_num",
        choices = set_choices()
      )
    })

    return(reactive(input$virt_set_num))
  })
}
    
## To be copied in the UI
# mod_set_picker_ui("set_picker_1")
    
## To be copied in the server
# mod_set_picker_server("set_picker_1")
