legos_tables <- function() {
  list(
    colors = brickapp::colors,
    elements = brickapp::elements,
    inventories = brickapp::inventories,
    inventory_minifigs = brickapp::inventory_minifigs,
    inventory_parts = brickapp::inventory_parts,
    inventory_sets = brickapp::inventory_sets,
    minifigs = brickapp::minifigs,
    part_categories = brickapp::part_categories,
    parts = brickapp::parts,
    sets = brickapp::sets,
    themes = brickapp::themes
  )
}

#' Colors
#' 
#' Colors in the LEGO Rebrickable data collection
#' 
#' @format A data frame with `r nrow(colors)` rows and `r ncol(colors)` variables.
#' \describe{
#'  \item{\code{color_id}}{color ID.}
#'  \item{\code{name}}{color name.}
#'  \item{\code{rgb}}{color red, green, and blue (RGB) value.}
#'  \item{\code{is_trans}}{whether the color is transparent or not.}
#' }
"colors"

#' Elements
#' 
#' Elements in the LEGO Rebrickable data collection
#' 
#' @format A data frame with `r nrow(elements)` rows and `r ncol(elements)` variables.
#' \describe{
#'  \item{\code{element_id}}{element ID.}
#'  \item{\code{design_id}}{design ID.}
#'  \item{\code{part_num}}{part number.}
#'  \item{\code{color_id}}{color ID.}
#' }
"elements"

#' Inventories
#' 
#' Inventories in the LEGO Rebrickable data collection
#' 
#' @format A data frame with `r nrow(inventories)` rows and `r ncol(inventories)` variables.
#' \describe{
#'  \item{\code{inventory_id}}{inventory ID}
#'  \item{\code{version}}{inventory version number}
#'  \item{\code{set_num}}{set number}
#' }
"inventories"

#' Inventory for mini-figures
#' 
#' Inventory of mini-figures in the LEGO Rebrickable data collection
#' 
#' @format A data frame with `r nrow(inventory_minifigs)` rows and `r ncol(inventory_minifigs)` variables.
#' \describe{
#'  \item{\code{inventory_id}}{inventory ID}
#'  \item{\code{fig_num}}{figure number}
#'  \item{\code{quantity}}{number available}
#' }
"inventory_minifigs"

#' Inventory for parts
#' 
#' Inventory of parts in the LEGO Rebrickable data collection
#' 
#' @format A data frame with `r nrow(inventory_parts)` rows and `r ncol(inventory_parts)` variables.
#' \describe{
#'  \item{\code{inventory_id}}{inventory ID}
#'  \item{\code{part_num}}{part number.}
#'  \item{\code{color_id}}{color ID.}
#'  \item{\code{quantity}}{number available}
#'  \item{\code{is_spare}}{whether the part is considered a spare or not}
#'  \item{\code{img_url}}{part image URL}
#' }
"inventory_parts"

#' Inventory for sets
#' 
#' Inventory of sets in the LEGO Rebrickable data collectoin
#' 
#' @format A data frame with `r nrow(inventory_sets)` rows and `r ncol(inventory_sets)` variables.
#' \describe{
#'  \item{\code{inventory_id}}{inventory ID}
#'  \item{\code{quantity}}{number available}
#'  \item{\code{set_num}}{set number}
#' }
"inventory_sets"

#' Mini-Figures
#' 
#' Mini-Figures in the LEGO Rebrickable data collection
#' 
#' @format A data frame with `r nrow(minifigs)` rows and `r ncol(minifigs)` variables.
#' \describe{
#'  \item{\code{fig_num}}{figure number}
#'  \item{\code{name}}{figure name}
#'  \item{\code{num_parts}}{number of parts in mini-figure}
#'  \item{\code{img_url}}{mini-figure image URL}
#' }
"minifigs"

#' Part Categories
#' 
#' Part categories in the LEGO Rebrickable data collection
#' 
#' @format A data frame with `r nrow(part_categories)` rows and `r ncol(part_categories)` variables.
#' \describe{
#'  \item{\code{part_cat_id}}{part category ID}
#'  \item{\code{name}}{part category name}
#' }
"part_categories"

#' Part Relationships
#' 
#' Part relationships in the LEGO Rebrickable data collection
#' 
#' @format A data frame with `r nrow(part_relationships)` rows and `r ncol(part_relationships)` variables.
#' \describe{
#'  \item{\code{rel_type}}{Type of relationship. Possible values are `P` (Print), `R` (Pair), `B` (Sub-Part), `M` (Mold), `T` (Pattern), `A` (Alternate)}
#'  \item{\code{child_part_num}}{child part number}
#'  \item{\code{parent_part_num}}{parent part number}
#' }
"part_relationships"

#' Parts
#' 
#' Parts in the LEGO Rebricable data collection
#' 
#' @format A data frame with `r nrow(parts)` rows and `r ncol(parts)` variables.
#' \describe{
#'  \item{\code{part_num}}{part number}
#'  \item{\code{name}}{part name}
#'  \item{\code{part_cat_id}}{part category ID}
#'  \item{\code{part_material}}{part material}
#' }
"parts"

#' Sets
#' 
#' Sets in the LEGO Rebrickable data collection
#' 
#' @format A data frame with `r nrow(sets)` rows and `r ncol(sets)` variables.
#' \describe{
#'  \item{\code{set_num}}{set number}
#'  \item{\code{name}}{set name}
#'  \item{\code{year}}{year set was produced}
#'  \item{\code{theme_id}}{theme ID}
#'  \item{\code{num_parts}}{number of parts in set}
#'  \item{\code{img_url}}{set image URL}
#' }
"sets"

#' Themes
#' 
#' Themes in the LEGO Rebrickable data collection
#' 
#' @format A data frame with `r nrow(themes)` rows and `r ncol(themes)` variables.
#' \describe{
#'  \item{\code{theme_id}}{theme ID}
#'  \item{\code{name}}{theme name}
#'  \item{\code{parent_id}}{parent theme ID}
#' }
"themes"