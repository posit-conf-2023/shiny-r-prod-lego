#' @importFrom reactable reactable colDef
pred_table <- function(df) {

  # add column "predicted_num_parts" with missing values if not present
  if (!"predicted_num_parts" %in% names(df)) {
    df$predicted_num_parts <- NA
  }
  reactable(
    data = df,
    columns = list(
      n_unique_colors = colDef("Distinct Colors"),
      n_unique_part_cat = colDef("Unique Part Categories"),
      predicted_num_parts = colDef("Predicted Number of Parts")
    )
  )
}

#' @importFrom httr2 request req_body_json req_perform resp_body_json
run_prediction <- function(df, endpoint_url = "https://rsc.training.rstudio.com/legomod/predict", back_transform = TRUE, round_result = TRUE) {
  # create request object
  req <- request(endpoint_url)

  # perform request
  resp <- req |>
    req_body_json(df) |>
    req_perform()

  # extract predictions from response
  pred_values <- resp_body_json(resp)$.pred |> unlist()

  # back-transform log10 value of predicted number of parts if requested
  if (back_transform) {
    pred_values <- 10 ^ pred_values
  }

  # round result up to nearest integer if requested
  if (round_result) pred_values <- ceiling(pred_values)

  # append predictions to supplied data frame
  dplyr::mutate(df, predicted_num_parts = pred_values)
}