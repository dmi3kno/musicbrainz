#' @importFrom purrr pluck
mb_browse <- function(context, entity, mbid, includes, limit, offset,
                      allowed_entities, available_includes){

  if (!entity %in% allowed_entities) stop("Not a valid entity")
  includes <- intersect(includes, available_includes)
  res <- browse_by_lnkd_id(context, entity, mbid, includes, limit, offset)

  # prepare lists
  res_lst <- purrr::pluck(res, paste0(context,"s"), .default = NA)

  parsers_lst <- purrr::map(res_lst, ~get_includes_parser_df(.x, includes))
  parsers_df <- purrr::map_dfr(parsers_lst, ~purrr::pmap_dfc(.x, parse_includes))

  # extract and bind
  res_df <- parse_list(type=paste0(context,"s"), res_lst, offset = res[[paste0(context,"-offset")]], hit_count = res[[paste0(context,"-count")]])

  if(nrow(parsers_df)>0)
    res_df <- dplyr::bind_cols(res_df, parsers_df)
  res_df
}


#' Browse artists by related id
#'
#' @param entity area, recording, release, release-group or work
#'
#' @param mbid id of an object, specified by entity
#' @param includes tags
#' @param limit restrict number of records retrieved from musicbrainz database
#' @param offset number of records to skip
#'
#'
#' @return a tibble of artists consisting of mbid, type, name, gender, country, area and other fields
#' @examples
#' # browse Norwegian artists
#' browse_artists_by("area", "6743d351-6f37-3049-9724-5041161fff4d")
#'
#' @importFrom purrr pluck
#' @importFrom dplyr filter
#' @export
browse_artists_by <- function(entity, mbid, includes=NULL, limit=NULL, offset=NULL) {
  allowed_entities <- c("area", "recording", "release", "release-group", "work")
  available_includes <- c("tags")

  mb_browse(context="artist", entity, mbid, includes, limit, offset,
                      allowed_entities, available_includes)
}


#' Browse events by related id
#'
#' @param entity area, artist or place
#'
#' @param mbid id of an object, specified by entity
#' @param includes tags
#' @param limit restrict number of records retrieved from musicbrainz database
#' @param offset number of records to skip
#'
#'
#' @return a tibble of events consisting of mbid, type, name, time, dates and other fields
#' @examples
#' # browse events attended by Sting
#' browse_events_by("artist", "7944ed53-2a58-4035-9b93-140a71e41c34")
#' @export
browse_events_by <- function(entity, mbid, includes=NULL, limit=NULL, offset=NULL) {
  allowed_entities <- c("area", "artist", "place")
  available_includes <- c("tags")

  mb_browse(context="event", entity, mbid, includes, limit, offset,
            allowed_entities, available_includes)
}


#' Browse labels by related id
#'
#' @param entity area or release
#'
#' @param mbid id of an object, specified by entity
#' @param includes tags
#' @param limit restrict number of records retrieved from musicbrainz database
#' @param offset number of records to skip
#'
#'
#' @return a tibble of labels consisting of mbid, type, name, label_code, distribution area and other fields
#' @examples
#' # browse labels who issued Mozart's Requiem
#' browse_labels_by("release", "0ee7243b-ee28-4b42-8f6d-d84842d7ca60")
#' @export
browse_labels_by <- function(entity, mbid, includes=NULL, limit=NULL, offset=NULL) {
  allowed_entities <- c("area", "release")
  available_includes <- c("tags")
  mb_browse(context="label", entity, mbid, includes, limit, offset,
            allowed_entities, available_includes)
}


#' Browse places by related id
#'
#' @param entity area
#'
#' @param mbid id of an object, specified by entity
#' @param includes tags
#' @param limit restrict number of records retrieved from musicbrainz database
#' @param offset number of records to skip
#'
#'
#' @return a tibble of places consisting of mbid, type, name, address, geographical coordinates and other fields
#' @examples
#' # browse places in Kyiv, Ukraine
#' browse_places_by("area", "51c526a4-ed34-4eaf-94cf-0b96cd019d47")
#' @export
browse_places_by <- function(entity, mbid, includes=NULL, limit=NULL, offset=NULL) {
  allowed_entities <- c("area")
  available_includes <- c("tags")
  mb_browse(context="place", entity, mbid, includes, limit, offset,
            allowed_entities, available_includes)
}


#' Browse recordings by related id
#'
#' @param entity artist, release
#'
#' @param mbid id of an object, specified by entity
#' @param includes artists, tags
#' @param limit restrict number of records retrieved from musicbrainz database
#' @param offset number of records to skip
#'
#'
#' @return a tibble of recordings consisting of mbid, title, length and video flag. If includes are called, list column with related data will be added at the end of the results tibble
#' @examples
#' # browse recordings by Auli'i Cravalho ("Moana")
#' browse_recordings_by("artist", "715d6b2d-9b1f-4615-8e7c-71cf5e9bcde3")
#' @export
browse_recordings_by <- function(entity, mbid, includes=NULL, limit=NULL, offset=NULL) {
  allowed_entities <- c("artist", "release")
  available_includes <- c("artists", "tags") #isrcs? not currently implemented

  mb_browse(context="recording", entity, mbid, includes, limit, offset,
            allowed_entities, available_includes)
}

#' Browse releases by related id
#'
#' @param entity area, artist, collection, label, recording, release-group
#'
#' @param mbid id of an object, specified by entity
#' @param includes artists, labels, media, recordings, release-groups
#' @param limit restrict number of records retrieved from musicbrainz database
#' @param offset number of records to skip
#'
#'
#' @return a tibble of releases consisting of mbid, title, status, packaging, date, country, asin, track count, release-group and other columns. If includes are called, list-column(s) with related data will be added at the end of the results tibble
#' @examples
#' # browse releases by Avril Lavigne
#' browse_releases_by("artist", "0103c1cc-4a09-4a5d-a344-56ad99a77193")
#' @export
browse_releases_by <- function(entity, mbid, includes=NULL, limit=NULL, offset=NULL) {
  allowed_entities <- c("area", "artist", "collection", "label", "recording", "release-group") #"track", "track_artist"
  available_includes <- c("artists", "labels", "media", "recordings", "release-groups") #"discids", "isrcs",
  mb_browse(context="release", entity, mbid, includes, limit, offset,
            allowed_entities, available_includes)
}

#' Browse release groups by related id
#'
#' @param entity artist, release
#'
#' @param mbid id of an object, specified by entity
#' @param includes artists, tags
#' @param limit restrict number of records retrieved from musicbrainz database
#' @param offset number of records to skip
#'
#'
#' @return a tibble of release groups consisting of mbid, title, primary type and first release date. If includes are called, list-column(s) with related data will be added at the end of the results tibble
#' @examples
#' # browse release groups by Avril Lavigne
#' browse_release_groups_by("artist", "0103c1cc-4a09-4a5d-a344-56ad99a77193")
#' @export
browse_release_groups_by <- function(entity, mbid, includes=NULL, limit=NULL, offset=NULL) {
  allowed_entities <- c("artist", "release")
  available_includes <- c("artists", "tags")
  mb_browse(context="release-group", entity, mbid, includes, limit, offset,
            allowed_entities, available_includes)
}

#' Browse works by related id
#'
#' @param entity artist
#'
#' @param mbid id of an object, specified by entity
#' @param includes tags
#' @param limit restrict number of records retrieved from musicbrainz database
#' @param offset number of records to skip
#'
#'
#' @return a tibble of works consisting of mbid, title, type and language.
#' @examples
#' # browse works by Sade
#' browse_works_by("artist", "67930b3e-e00b-469f-8c74-fd69f20522ec")
#' @export
browse_works_by <- function(entity, mbid, includes=NULL, limit=NULL, offset=NULL) {
  allowed_entities <- c("artist")
  available_includes <- c("tags")
  mb_browse(context="work", entity, mbid, includes, limit, offset,
            allowed_entities, available_includes)
}
