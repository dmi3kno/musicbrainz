
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/musicbrainz)](http://cran.r-project.org/package=musicbrainz)

musicbrainz
===========

The goal of musicbrainz is to make it easy to call the MusicBrainz Database API from R.

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
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

miles_df <- search_artists("Miles Davis")
#> Returning artists 1 to 25 of 1790
miles_df
#> # A tibble: 25 x 28
#>    mbid     type  type_id score name   sort_name  gender gender_id country
#>    <chr>    <chr> <lgl>   <int> <chr>  <chr>      <chr>  <lgl>     <chr>  
#>  1 561d854~ Pers~ NA        100 Miles~ Davis, Mi~ male   NA        US     
#>  2 f137837~ Group NA         87 Miles~ Davis, Mi~ <NA>   NA        <NA>   
#>  3 03606de~ Group NA         87 Miles~ Davis, Mi~ <NA>   NA        <NA>   
#>  4 16d2b8e~ Group NA         87 The M~ Davis, Mi~ <NA>   NA        <NA>   
#>  5 607d727~ Group NA         87 Miles~ Davis, Mi~ <NA>   NA        <NA>   
#>  6 fe7245e~ Group NA         87 Miles~ Davis, Mi~ <NA>   NA        US     
#>  7 47c342e~ <NA>  NA         81 Miles~ Miles Dav~ <NA>   NA        <NA>   
#>  8 c52ff92~ Group NA         80 Miles~ Davis, Mi~ <NA>   NA        <NA>   
#>  9 8813087~ Group NA         76 Miles~ Davis, Mi~ <NA>   NA        <NA>   
#> 10 72f2e1f~ Group NA         76 Miles~ Davis, Mi~ <NA>   NA        <NA>   
#> # ... with 15 more rows, and 19 more variables: disambiguation <chr>,
#> #   area_id <chr>, area_name <chr>, area_sort_name <chr>,
#> #   area_disambiguation <lgl>, area_iso <lgl>, begin_area_id <chr>,
#> #   begin_area_name <chr>, begin_area_sort_name <chr>,
#> #   begin_area_disambiguation <lgl>, end_area_id <chr>,
#> #   end_area_name <chr>, end_area_sort_name <chr>,
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
#> Returning releases 1 to 25 of 973
miles_releases
#> # A tibble: 25 x 17
#>    mbid   score count title  status status_id packaging packaging_id date 
#>    <chr>  <int> <lgl> <chr>  <chr>  <chr>     <chr>     <chr>        <chr>
#>  1 019aa~    NA NA    Walki~ Offic~ 4e304316~ <NA>      <NA>         1954 
#>  2 0f881~    NA NA    Blue ~ Offic~ 4e304316~ <NA>      <NA>         1954 
#>  3 16ed7~    NA NA    Miles~ Offic~ 4e304316~ Cardboar~ f7101ce3-03~ 1954 
#>  4 18912~    NA NA    Colle~ Offic~ 4e304316~ Cardboar~ f7101ce3-03~ 1956 
#>  5 2c6f3~    NA NA    Conce~ Offic~ 4e304316~ Cardboar~ f7101ce3-03~ 1956 
#>  6 2c9af~    NA NA    Birth~ Offic~ 4e304316~ <NA>      <NA>         1957~
#>  7 30392~    NA NA    'Roun~ Offic~ 4e304316~ Cardboar~ f7101ce3-03~ 1957~
#>  8 35aad~    NA NA    Miles~ Offic~ 4e304316~ Cardboar~ f7101ce3-03~ 1958 
#>  9 38bdd~    NA NA    Dig    Offic~ 4e304316~ <NA>      <NA>         1956 
#> 10 3a323~    NA NA    Miles~ Offic~ 4e304316~ <NA>      <NA>         1956 
#> # ... with 15 more rows, and 8 more variables: country <chr>,
#> #   disambiguation <chr>, barcode <chr>, asin <lgl>, track_count <lgl>,
#> #   quality <chr>, release_group_id <lgl>,
#> #   release_group_primary_type <lgl>
```
