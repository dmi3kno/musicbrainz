#' Lookup musicbrainz entities by id
#'
#' Helper functions for looking up details about musicbrainz database entities
#' given mbid. Optional parameter `includes` allows retrieving related information.
#' Lookup functions are not vectorized
#' @name lookup_entities_by_id
#' @return Tibble containing details of the requested entity
#' @param mbid musicbrainz database id
#' @param includes character vector of names of related entities to include. See information
#' about avaialable includes in each of the lookup functions.
#' @examples
#' # find mbid for Trondheim and lookup area information
#' trondheim_mbid <- search_areas("Trondheim",1)$mbid
#' lookup_area_by_id(trondheim_mbid)
#'
#' # Lookup "The Wall" release
#' the_wall_mbid <- search_releases("The Wall AND artist:Pink Floyd",1)$mbid
#' lookup_release_by_id(the_wall_mbid)
#'
#' # Lookup "David Sanborn" artist
#' sanborn_id <- search_artists("David+Sanborn",1)$mbid
#' lookup_artist_by_id(sanborn_id, includes=c("recordings"))
NULL

#' @describeIn lookup_entities_by_id lookup area by mbid.
#' Available includes: tags
#' @importFrom dplyr bind_cols
#' @importFrom purrr map_dfr pluck pmap_dfc
#' @export
lookup_area_by_id <- function(mbid, includes=NULL) {
  available_includes <- c("tags")
  includes <- validate_includes (includes, available_includes)
  res <- lookup_by_id("area", mbid, includes)

  parsers_df <- get_includes_parser_df(res, includes)

  # extract and bind
  res_df <- dplyr::bind_cols(
    purrr::map_dfr(get_main_parser_lst("areas"), function(i) purrr::pluck(res, !!!i, .default = NA_character_)),
    purrr::pmap_dfc(parsers_df, parse_includes)
  )
  res_df
}

#' @describeIn lookup_entities_by_id lookup artist by mbid.
#' Available includes: recordings, releases, release-groups, works and tags.
#' @importFrom dplyr bind_cols
#' @importFrom purrr map_dfr pluck pmap_dfc
#' @export
lookup_artist_by_id <- function(mbid, includes=NULL) {
  available_includes <- c("recordings", "releases", "release-groups", "works", "tags")
  includes <- validate_includes (includes, available_includes)
  res <- lookup_by_id("artist", mbid, includes)

  parsers_df <- get_includes_parser_df(res, includes)

  # extract and bind
  res_df <- dplyr::bind_cols(
    purrr::map_dfr(get_main_parser_lst("artists"), function(i) purrr::pluck(res, !!!i, .default = NA_character_)),
    purrr::pmap_dfc(parsers_df, parse_includes)
  )
  res_df
}

#' @describeIn lookup_entities_by_id lookup event by mbid.
#' Available includes: tags.
#' @importFrom dplyr bind_cols
#' @importFrom purrr map_dfr pluck pmap_dfc
#' @export
lookup_event_by_id <- function(mbid, includes=NULL) {
  available_includes <- c("tags")
  includes <- validate_includes (includes, available_includes)
  res <- lookup_by_id("event", mbid, includes)

  parsers_df <- get_includes_parser_df(res, includes)

  # extract and bind
  res_df <- dplyr::bind_cols(
    purrr::map_dfr(get_main_parser_lst("events"), function(i) purrr::pluck(res, !!!i, .default = NA_character_)),
    purrr::pmap_dfc(parsers_df, parse_includes)
  )

  res_df
}

#' @describeIn lookup_entities_by_id lookup instrument by mbid.
#' Available includes: tags.
#' @importFrom dplyr bind_cols
#' @importFrom purrr map_dfr pluck pmap_dfc
#' @export
lookup_instrument_by_id <- function(mbid, includes=NULL) {
  available_includes <- c("tags")
  includes <- validate_includes (includes, available_includes)
  res <- lookup_by_id("instrument", mbid, includes)

  parsers_df <- get_includes_parser_df(res, includes)

  # extract and bind
  res_df <- dplyr::bind_cols(
    purrr::map_dfr(get_main_parser_lst("instruments"),function(i) purrr::pluck(res, !!!i, .default = NA_character_)),
    purrr::pmap_dfc(parsers_df, parse_includes)
  )

  res_df
}

#' @describeIn lookup_entities_by_id lookup label by mbid.
#' Available includes: releases and tags.
#' @importFrom dplyr bind_cols
#' @importFrom purrr map_dfr pluck pmap_dfc
#' @export
lookup_label_by_id <- function(mbid, includes=NULL) {
  available_includes <- c("releases", "tags")
  includes <- validate_includes (includes, available_includes)
  res <- lookup_by_id("label", mbid, includes)

  parsers_df <- get_includes_parser_df(res, includes)

  # extract and bind
  res_df <- dplyr::bind_cols(
    purrr::map_dfr(get_main_parser_lst("labels"), function(i) purrr::pluck(res, !!!i, .default = NA_character_)),
    purrr::pmap_dfc(parsers_df, parse_includes)
  )
  res_df
}

#' @describeIn lookup_entities_by_id lookup artist by mbid.
#' Available includes: tags.
#' @importFrom dplyr bind_cols
#' @importFrom purrr map_dfr pluck pmap_dfc
#' @export
lookup_place_by_id <- function(mbid, includes=NULL) {
  available_includes <- c("tags")
  includes <- validate_includes (includes, available_includes)
  res <- lookup_by_id("place", mbid, includes)

  parsers_df <- get_includes_parser_df(res, includes)

  # extract and bind
  res_df <- dplyr::bind_cols(
    purrr::map_dfr(get_main_parser_lst("places"), function(i) purrr::pluck(res, !!!i, .default = NA_character_)),
    purrr::pmap_dfc(parsers_df, parse_includes)
  )

  res_df
}

#' @describeIn lookup_entities_by_id lookup recording by mbid.
#' Available includes: artists, releases and tags
#' @importFrom dplyr bind_cols
#' @importFrom purrr map_dfr pluck pmap_dfc
#' @export
lookup_recording_by_id <- function(mbid, includes=NULL) {
  available_includes <- c("artists", "releases", "tags")
  includes <- validate_includes (includes, available_includes)
  res <- lookup_by_id("recording", mbid, includes)

  parsers_df <- get_includes_parser_df(res, includes)

  # extract and bind
  res_df <- dplyr::bind_cols(
    purrr::map_dfr(get_main_parser_lst("recordings"), function(i) purrr::pluck(res, !!!i, .default = NA_character_)),
    purrr::pmap_dfc(parsers_df, parse_includes)
  )
  res_df
}

#' @describeIn lookup_entities_by_id lookup release group by mbid.
#' Available includes: artists, releases and tags
#' @importFrom dplyr bind_cols
#' @importFrom purrr map_dfr pluck pmap_dfc
#' @export
lookup_release_group_by_id <- function(mbid, includes=NULL) {
  available_includes <- c("artists", "releases", "tags")
  includes <- validate_includes (includes, available_includes)
  res <- lookup_by_id("release-group", mbid, includes)

  parsers_df <- get_includes_parser_df(res, includes)

  # extract and bind
  res_df <- dplyr::bind_cols(
    purrr::map_dfr(get_main_parser_lst("release-groups"), function(i) purrr::pluck(res, !!!i, .default = NA_character_)),
    purrr::pmap_dfc(parsers_df, parse_includes)
  )
  res_df
}

#' @describeIn lookup_entities_by_id lookup release by mbid.
#' Available includes: artists, labels, recordings, release-groups, and tags
#' @importFrom dplyr bind_cols
#' @importFrom purrr map_dfr pluck pmap_dfc
#' @export
lookup_release_by_id <- function(mbid, includes=NULL) {
  available_includes <- c("artists", "labels", "recordings", "release-groups", "tags")
  includes <- validate_includes (includes, available_includes)
  res <- lookup_by_id("release", mbid, includes)

  parsers_df <- get_includes_parser_df(res, includes)

  # extract and bind
  res_df <- dplyr::bind_cols(
    purrr::map_dfr(get_main_parser_lst("releases"), function(i) purrr::pluck(res, !!!i, .default = NA_character_)),
    purrr::pmap_dfc(parsers_df, parse_includes)
  )
  res_df
}

#' @describeIn lookup_entities_by_id lookup series by mbid.
#' Available includes: tags
#' @importFrom dplyr bind_cols
#' @importFrom purrr map_dfr pluck pmap_dfc
#' @export
lookup_series_by_id <- function(mbid, includes=NULL) {
  available_includes <- c("tags")
  includes <- validate_includes (includes, available_includes)
  res <- lookup_by_id("series", mbid, includes)

  parsers_df <- get_includes_parser_df(res, includes)

  # extract and bind
  res_df <- dplyr::bind_cols(
    purrr::map_dfr(get_main_parser_lst("series"), function(i) purrr::pluck(res, !!!i, .default = NA_character_)),
    purrr::pmap_dfc(parsers_df, parse_includes)
  )

  res_df
}

#' @describeIn lookup_entities_by_id lookup work by mbid.
#' Available includes: tags
#' @importFrom dplyr bind_cols
#' @importFrom purrr map_dfr pluck pmap_dfc
#' @export
lookup_work_by_id <- function(mbid, includes=NULL) {
  available_includes <- c("tags")
  includes <- validate_includes (includes, available_includes)
  res <- lookup_by_id("work", mbid, includes)

  parsers_df <- get_includes_parser_df(res, includes)

  # extract and bind
  res_df <- dplyr::bind_cols(
    purrr::map_dfr(get_main_parser_lst("works"), function(i) purrr::pluck(res, !!!i, .default = NA_character_)),
    purrr::pmap_dfc(parsers_df, parse_includes)
  )

  res_df
}
