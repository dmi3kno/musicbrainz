
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/musicbrainz)](http://cran.r-project.org/package=musicbrainz)

# musicbrainz <img src="man/figures/logo.png" align="right" />

The goal of musicbrainz is to make it easy to call the MusicBrainz
Database API from R. Currently API does NOT require authentication for
reading the data, however, requests to the database are subject to a
rate limit of 1 request/sec. The package utilizes `ratelimitr` to make
sure you don’t need to worry about exceeding that limit.

## Installation

You can install musicbrainz from github with:

``` r
# install.packages("devtools")
devtools::install_github("dmi3kno/musicbrainz")
```

## Example

There are three families of functions in `musicbrainz` package: search,
lookup and browse.

### Search

Lets search information about Miles Davis

``` r
library(musicbrainz)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

miles_df <- search_artists("Miles Davis")
#> Returning artists 1 to 25 of 2443
miles_df
#> # A tibble: 25 x 28
#>    mbid  type  type_id score name  sort_name gender gender_id country
#>    <chr> <chr> <chr>   <int> <chr> <chr>     <chr>  <lgl>     <chr>  
#>  1 561d… Pers… b6e035…   100 Mile… Davis, M… male   NA        US     
#>  2 fe72… Group e431f5…    86 Mile… Davis, M… <NA>   NA        US     
#>  3 16d2… Group e431f5…    80 The … Davis, M… <NA>   NA        <NA>   
#>  4 f137… Group e431f5…    79 Mile… Davis, M… <NA>   NA        <NA>   
#>  5 0360… Group e431f5…    77 Mile… Davis, M… <NA>   NA        <NA>   
#>  6 8813… Group e431f5…    76 Mile… Davis, M… <NA>   NA        <NA>   
#>  7 d74d… Pers… b6e035…    76 Mile… Moody, M… <NA>   NA        <NA>   
#>  8 5464… Group e431f5…    76 Mile… Miles Da… <NA>   NA        <NA>   
#>  9 607d… Group e431f5…    69 Mile… Davis, M… <NA>   NA        <NA>   
#> 10 72f2… Group e431f5…    68 Mile… Davis, M… <NA>   NA        <NA>   
#> # … with 15 more rows, and 19 more variables: disambiguation <chr>,
#> #   area_id <chr>, area_name <chr>, area_sort_name <chr>,
#> #   area_disambiguation <lgl>, area_iso <lgl>, begin_area_id <chr>,
#> #   begin_area_name <chr>, begin_area_sort_name <chr>,
#> #   begin_area_disambiguation <lgl>, end_area_id <chr>, end_area_name <chr>,
#> #   end_area_sort_name <chr>, end_area_disambiguation <lgl>,
#> #   life_span_begin <chr>, life_span_end <chr>, life_span_ended <lgl>,
#> #   ipis <chr>, isnis <chr>
```

It looks like the first hit is what we need. We can use `dplyr` to
extract the information of interest

``` r
miles_id <- miles_df %>% 
  select(mbid) %>%
  slice(1) %>% 
  pull()
```

### Lookup

Now that we have MusicBrainz id (“mbid”) we can call the lookup
function.

``` r
miles_lookup <- lookup_artist_by_id("561d854a-6a28-4aa7-8c99-323e6ce46c2a")
miles_lookup
#> # A tibble: 1 x 28
#>   mbid  type  type_id score name  sort_name gender gender_id country
#>   <chr> <chr> <chr>   <chr> <chr> <chr>     <chr>  <chr>     <chr>  
#> 1 561d… Pers… b6e035… <NA>  Mile… Davis, M… Male   36d3d30a… US     
#> # … with 19 more variables: disambiguation <chr>, area_id <chr>,
#> #   area_name <chr>, area_sort_name <chr>, area_disambiguation <chr>,
#> #   area_iso <chr>, begin_area_id <chr>, begin_area_name <chr>,
#> #   begin_area_sort_name <chr>, begin_area_disambiguation <chr>,
#> #   end_area_id <chr>, end_area_name <chr>, end_area_sort_name <chr>,
#> #   end_area_disambiguation <chr>, life_span_begin <chr>, life_span_end <chr>,
#> #   life_span_ended <lgl>, ipis <chr>, isnis <chr>
```

### Browse

We can also browse linked records (such as all releases by Miles
Davis).

``` r
miles_releases <- browse_releases_by("artist", "561d854a-6a28-4aa7-8c99-323e6ce46c2a")
#> Returning releases 1 to 25 of 1267
miles_releases
#> # A tibble: 25 x 17
#>    mbid  score count title status status_id packaging_id packaging_name date 
#>    <chr> <int> <lgl> <chr> <chr>  <chr>     <lgl>        <lgl>          <chr>
#>  1 16ed…    NA NA    Mile… Offic… 4e304316… NA           NA             1954 
#>  2 20ff…    NA NA    I've… Offic… 4e304316… NA           NA             1953 
#>  3 3bdb…    NA NA    Yest… Offic… 4e304316… NA           NA             1951 
#>  4 49aa…    NA NA    Youn… <NA>   <NA>      NA           NA             1952 
#>  5 4a8c…    NA NA    Clas… Offic… 4e304316… NA           NA             1954 
#>  6 596f…    NA NA    Blue… Offic… 4e304316… NA           NA             1955 
#>  7 645a…    NA NA    The … Offic… 4e304316… NA           NA             1953 
#>  8 6c10…    NA NA    Budo… Offic… 4e304316… NA           NA             1949…
#>  9 7acd…    NA NA    Mile… Offic… 4e304316… NA           NA             1955…
#> 10 8292…    NA NA    Mile… Offic… 4e304316… NA           NA             1953 
#> # … with 15 more rows, and 8 more variables: country <chr>,
#> #   disambiguation <chr>, barcode <chr>, asin <lgl>, track_count <lgl>,
#> #   quality <chr>, release_group_id <lgl>, release_group_primary_type <lgl>
```

## References

1.  Details of the Musicbrainz database API:
    <https://musicbrainz.org/doc/Development/XML_Web_Service/Version_2>
2.  Details about rate limits:
    <https://musicbrainz.org/doc/XML_Web_Service/Rate_Limiting>
