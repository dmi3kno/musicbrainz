#' @importFrom tibble tribble
#' @importFrom dplyr filter
get_main_parser_lst <-function(type){
  # prepare extractors
  parsers_df <- tibble::tribble(
    ~nm,    ~lst_xtr,
    "artists",    list(mbid = "id", type = "type", type_id = "type-id", score = "score", name = "name", sort_name = "sort-name",
                       gender = "gender", gender_id = "gender-id", country = "country", disambiguation = "disambiguation",
                       area_id = list("area", "id"), area_name = list("area", "name"),
                       area_sort_name = list("area", "sort-name"), area_disambiguation = list("area", "disambiguation"),
                       area_iso = list("area", "iso-3166-1-codes", 1),
                       begin_area_id = list("begin-area", "id"), begin_area_name = list("begin-area", "name"),
                       begin_area_sort_name = list("begin-area", "sort-name"),
                       begin_area_disambiguation = list("begin-area", "disambiguation"),
                       end_area_id = list("end-area", "id"), end_area_name = list("end-area", "name"),
                       end_area_sort_name = list("end-area", "sort-name"),
                       end_area_disambiguation = list("end-area", "disambiguation"),
                       life_span_begin = list("life-span", "begin"), life_span_end = list("life-span", "end"),
                       life_span_ended = list("life-span", "ended"), ipis = list("ipis", 1),
                       isnis = list("isnis", 1)),
    "events",    list(mbid = "id", name = "name", type = "type", type_id = "type-id", score = "score",
                      time = "time", cancelled = "cancelled", disambiguation = "disambiguation",
                      begin = list("life-span", "begin"), end = list("life-span", "end"),
                      ended = list("life-span", "ended"), setlist = "setlist"),
    "labels",    list(mbid = "id", type = "type", type_id="type-id", score = "score", name = "name", sort_name = "sort-name",
                      label_code = "label-code", country = "country", disambiguation = "disambiguation",
                      begin = list("life-span", "begin"), end=list("life-span", "end"), ended=list("life-span", "ended"),
                      area_id = list("area", "id"), area_name = list("area", "name"), area_sort_name = list("area", "sort-name"),
                      area_iso = list("area", "iso-3166-1-codes", 1), ipis = list("ipis", 1),
                      isnis = list("isnis", 1)),
    "places",    list(mbid = "id", type = "type", type_id="type-id", score = "score", name = "name", address = "address",
                      disambiguation = "disambiguation", latitude = list("coordinates","latitude"), longitude = list("coordinates","longitude"),
                      area_id = list("area","id"), area_name = list("area","name"), area_sort_name = list("area","sort-name"),
                      area_disambiguation=list("area","disambiguation"), area_iso=list("area", "iso-3166-1-codes",1),
                      place_begin = list("life-span","begin"), place_end = list("life-span","end"), place_ended = list("life-span","ended")),
    "recordings", list(mbid = "id", score = "score", title = "title", length = "length", video = "video"),
    "releases",   list(mbid = "id", score = "score", count = "count", title = "title",
                       status = "status", status_id = "status-id", packaging = "packaging", packaging_id = "packaging-id",
                       date = "date", country = "country", disambiguation="disambiguation",
                       barcode = "barcode", asin = "asin", track_count = "track-count", quality="quality",
                       release_group_id = list("release-group", "id"),
                       release_group_primary_type = list("release-group", "primary-type")),
    "release-groups", list(mbid = "id", score = "score", count = "count", title = "title", disambiguation = "disambiguation",
                           primary_type = "primary-type", primary_type_id = "primary-type-id",
                           first_releas_date="first-release-date"),
    "areas",      list(mbid = "id", type = "type", score = "score", name = "name", sort_name = "sort-name",
                       disambiguation = "disambiguation", iso=list("iso-3166-2-codes", 1),
                       begin=list("list-span", "begin"), end=list("list-span", "end"), ended=list("list-span", "ended"),
                       relation_type =  list("relation-list", 1, "relations", 1, "type"),
                       relation_type_id =  list("relation-list", 1, "relations", 1, "type-id"),
                       relation_direction = list("relation-list", 1, "relations", 1, "direction"),
                       relation_area_id = list("relation-list", 1, "relations", 1, "area", "id"),
                       relation_area_type = list("relation-list", 1, "relations", 1, "area", "type"),
                       relation_area_name = list("relation-list", 1, "relations", 1, "area", "name"),
                       relation_area_sort_name = list("relation-list", 1, "relations", 1, "area", "sort-name"),
                       relation_area_begin = list("relation-list", 1, "relations", 1, "area", "list-span", "begin"),
                       relation_area_end = list("relation-list", 1, "relations", 1, "area", "list-span", "end"),
                       relation_area_ended = list("relation-list", 1, "relations", 1, "area", "list-span", "ended")),
    "annotations", list(mbid = "entity", type = "type", score = "score", name = "name", text = "text"),
    "instruments", list(mbid = "id", type = "type", score = "score", name = "name",
                        disambiguation = "disambiguation", description = "description"),
    "series",      list(mbid = "id", type = "type", score = "score", name = "name", disambiguation = "disambiguation"),
    "works",       list(mbid = "id", type = "type", score = "score", title = "title",
                        language = "language", disambiguation = "disambiguation")
  )
  dplyr::filter(parsers_df, .data$nm == type)[["lst_xtr"]][[1]] # or pull and flatten
}


#' @importFrom purrr map map_dfr pluck
parse_list <- function(type, res_lst, offset, hit_count) {
  if (!is.null(res_lst) && length(res_lst)) {
    message(paste("Returning", type, offset + 1, "to", offset + length(res_lst), "of", hit_count))
  }

  res_lst_xtr <- get_main_parser_lst(type)

  res_df <- purrr::map_dfr(res_lst, ~ purrr::map(res_lst_xtr, function(i) purrr::pluck(.x, !!!i, .default = NA)))

  res_df$score <- as.integer(res_df$score)

  res_df
}

#' @importFrom purrr map map_dfr pluck
#' @importFrom tibble tibble
#' @importFrom dplyr filter mutate select
get_includes_parser_df <- function(res, includes) {
  df <- tibble::tibble(
    nm = c("releases", "recordings", "release-groups", "works", "artists", "labels", "media", "tags"),
    node=c("releases", "recordings", "release-groups", "works", "artist-credit", "label-info", "media", "tags"),
    lst_xtr = list(
      list(
        release_mbid = "id", barcode = "barcode", packaging = "packaging", packaging_id = "packaging-id",
        title = "title", date = "date", status = "status", status_id = "status-id",
        quality = "quality", country = "country", disambiguation = "disambiguation"
      ),
      list(
        recording_mbid = "id", disambiguation = "disambiguation", length = "length",
        title = "title", video = "video"
      ),
      list(
        release_group_mbid = "id", title = "title", primary_type = "primary-type",
        primary_type_id = "primary-type-id", disambiguation = "disambiguation",
        first_release_date = "first-release-date"
      ),
      list(
        work_mbid = "id", title = "title", language = "language",
        disambiguation = "disambiguation"
      ),
      list(
        artist_mbid = list("artist", "id"), name = list("artist", "name"),
        sort_name = list("artist", "sort_name"), disambiguation = list("artist", "disambiguation")
      ),
      list(
        label_mbid = list("label", "id"), name = list("label", "name"), sort_name = list("label", "sort-name"),
        label_code = list("label", "label-code"), disambiguation = list("label", "disambiguation"),
        catalog_number = "catalog-number"
      ),
      list(format = "format", disc_count = "disc-count", track_count = "track-count"),
      list(tag_name = "name", tag_count = "count")
    )
  )
  df <- dplyr::filter(df, .data$nm %in% includes)
  df <- dplyr::mutate(df, lst = purrr::map(.data$node, ~purrr::pluck(res, .x, .default = NULL)))
  dplyr::select(df, -.data$node)
}

#' @importFrom purrr map map_dfr pluck
#' @importFrom tibble tibble
#' @importFrom rlang UQ
parse_includes <- function(nm, lst_xtr, lst) {
  nm <- quo_name(nm)
  res_lst <- list(purrr::map_dfr(lst, ~ purrr::map(lst_xtr, function(i) purrr::pluck(.x, !!!i, .default = NA))))
  tibble::tibble(rlang::UQ(nm) := res_lst)
}


validate_includes <- function(includes, available_includes){
  unsupported_includes <- base::setdiff(includes, available_includes)
  if(!is.null(unsupported_includes) && length(unsupported_includes)>0){
    if(length(available_includes)>0)
      message(paste("Only", paste0(paste0("'",available_includes,"'"), collapse = ", "),
                    "includes are supported by this function."))
    else
      message("No includes are supported by this function.")

    message(paste("Ignoring", paste0(paste0("'",unsupported_includes,"'"), collapse = ", ")))
  }
  base::intersect(includes, available_includes)
}
