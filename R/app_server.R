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

  part_meta_rv <- reactive({
    req(sets_rv())
    part_meta_df <- gen_part_metaset()

    df <- part_meta_df |>
      dplyr::filter(set_num %in% unique(sets_rv()$set_num))

    return(df)
  })

  # reactive version of parts summary
  df_summary_rv <- reactive({
    req(sets_rv())

    # grab set IDs from the sets reactive data frame
    set_ids <- unique(sets_rv()$set_num)
    part_meta_df <- gen_part_metaset()
    df_sum <- calc_part_totals(part_meta_df, set_ids = set_ids)
    
    return(df_sum)
  })

  df_summary_rv_top <- reactive({
    req(df_summary_rv())
    req(input$n_parts_display)

    dplyr::slice_max(df_summary_rv(), part_total, n = as.integer(input$n_parts_display))
  })

  # run value widget module
  mod_value_widgets_server("value_widgets_1", sets_rv, part_meta_rv)
  
  # run parts table module
  mod_part_table_server("part_table_1", df_summary_rv_top)

  # run set selection module
  set_single <- mod_set_picker_server("set_picker_1", sets_rv)

  # run parts table module for individual set
  df_summary_single_rv <- reactive({
    req(set_single())
    part_meta_df <- gen_part_metaset()
    df_sum <- calc_part_totals(part_meta_df, set_ids = set_single())
    return(df_sum)
  })

  mod_part_table_server("part_table_2", df_summary_single_rv, single_set = TRUE)

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

  set_url <- reactive({
    req(set_single())
    sets |>
      dplyr::filter(set_num == set_single()) |>
      pull(img_url)
    
  })

  # image for individual sets
  mod_set_viewer_server("set_viewer_1", set_url)

  # execute prediction module server function
  mod_prediction_server("prediction_1")
}
