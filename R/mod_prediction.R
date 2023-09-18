#' prediction UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @import bslib
mod_prediction_ui <- function(id){
  ns <- NS(id)
  tagList(
    layout_columns(
      card(
        card_header("Enter Prediction Model Values"),
        numericInput(
          ns("n_colors"),
          "Number of unique colors",
          value = 10,
          min = 1,
          step = 1
        ),
        numericInput(
          ns("n_part_cat"),
          "Number of unique part categories",
          value = 5,
          min = 1,
          step = 1
        ),
        actionButton(
          ns("add"),
          "Add"
        ),
        actionButton(
          ns("predict"),
          "Predict"
        )
      ),
      card(
        card_header("Result"),
        reactable::reactableOutput(ns("pred_table"))
      )
    )
  )
}
    
#' prediction Server Functions
#'
#' @noRd 
#' @importFrom shiny reactiveValues observeEvent showNotification removeNotification onStop
#' @import crew
mod_prediction_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # reactive values for prediction operations
    pred_data_rv <- reactiveValues(
      data = tibble::tibble(),
      predicted_values = NULL
    )
    pred_status <- reactiveVal("No prediction submitted yet.")
    pred_poll <- reactiveVal(FALSE)

    # establish async processing with crew
    controller <- crew_controller_local(workers = 4, seconds_idle = 10)
    controller$start()
      
    # make sure to terminate the controller on stop #NEW
    onStop(function() controller$terminate())

    observeEvent(input$add, {
      # reset predicted values
      pred_data_rv$predicted_values <- NULL

      # add to input data
      data <- pred_data_rv$data

      pred_data_rv$data <- dplyr::bind_rows(
        data[!names(data) %in% "predicted_num_parts"],
        tibble::tibble(
          n_unique_colors = input$n_colors,
          n_unique_part_cat = input$n_part_cat
        )
      )
    })

    observeEvent(input$predict, {
      req(nrow(pred_data_rv$data > 0))
      pred_status("Prediction in progress")
      showNotification(
        ui = "Prediction in progress",
        duration = NULL,
        closeButton = FALSE,
        id = "pred_message",
        type = "message"
      )

      controller$push(
        command = run_prediction(df),
        data = list(
          run_prediction = run_prediction,
          df = pred_data_rv$data
        ),
        packages = c("httr2", "dplyr")
      )

      pred_poll(TRUE)
    })

    observe({
      req(pred_poll())

      invalidateLater(millis = 100)
      result <- controller$pop()$result

      if (!is.null(result)) {
        pred_data_rv$data <- result[[1]]
      }

      if (isFALSE(controller$nonempty())) {
        pred_status("Prediction Complete")
        pred_poll(controller$nonempty())
        removeNotification(id = "pred_message")
      }
    })

    output$pred_table <- reactable::renderReactable({
      req(nrow(pred_data_rv$data) > 0)
      pred_table(pred_data_rv$data)
    })
  })
}
    
## To be copied in the UI
# mod_prediction_ui("prediction_1")
    
## To be copied in the server
# mod_prediction_server("prediction_1")
