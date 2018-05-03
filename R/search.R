#' Search annotations
#'
#' @param query search string using Lucene syntax
#'
#' @param limit limit number of hits returned from database, defaults to NULL
#' @param offset number of hits to skip, defaults to NULL
#' @param strict return only exact matches with score of 100, defaults to FALSE
#'
#' @return a tibble of annotations
#' @examples
#' search_annotations("concerto")
#'
#' @importFrom purrr pluck
#' @importFrom dplyr filter
#' @export
search_annotations <- function(query, limit=NULL, offset=NULL, strict=FALSE) {
  res <- search_by_query("annotation", query, limit, offset)

  # prepare lists
  res_lst <- purrr::pluck(res, "annotations", .default = NA)

  # extract and bind together
  res_df <- parse_list("annotations", res_lst, res[["offset"]], res[["count"]])

  if (strict) res_df <- dplyr::filter(res_df, score==100)
  res_df
}

#' Search areas
#'
#' @param query search string using Lucene syntax
#'
#' @param limit limit number of hits returned from database, defaults to NULL
#' @param offset number of hits to skip, defaults to NULL
#' @param strict return only exact matches with score of 100, defaults to FALSE
#'
#' @return a tibble of areas
#' @examples
#' search_areas("Oslo")
#'
#' @importFrom purrr pluck
#' @importFrom dplyr filter
#' @export
search_areas <- function(query, limit=NULL, offset=NULL, strict=FALSE) {
  res <- search_by_query("area", query, limit, offset)

  # prepare lists
  res_lst <- purrr::pluck(res, "areas", .default = NA)

  # extract and bind together
  res_df <- parse_list("areas", res_lst, res[["offset"]], res[["count"]])

  if (strict) res_df <- dplyr::filter(res_df, score==100)
  res_df
}

#' Search artists
#'
#' @param query search string using Lucene syntax
#'
#' @param limit limit number of hits returned from database, defaults to NULL
#' @param offset number of hits to skip, defaults to NULL
#' @param strict return only exact matches with score of 100, defaults to FALSE
#'
#' @return a tibble of artists
#' @examples
#' search_artists("John+Taylor")
#'
#' @importFrom purrr pluck
#' @importFrom dplyr filter
#' @export
search_artists <- function(query, limit=NULL, offset=NULL, strict=FALSE) {
  res <- search_by_query("artist", query, limit, offset)

  # prepare lists
  res_lst <- purrr::pluck(res, "artists", .default = NA)

  res_df <- parse_list("artists", res_lst, res[["offset"]], res[["count"]])

  if (strict) res_df <- dplyr::filter(res_df, score==100)
  res_df
}

#' Search events
#'
#' @param query search string using Lucene syntax
#'
#' @param limit limit number of hits returned from database, defaults to NULL
#' @param offset number of hits to skip, defaults to NULL
#' @param strict return only exact matches with score of 100, defaults to FALSE
#'
#' @return a tibble of events
#' @examples
#' search_events("The+Prince\'s+Trust")
#'
#' @importFrom purrr pluck map map_chr
#' @importFrom tibble tibble
#' @importFrom tidyr drop_na
#' @importFrom dplyr filter bind_cols
#' @export
search_events <- function(query, limit=NULL, offset=NULL, strict=FALSE) {
  # area is not returned. can be looked up from place
  res <- search_by_query("event", query, limit, offset)

  # prepare lists
  res_lst <- purrr::pluck(res, "events", .default = list(NA))
  relations_lst <- purrr::map(res_lst, ~ purrr::pluck(.x, "relations", .default = list(list(NA))))

  relations_lst_xtr <- c(relations_type = "type", reations_direction = "direction")

  # extract and bind
  res_df <- dplyr::bind_cols(
    parse_list("events", res_lst, offset = res[["offset"]], hit_count = res[["count"]]),
    tibble::tibble(
      artists = purrr::map(relations_lst, ~ tidyr::drop_na(tibble::tibble(
        relations_type = purrr::map_chr(.x, function(i) purrr::pluck(i, list("type"), .default = NA_character_)),
        relations_direction = purrr::map_chr(.x, function(i) purrr::pluck(i, list("direction"), .default = NA_character_)),
        artist_mbid = purrr::map_chr(.x, function(i) purrr::pluck(i, list("artist", "id"), .default = NA_character_)),
        artist_name = purrr::map_chr(.x, function(i) purrr::pluck(i, list("artist", "name"), .default = NA_character_)),
        artist_sort_name = purrr::map_chr(.x, function(i) purrr::pluck(i, list("artist", "sort-name"), .default = NA_character_)),
        artist_disambiguation = purrr::map_chr(.x, function(i) purrr::pluck(i, list("artist", "disambiguation"), .default = NA_character_)),
      ), artist_mbid)),
      places = purrr::map(relations_lst, ~ tidyr::drop_na(tibble::tibble(
        relations_type = purrr::map_chr(.x, function(i) purrr::pluck(i, list("type"), .default = NA_character_)),
        relations_direction = purrr::map_chr(.x, function(i) purrr::pluck(i, list("direction"), .default = NA_character_)),
        place_mbid = purrr::map_chr(.x, function(i) purrr::pluck(i, list("place", "id"), .default = NA_character_)),
        place_name = purrr::map_chr(.x, function(i) purrr::pluck(i, list("place", "name"), .default = NA_character_)),
        place_disambiguation = purrr::map_chr(.x, function(i) purrr::pluck(i, list("place", "disambiguation"), .default = NA_character_))
      ), place_mbid))
    )
  )

  if (strict) res_df <- dplyr::filter(res_df, score==100)
  res_df
}


#' Search instruments
#'
#' @param query search string using Lucene syntax
#'
#' @param limit limit number of hits returned from database, defaults to NULL
#' @param offset number of hits to skip, defaults to NULL
#' @param strict return only exact matches with score of 100, defaults to FALSE
#'
#' @return a tibble of instruments
#' @examples
#' search_instruments("French+Horn")
#'
#' @importFrom purrr pluck
#' @importFrom dplyr filter
#' @export
search_instruments <- function(query, limit=NULL, offset=NULL, strict=FALSE) {
  res <- search_by_query("instrument", query, limit, offset)

  # prepare lists
  res_lst <- purrr::pluck(res, "instruments", .default = NA)

  res_df <- parse_list("instruments", res_lst, res[["offset"]], res[["count"]])

 if (strict) res_df <- dplyr::filter(res_df, score==100)
 res_df
}


#' Search labels
#'
#' @param query search string using Lucene syntax
#'
#' @param limit limit number of hits returned from database, defaults to NULL
#' @param offset number of hits to skip, defaults to NULL
#' @param strict return only exact matches with score of 100, defaults to FALSE
#'
#' @return a tibble of labels
#' @examples
#' search_labels("Blue+Note")
#'
#' @importFrom purrr pluck
#' @importFrom dplyr filter
#' @export
search_labels <- function(query, limit=NULL, offset=NULL, strict=FALSE) {
  res <- search_by_query("label", query, limit, offset)

  # prepare lists
  res_lst <- purrr::pluck(res, "labels", .default = NA)

  res_df <- parse_list("labels", res_lst, res[["offset"]], res[["count"]])

  if (strict) res_df <- dplyr::filter(res_df, score==100)
  res_df
}

#' Search places
#'
#' @param query search string using Lucene syntax
#'
#' @param limit limit number of hits returned from database, defaults to NULL
#' @param offset number of hits to skip, defaults to NULL
#' @param strict return only exact matches with score of 100, defaults to FALSE
#'
#' @return a tibble of places
#' @examples
#' search_places("Telenor+Arena")
#'
#' @importFrom purrr pluck
#' @importFrom dplyr filter
#' @export
search_places <- function(query, limit=NULL, offset=NULL, strict=FALSE) {
  res <- search_by_query("place", query, limit, offset)

  # prepare lists
  res_lst <- purrr::pluck(res, "places", .default = NA)

  # extract and bind
  res_df <- parse_list("places", res_lst, offset = res[["offset"]], hit_count = res[["count"]])

  if (strict) res_df <- dplyr::filter(res_df, score==100)

  res_df
}

#' Search recordings
#'
#' @param query search string using Lucene syntax
#'
#' @param limit limit number of hits returned from database, defaults to NULL
#' @param offset number of hits to skip, defaults to NULL
#' @param strict return only exact matches with score of 100, defaults to FALSE
#'
#' @return a tibble of recordings
#' @examples
#' search_recordings("Yellow+Submarine")
#'
#' @importFrom purrr pluck map map_dfr pmap_dfc
#' @importFrom dplyr filter bind_cols
#' @export
search_recordings <- function(query, limit=NULL, offset=NULL, strict=FALSE) {
  res <- search_by_query("recording", query, limit, offset)

  # prepare lists
  res_lst <- purrr::pluck(res, "recordings", .default = NA)
  parsers_lst <- purrr::map(res_lst, ~get_includes_parser_df(.x, includes=c("artists", "releases")))


  # extract and bind
  res_df <- dplyr::bind_cols(
    parse_list("recordings", res_lst, offset = res[["offset"]], hit_count = res[["count"]]),
    purrr::map_dfr(parsers_lst, ~purrr::pmap_dfc(.x, parse_includes))
  )

  if (strict) res_df <- dplyr::filter(res_df, score==100)
  res_df
}

#' Search release groups (albums etc)
#'
#' @param query search string using Lucene syntax
#'
#' @param limit limit number of hits returned from database, defaults to NULL
#' @param offset number of hits to skip, defaults to NULL
#' @param strict return only exact matches with score of 100, defaults to FALSE
#'
#' @return a tibble of release groups
#' @examples
#' search_release_groups("The+Wall")
#'
#' @importFrom purrr pluck map map_dfr pmap_dfc
#' @importFrom tibble tibble
#' @importFrom tidyr drop_na
#' @importFrom dplyr filter bind_cols
#' @export
search_release_groups <- function(query, limit=NULL, offset=NULL, strict=FALSE) {
  res <- search_by_query("release-group", query, limit, offset)

  # prepare lists
  res_lst <- purrr::pluck(res, "release-groups", .default = NA)
  parsers_lst <- purrr::map(res_lst, ~get_includes_parser_df(.x, includes=c("artists", "releases")))

  artist_credit_lst <- purrr::map(res_lst, ~ purrr::pluck(.x, "artist-credit", .default = NA))
  releases_lst <- purrr::map(res_lst, ~ purrr::pluck(.x, "releases", .default = NA))

  # extract and bind
  res_df <- dplyr::bind_cols(
    parse_list("release-groups", res_lst, offset = res[["offset"]], hit_count = res[["count"]]),
    purrr::map_dfr(parsers_lst, ~purrr::pmap_dfc(.x, parse_includes))
  )

 if (strict) res_df <- dplyr::filter(res_df, score==100)
 res_df
}

#' Search releases
#'
#' @param query search string using Lucene syntax
#'
#' @param limit limit number of hits returned from database, defaults to NULL
#' @param offset number of hits to skip, defaults to NULL
#' @param strict return only exact matches with score of 100, defaults to FALSE
#'
#' @return a tibble of releases
#' @examples
#' search_releases("The+Wall")
#'
#' @importFrom purrr pluck map map_dfr pmap_dfc
#' @importFrom tibble tibble
#' @importFrom tidyr drop_na
#' @importFrom dplyr filter bind_cols
#' @export
search_releases <- function(query, limit=NULL, offset=NULL, strict=FALSE) {
  res <- search_by_query("release", query, limit, offset)

  # prepare lists
  res_lst <- purrr::pluck(res, "releases", .default = NA)
  parsers_lst <- purrr::map(res_lst, ~get_includes_parser_df(.x, includes=c("artists", "labels", "media")))

  # extract and bind
  res_df <- dplyr::bind_cols(
    parse_list("releases", res_lst, offset = res[["offset"]], hit_count = res[["count"]]),
    purrr::map_dfr(parsers_lst, ~purrr::pmap_dfc(.x, parse_includes))
  )

  if (strict) res_df <- dplyr::filter(res_df, score==100)
  res_df
}

#' Search series
#'
#' @param query search string using Lucene syntax
#'
#' @param limit limit number of hits returned from database, defaults to NULL
#' @param offset number of hits to skip, defaults to NULL
#' @param strict return only exact matches with score of 100, defaults to FALSE
#'
#' @return a tibble of series
#' @examples
#' search_series("The+Best")
#'
#' @importFrom purrr pluck map map_dfr pmap_dfc
#' @importFrom tibble tibble
#' @importFrom tidyr drop_na
#' @importFrom dplyr filter bind_cols
#' @export
search_series <- function(query, limit=NULL, offset=NULL, strict=FALSE) {
  res <- search_by_query("series", query, limit, offset)

  # prepare lists
  res_lst <- purrr::pluck(res, "series", .default = NA)

  res_df <- parse_list("labels", res_lst, res[["offset"]], res[["count"]])

  if (strict) res_df <- dplyr::filter(res_df, score==100)
  res_df
}

#' Search works
#'
#' @param query search string using Lucene syntax
#'
#' @param limit limit number of hits returned from database, defaults to NULL
#' @param offset number of hits to skip, defaults to NULL
#' @param strict return only exact matches with score of 100, defaults to FALSE
#'
#' @return a tibble of works
#' @examples
#' search_works("The+Wall")
#'
#' @importFrom purrr pluck map map_dfr pmap_dfc
#' @importFrom tibble tibble
#' @importFrom tidyr drop_na
#' @importFrom dplyr filter bind_cols
#' @export
search_works <- function(query, limit=NULL, offset=NULL, strict=FALSE) {
  res <- search_by_query("work", query, limit, offset)

  # prepare lists
  res_lst <- purrr::pluck(res, "works", .default = NA)
  relations_lst <- purrr::map(res_lst, ~ purrr::pluck(.x, "relations", .default = NA))

    # extract and bind
  res_df <- dplyr::bind_cols(
    parse_list("works", res_lst, offset = res[["offset"]], hit_count = res[["count"]]),
    tibble::tibble(
      artists = purrr::map(relations_lst, ~ tidyr::drop_na(tibble::tibble(
        relations_type = purrr::map_chr(.x, function(i) purrr::pluck(i, list("type"), .default = NA_character_)),
        relations_direction = purrr::map_chr(.x, function(i) purrr::pluck(i, list("direction"), .default = NA_character_)),
        artist_mbid = purrr::map_chr(.x, function(i) purrr::pluck(i, list("artist", "id"), .default = NA_character_)),
        artist_name = purrr::map_chr(.x, function(i) purrr::pluck(i, list("artist", "name"), .default = NA_character_)),
        artist_sort_name = purrr::map_chr(.x, function(i) purrr::pluck(i, list("artist", "sort-name"), .default = NA_character_)),
        artist_disambiguation = purrr::map_chr(.x, function(i) purrr::pluck(i, list("artist", "disambiguation"), .default = NA_character_)),
      ), artist_mbid)),
      recordings = purrr::map(relations_lst, ~ tidyr::drop_na(tibble::tibble(
        relations_type = purrr::map_chr(.x, function(i) purrr::pluck(i, list("type"), .default = NA_character_)),
        relations_direction = purrr::map_chr(.x, function(i) purrr::pluck(i, list("direction"), .default = NA_character_)),
        recording_mbid = purrr::map_chr(.x, function(i) purrr::pluck(i, list("recording", "id"), .default = NA_character_)),
        recording_title = purrr::map_chr(.x, function(i) purrr::pluck(i, list("recording", "title"), .default = NA_character_)),
        recording_video = purrr::map_chr(.x, function(i) purrr::pluck(i, list("recording", "video"), .default = NA_character_))
      ), recording_mbid))
    )
  )

  if (strict) res_df <- dplyr::filter(res_df, score==100)
  res_df
}
