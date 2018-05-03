#' @importFrom purrr pluck
mb_browse <- function(context, entity, mbid, includes, limit, offset,
                      allowed_entities, available_includes){

  if (!entity %in% allowed_entities) stop("Not a valid entity")
  includes <- intersect(includes, available_includes)
  res <- browse_by_lnkd_id(context, entity, mbid, includes, limit, offset)

  # prepare lists
  res_lst <- purrr::pluck(res, paste0(context,"s"), .default = NA)

  parse_list(paste0(context,"s"), res_lst, offset = res[[paste0(context,"-offset")]], hit_count = res[[paste0(context,"-count")]])
}


#' @export
browse_artists_by <- function(entity, mbid, includes=NULL, limit=NULL, offset=NULL) {
  allowed_entities <- c("area", "recording", "release", "release-group", "work")
  available_includes <- c()

  mb_browse(context="artist", entity, mbid, includes, limit, offset,
                      allowed_entities, available_includes)
}

#browse_artists_by("area", "6743d351-6f37-3049-9724-5041161fff4d")
#' @export
browse_events_by <- function(entity, mbid, includes=NULL, limit=NULL, offset=NULL) {
  allowed_entities <- c("area", "artist", "place")
  available_includes <- c()

  mb_browse(context="event", entity, mbid, includes, limit, offset,
            allowed_entities, available_includes)
}
# entity="artist"; mbid= search_artists("Sting")$mbid[2]

# browse_events_by("artist", search_artists("Sting")$mbid[2])
#' @export
browse_labels_by <- function(entity, mbid, includes=NULL, limit=NULL, offset=NULL) {
  allowed_entities <- c("area", "release")
  available_includes <- c()
  mb_browse(context="label", entity, mbid, includes, limit, offset,
            allowed_entities, available_includes)
}

#entity="area"; mbid= search_areas("Norway")$mbid[1]

#browse_labels_by("area", search_areas("Norway",1)$mbid)
#' @export
browse_places_by <- function(entity, mbid, includes=NULL, limit=NULL, offset=NULL) {
  allowed_entities <- c("area")
  available_includes <- c()
  mb_browse(context="place", entity, mbid, includes, limit, offset,
            allowed_entities, available_includes)
}
#entity="area"; mbid=search_areas("Norway",1)$mbid
#browse_places_by("area", search_areas("Norway",1)$mbid)
#' @export
browse_recordings_by <- function(entity, mbid, includes=NULL, limit=NULL, offset=NULL) {
  allowed_entities <- c("artist", "release")
  available_includes <- c("artist-credits", "isrcs")

  mb_browse(context="recording", entity, mbid, includes, limit, offset,
            allowed_entities, available_includes)
}

#entity="artist"; mbid=search_artists("Sting")$mbid[2]
#browse_recordings_by("artist", search_artists("Sting")$mbid[2])
#' @export
browse_releases_by <- function(entity, mbid, includes=NULL, limit=NULL, offset=NULL) {
  allowed_entities <- c("area", "artist", "label", "track", "track_artist", "recording", "release-group")
  available_includes <- c("artist-credits", "labels", "recordings", "release-groups", "media", "discids", "isrcs", "recordings")
  mb_browse(context="release", entity, mbid, includes, limit, offset,
            allowed_entities, available_includes)
}

#browse_releases_by("artist", search_artists("Jon+Hassel",1)$mbid)

#' @export
browse_release_groups_by <- function(entity, mbid, includes=NULL, limit=NULL, offset=NULL) {
  allowed_entities <- c("artist", "release")
  available_includes <- c("artist-credits")
  mb_browse(context="release-group", entity, mbid, includes, limit, offset,
            allowed_entities, available_includes)
}

#browse_release_groups_by("artist", search_artists("Jon+Hassel",1)$mbid)
#' @export
browse_work_by <- function(entity, mbid, includes=NULL, limit=NULL, offset=NULL) {
  allowed_entities <- c("artist")
  available_includes <- c()
  mb_browse(context="work", entity, mbid, includes, limit, offset,
            allowed_entities, available_includes)
}

#browse_work_by("artist", search_artists("Jon+Hassel", 1)$mbid)
