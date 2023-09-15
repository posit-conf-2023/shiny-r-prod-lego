#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic

  # run filter modules
  input_theme_ids <- mod_theme_picker_server("theme_picker_1")
  input_years <- mod_year_picker_server("year_picker_1")
  input_num_parts <- mod_numparts_picker_server("numparts_picker_1")

  # apply filters to LEGO data sets
  sets_rv <- reactive({
    req(input_years())
    req(input_num_parts())
    req(input_theme_ids())
    
    sets |>
      dplyr::filter(
        dplyr::between(year, input_years()[1], input_years()[2]),
        dplyr::between(num_parts, input_num_parts()[1], input_num_parts()[2]),
        theme_id %in% input_theme_ids()
      )
  })

  # obtain parts for relevant sets
  part_meta_rv <- reactive({
    req(sets_rv())

    part_meta_df <- gen_part_metaset()
    df <- part_meta_df |>
      dplyr::filter(set_num %in% unique(sets_rv()$set_num))

    return(df)
  })

  # number of sets per year
  output$sets_plot <- renderPlot({
    req(sets_rv())
    viz_sets(sets_rv())
  })

  # number of colors per part by year
  output$colors_plot <- renderPlot({
    req(sets_rv())
    viz_colors(
      calc_part_color_totals(sets_rv()),
      type = "bar"
    )
  })

  # boxplot of number of parts per year
  output$parts_plot <- renderPlot({
    req(sets_rv())
    viz_parts(sets_rv())
  })

  # TODO: Call your value widgets module (server-side) code here
  mod_value_widgets_server("value_widgets_1", sets_rv, part_meta_rv)
}
