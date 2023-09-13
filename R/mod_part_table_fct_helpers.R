#' @importFrom reactable reactable colDef
#' @importFrom reactablefmtr pill_buttons clean data_bars embed_img
parts_table <- function(df_summary, single_set = FALSE, img_width = 24, img_height = 24) {
  if (single_set) {
    sets_coldef <- colDef(show = FALSE)
  } else {
    sets_coldef <- colDef(
      "Number of Sets",
      minWidth = 70,
      cell = data_bars(
        df_summary,
        text_size = 12,
        text_position = "inside-end",
        number_fmt = scales::comma
      )
    )
  }

  reactable(
    data = df_summary,
    theme = clean(),
    columns = list(
      name = colDef(
        "",
        minWidth = 150,
        cell = pill_buttons(
          df_summary,
          color_ref = "rgb"
        )
      ),
      img_url = colDef(
        "",
        maxWidth = 30,
        cell = embed_img(
          height = img_height,
          width = img_height
        )
      ),
      name_partcat = colDef(
        "Category",
        maxWidth = 100)
      ,
      part_material = colDef(
        "Material",
        maxWidth = 100
      ),
      part_total = colDef(
        "Total",
        minWidth = 70,
        cell = data_bars(
          df_summary,
          text_size = 12,
          text_position = "inside-end",
          number_fmt = scales::comma
        )
      ),
      sets_total = sets_coldef,
      is_trans = colDef(show = FALSE),
      rgb = colDef(show = FALSE),
      name_color = colDef(show = FALSE),
      part_cat_id = colDef(show = FALSE),
      part_num = colDef(show = FALSE),
      color_id = colDef(show = FALSE)
    )
  )
}
