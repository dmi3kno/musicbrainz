# Sys.setenv("HTTP_PROXY"="")
# Sys.setenv("HTTPS_PROXY"="")

#' @export
lookup_area_by_id <- function(mbid, includes=NULL) {
  available_includes <- c()
  includes <- validate_includes (includes, available_includes)
  res <- lookup_by_id("area", mbid, includes)

  # extract and bind
  res_df <- dplyr::bind_cols(
    purrr::map_dfr(get_main_parser_lst("areas"), ~ purrr::pluck(res, .x, .default = NA_character_))
  )
  res_df
}

#lookup_area_by_id(search_areas("Trondheim",1)$mbid)
#' @export
lookup_artist_by_id <- function(mbid, includes=NULL) {
  available_includes <- c("recordings", "releases", "release-groups", "works")
  includes <- validate_includes (includes, available_includes)
  res <- lookup_by_id("artist", mbid, includes)

  parsers_df <- get_includes_parser_df(res, includes)

  # extract and bind
  res_df <- dplyr::bind_cols(
    purrr::map_dfr(get_main_parser_lst("artists"), ~ purrr::pluck(res, .x, .default = NA_character_)),
    purrr::pmap_dfc(parsers_df, parse_includes)
  )
  res_df
}

#lookup_artist_by_id(search_artists("David+Sanborn",1)$mbid, includes=c("recordings"))
# mbid="79247575-5787-48c6-a32f-1b80d6602681"
#' @export
lookup_event_by_id <- function(mbid, includes=NULL) {
  available_includes <- c()
  includes <- validate_includes (includes, available_includes)
  res <- lookup_by_id("event", mbid, includes)

  # extract and bind
  res_df <- dplyr::bind_cols(
    purrr::map_dfr(get_main_parser_lst("events"), ~ purrr::pluck(res, .x, .default = NA_character_))
  )

  res_df
}

#lookup_event_by_id(search_events("The+Prince",1)$mbid)
#' @export
lookup_instrument_by_id <- function(mbid, includes=NULL) {
  available_includes <- c()
  includes <- validate_includes (includes, available_includes)
  res <- lookup_by_id("instrument", mbid, includes)

  # extract and bind
  res_df <- dplyr::bind_cols(
    purrr::map_dfr(get_main_parser_lst("instruments"), ~ purrr::pluck(res, .x, .default = NA_character_))
  )

  res_df
}

#lookup_instrument_by_id(search_instruments("bandura")$mbid[1])

#' @export
lookup_label_by_id <- function(mbid, includes=NULL) {
  available_includes <- c("releases")
  includes <- validate_includes (includes, available_includes)
  res <- lookup_by_id("label", mbid, includes)

  parsers_df <- get_includes_parser_df(res, includes)

  # extract and bind
  res_df <- dplyr::bind_cols(
    purrr::map_dfr(get_main_parser_lst("labels"), ~ purrr::pluck(res, .x, .default = NA_character_)),
    purrr::pmap_dfc(parsers_df, parse_includes)
  )
  res_df
}

#lookup_label_by_id(search_labels("Blue+Note",1)$mbid, includes = "releases")
#' @export
lookup_place_by_id <- function(mbid, includes=NULL) {
  available_includes <- c()
  includes <- validate_includes (includes, available_includes)
  res <- lookup_by_id("place", mbid, includes)

  # extract and bind
  res_df <- dplyr::bind_cols(
    purrr::map_dfr(get_main_parser_lst("places"), ~ purrr::pluck(res, .x, .default = NA_character_))
  )

  res_df
}

#lookup_place_by_id(search_places("Telenor+Arena",1)$mbid)
#' @export
lookup_recording_by_id <- function(mbid, includes=NULL) {
  available_includes <- c("artists", "releases")
  includes <- validate_includes (includes, available_includes)
  res <- lookup_by_id("recording", mbid, includes)

  parsers_df <- get_includes_parser_df(res, includes)

  # extract and bind
  res_df <- dplyr::bind_cols(
    purrr::map_dfr(get_main_parser_lst("recordings"), ~ purrr::pluck(res, .x, .default = NA_character_)),
    purrr::pmap_dfc(parsers_df, parse_includes)
  )
  res_df
}
#lookup_recording_by_id(search_recordings("All+for+love",1)$mbid, includes = "artists")
#' @export
lookup_release_group_by_id <- function(mbid, includes=NULL) {
  available_includes <- c("artists", "releases")
  includes <- validate_includes (includes, available_includes)
  res <- lookup_by_id("release-group", mbid, includes)

  parsers_df <- get_includes_parser_df(res, includes)

  # extract and bind
  res_df <- dplyr::bind_cols(
    purrr::map_dfr(get_main_parser_lst("release-groups"), ~ purrr::pluck(res, .x, .default = NA_character_)),
    purrr::pmap_dfc(parsers_df, parse_includes)
  )
  res_df
}

#lookup_release_group_by_id(search_release_groups("The+Best", 1)$mbid, includes = "releases")

#' @export
lookup_release_by_id <- function(mbid, includes=NULL) {
  available_includes <- c("artists", "labels", "recordings", "release-groups")
  includes <- validate_includes (includes, available_includes)
  res <- lookup_by_id("release", mbid, includes)

  parsers_df <- get_includes_parser_df(res, includes)

  # extract and bind
  res_df <- dplyr::bind_cols(
    purrr::map_dfr(get_main_parser_lst("releases"), ~ purrr::pluck(res, .x, .default = NA_character_)),
    purrr::pmap_dfc(parsers_df, parse_includes)
  )
  res_df
}
#mbid=search_releases("The+Best",1)$mbid
#lookup_release_by_id(search_releases("The+Best",1)$mbid, includes = "release-groups")

#' @export
lookup_series_by_id <- function(mbid, includes=NULL) {
  available_includes <- c()
  includes <- validate_includes (includes, available_includes)
  res <- lookup_by_id("series", mbid, includes)

  # extract and bind
  res_df <- dplyr::bind_cols(
    purrr::map_dfr(get_main_parser_lst("series"), ~ purrr::pluck(res, .x, .default = NA_character_))
  )

  res_df
}

#' @export
lookup_work_by_id <- function(mbid, includes=NULL) {
  available_includes <- c()
  includes <- validate_includes (includes, available_includes)
  res <- lookup_by_id("work", mbid, includes)

  # extract and bind
  res_df <- dplyr::bind_cols(
    purrr::map_dfr(get_main_parser_lst("works"), ~ purrr::pluck(res, .x, .default = NA_character_))
  )

  res_df
}
