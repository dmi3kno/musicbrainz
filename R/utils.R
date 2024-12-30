#' @importFrom httr GET add_headers
httr_get <- function(url) {
  httr::GET(
    url,
    httr::add_headers(
      Accept = "application/json",
      "user-agent" = "musicbrainz R package"
    )
  )
}

#' @importFrom ratelimitr rate limit_rate
httr_get_rate_ltd <- ratelimitr::limit_rate(
  httr_get,
  ratelimitr::rate(n = 1, period = 1.6)
)

#' @importFrom httr status_code content
get_data_with_errors <- function(url, verbose) {
  # error handling function

  # api call
  mb_data <- httr_get_rate_ltd(url)

  # status check
  status <- httr::status_code(mb_data)

  if (status > 200) {
    # this is more problematic and we shall try again
    if (verbose) {
      message(paste("http error code:", status))
    }
    res <- NULL
  }
  if (status == 200) res <- httr::content(mb_data, type = "application/json")
  res
}

# main re-attempt function
.GET_data <- function(url, verbose=TRUE) { # nolint
  output <- get_data_with_errors(url, verbose)
  max_attempts <- 3

  try_number <- 1
  while (is.null(output) && try_number < max_attempts) {
    try_number <- try_number + 1
    if (verbose) {
      message(paste0("Attempt number ", try_number))
      if (try_number == max_attempts) {
        message("This is the last attempt, if it fails will return NULL") # nolint
      }
    }
    Sys.sleep(2^try_number)
    output <- get_data_with_errors(url, verbose)
  }
  output
}

#' @importFrom memoise memoise
get_data <- memoise::memoise(.GET_data)

#' @importFrom httr build_url parse_url
#' @importFrom utils URLencode
lookup_by_id <- function(resource, mbid, includes) {
  # lookup:   /<ENTITY>/<MBID>?inc=<INC>
  # API request function for lookup
  base_url <- "http://musicbrainz.org/ws/2"
  url <- base::paste(c(base_url, resource, mbid), collapse = "/")
  url <- utils::URLencode(url)

  if (!is.null(includes) && length(includes)) {
    parsed_url <- httr::parse_url(url)
    parsed_url$query <- base::list(inc = paste0(includes, collapse = "+"))
    url <- httr::build_url(parsed_url)
  }

  get_data(url)
}

#' @importFrom httr build_url
search_by_query <- function(type, query, limit, offset) {
  # API request function for search
  # search:   /<ENTITY>?query=<QUERY>&limit=<LIMIT>&offset=<OFFSET>
  base_url <- "http://musicbrainz.org/ws/2"
  url <- base::paste(c(base_url, type), collapse = "/")

  parsed_url <- httr::parse_url(url)
  parsed_url$query <- base::list(query = query, limit = limit, offset = offset)

  url <- httr::build_url(parsed_url)

  get_data(url)
}


#' @importFrom httr build_url
#' @importFrom stats setNames
#' @importFrom utils URLencode
browse_by_lnkd_id <- function(resource, lnk_resource, mbid, includes, limit, offset) {
  # API request function for search
  # browse:   /<ENTITY>?<ENTITY>=<MBID>&limit=<LIMIT>&offset=<OFFSET>&inc=<INC>
  base_url <- "http://musicbrainz.org/ws/2"
  url <- base::paste(c(base_url, resource), collapse = "/")
  url <- utils::URLencode(url)
  parsed_url <- httr::parse_url(url)
  parsed_url$query <- stats::setNames(base::list(mbid), nm = lnk_resource)
  parsed_url$query <- base::append(parsed_url$query, list(limit = limit, offset = offset))

  if (!is.null(includes) && length(includes)) {
    parsed_url$query <- base::append(parsed_url$query, list(inc = paste0(includes, collapse = "+")))
  }

  url <- httr::build_url(parsed_url)

  get_data(url)
}

#' Tidy eval helpers
#'
#' These functions provide tidy eval-compatible ways to capture
#' symbols
#' To learn more about tidy eval and how to use these tools, read
#' <http://rlang.tidyverse.org/articles/tidy-evaluation.html>
#'
#' @name tidyeval
#' @keywords internal
#' @importFrom rlang UQ UQS .data :=
NULL
