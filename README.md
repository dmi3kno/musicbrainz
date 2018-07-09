
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/musicbrainz)](http://cran.r-project.org/package=musicbrainz)

musicbrainz
===========

The goal of musicbrainz is to make it easy to call the MusicBrainz Database API from R. Currently API does NOT require authentication for reading the data, however, requests to the database are subject to a rate limit of 1 request/sec. The package utilizes `ratelimitr` to make sure you don't need to worry about exceeding that limit.

Installation
------------

You can install musicbrainz from github with:

``` r
# install.packages("devtools")
devtools::install_github("dmi3kno/musicbrainz")
```

Example
-------

There are three families of functions in `musicbrainz` package: search, lookup and browse.

### Search

Lets search information about Miles Davis

``` r
library(musicbrainz)
library(dplyr)
#> Warning: package 'dplyr' was built under R version 3.5.1
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

miles_df <- search_artists("Miles Davis")
#> Returning artists 1 to 20 of 20
miles_df
#> # A tibble: 20 x 28
#>    mbid   type   type_id  score name   sort_name  gender gender_id country
#>    <chr>  <chr>  <chr>    <int> <chr>  <chr>      <chr>  <lgl>     <chr>  
#>  1 561d8~ Person b6e035f~   100 Miles~ Davis, Mi~ male   NA        US     
#>  2 fe724~ Group  e431f5f~    85 Miles~ Davis, Mi~ <NA>   NA        US     
#>  3 f1378~ Group  e431f5f~    81 Miles~ Davis, Mi~ <NA>   NA        <NA>   
#>  4 16d2b~ Group  e431f5f~    79 The M~ Davis, Mi~ <NA>   NA        <NA>   
#>  5 03606~ Group  e431f5f~    78 Miles~ Davis, Mi~ <NA>   NA        <NA>   
#>  6 607d7~ Group  e431f5f~    75 Miles~ Davis, Mi~ <NA>   NA        <NA>   
#>  7 72f2e~ Group  e431f5f~    74 Miles~ Davis, Mi~ <NA>   NA        <NA>   
#>  8 88130~ Group  e431f5f~    74 Miles~ Davis, Mi~ <NA>   NA        <NA>   
#>  9 7103c~ Group  e431f5f~    71 The M~ Davis, Mi~ <NA>   NA        <NA>   
#> 10 d74d6~ Person b6e035f~    71 Miles~ Moody, Mi~ <NA>   NA        <NA>   
#> 11 f2b73~ Group  e431f5f~    67 Miles! Miles!     <NA>   NA        NL     
#> 12 c52ff~ Group  e431f5f~    67 Miles~ Davis, Mi~ <NA>   NA        <NA>   
#> 13 47c34~ <NA>   <NA>        64 Miles~ Miles Dav~ <NA>   NA        <NA>   
#> 14 addd7~ <NA>   <NA>        63 The S~ Shoes Of ~ <NA>   NA        <NA>   
#> 15 e1b6e~ Group  e431f5f~    60 Miles~ Davis, Mi~ <NA>   NA        <NA>   
#> 16 4cd1a~ Group  e431f5f~    59 Miles~ Davis, Mi~ <NA>   NA        <NA>   
#> 17 6f1ce~ Person b6e035f~    48 Conra~ Roberts, ~ male   NA        <NA>   
#> 18 bae9f~ Group  e431f5f~    47 Miles~ Roach, Mi~ <NA>   NA        <NA>   
#> 19 04359~ Person b6e035f~    44 Smile~ Davis, Sm~ female NA        <NA>   
#> 20 cab16~ <NA>   <NA>        44 J.R.   J.R.       <NA>   NA        <NA>   
#> # ... with 19 more variables: disambiguation <chr>, area_id <chr>,
#> #   area_name <chr>, area_sort_name <chr>, area_disambiguation <lgl>,
#> #   area_iso <lgl>, begin_area_id <chr>, begin_area_name <chr>,
#> #   begin_area_sort_name <chr>, begin_area_disambiguation <lgl>,
#> #   end_area_id <chr>, end_area_name <chr>, end_area_sort_name <chr>,
#> #   end_area_disambiguation <lgl>, life_span_begin <chr>,
#> #   life_span_end <chr>, life_span_ended <lgl>, ipis <chr>, isnis <lgl>
```

It looks like the first hit is what we need. We can use `dplyr` to extract the information of interest

``` r
miles_id <- miles_df %>% 
  select(mbid) %>%
  slice(1) %>% 
  pull()
```

### Lookup

Now that we have MusicBrainz id ("mbid") we can call the lookup function.

``` r
miles_lookup <- lookup_artist_by_id("561d854a-6a28-4aa7-8c99-323e6ce46c2a")
miles_lookup
#> # A tibble: 1 x 28
#>   mbid    type   type_id   score name  sort_name gender gender_id  country
#>   <chr>   <chr>  <chr>     <chr> <chr> <chr>     <chr>  <chr>      <chr>  
#> 1 561d85~ Person b6e035f4~ <NA>  Mile~ Davis, M~ Male   36d3d30a-~ US     
#> # ... with 19 more variables: disambiguation <chr>, area_id <chr>,
#> #   area_name <chr>, area_sort_name <chr>, area_disambiguation <chr>,
#> #   area_iso <chr>, begin_area_id <chr>, begin_area_name <chr>,
#> #   begin_area_sort_name <chr>, begin_area_disambiguation <chr>,
#> #   end_area_id <chr>, end_area_name <chr>, end_area_sort_name <chr>,
#> #   end_area_disambiguation <chr>, life_span_begin <chr>,
#> #   life_span_end <chr>, life_span_ended <lgl>, ipis <chr>, isnis <chr>
```

### Browse

We can also browse linked records (such as all releases by Miles Davis).

``` r
miles_releases <- browse_releases_by("artist", "561d854a-6a28-4aa7-8c99-323e6ce46c2a")
#> Returning releases 1 to 25 of 978
miles_releases
#> # A tibble: 25 x 17
#>    mbid   score count title  status status_id packaging packaging_id date 
#>    <chr>  <int> <lgl> <chr>  <chr>  <chr>     <chr>     <chr>        <chr>
#>  1 0f881~    NA NA    Blue ~ Offic~ 4e304316~ <NA>      <NA>         1954 
#>  2 16ed7~    NA NA    Miles~ Offic~ 4e304316~ Cardboar~ f7101ce3-03~ 1954 
#>  3 18912~    NA NA    Colle~ Offic~ 4e304316~ Cardboar~ f7101ce3-03~ 1956 
#>  4 2c6f3~    NA NA    Conce~ Offic~ 4e304316~ Cardboar~ f7101ce3-03~ 1956 
#>  5 2c9af~    NA NA    Birth~ Offic~ 4e304316~ <NA>      <NA>         1957~
#>  6 30392~    NA NA    'Roun~ Offic~ 4e304316~ Cardboar~ f7101ce3-03~ 1957~
#>  7 35aad~    NA NA    Miles~ Offic~ 4e304316~ Cardboar~ f7101ce3-03~ 1958 
#>  8 38bdd~    NA NA    Dig    Offic~ 4e304316~ <NA>      <NA>         1956 
#>  9 3a323~    NA NA    Miles~ Offic~ 4e304316~ <NA>      <NA>         1956 
#> 10 49aa1~    NA NA    Young~ <NA>   <NA>      <NA>      <NA>         1952 
#> # ... with 15 more rows, and 8 more variables: country <chr>,
#> #   disambiguation <chr>, barcode <chr>, asin <lgl>, track_count <lgl>,
#> #   quality <chr>, release_group_id <lgl>,
#> #   release_group_primary_type <lgl>
```

References
----------

1.  Details of the Musicbrainz database API: <https://musicbrainz.org/doc/Development/XML_Web_Service/Version_2>
2.  Details about rate limits: <https://musicbrainz.org/doc/XML_Web_Service/Rate_Limiting>
