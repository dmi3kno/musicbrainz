## code to prepare `logo` dataset goes here
library(magick)
library(bunny)
# Image by <a href="https://pixabay.com/users/GDJ-1086657/">Gordon Johnson</a> from <a href="https://pixabay.com/">Pixabay</a>
img_b<- image_read_svg("data-raw/cranium-3244110.svg", width=5000)
# https://coolors.co/000000-b9baa3-d6d5c9-a22c29-902923 #FBFBEF

hex_br <-image_canvas_hex(border_color="#ffffff",
                          border_size = 1, fill_color = "#ffffff") %>%
  image_composite(img_b, offset="+0+210", gravity = "center") %>%
  image_transparent("black") %>%
  image_channel("alpha")

hex_canvas <- image_canvas_hex(border_color="#534B62", border_size = 1,
                               fill_color = "#96939B")

hex_border <- image_canvas_hexborder(border_color="#534B62", border_size = 4)

img_hex <- hex_canvas %>%
  image_composite(hex_br, gravity = "center", operator = "CopyOpacity")%>%
  image_annotate("musicbrainz", size=270, gravity = "center",
                 location = "+0-50", weight = 400,
                 font = "Aller", color = "#534B62") %>%
  bunny::image_compose(hex_border, gravity = "center", operator = "Over")
img_hex %>%
  image_scale("30%")

img_hex %>%
  image_scale("1200x1200") %>%
  image_write(here::here("data-raw", "mb_hex.png"), density = 600)

if(!dir.exists("man/figures"))
  dir.create("man/figures")

img_hex %>%
  image_scale("200x200") %>%
  image_write(here::here("man","figures","logo.png"), density = 600)

img_hex_gh <- img_hex %>%
  image_scale("400x400")

gh_logo <- bunny::github %>%
  image_scale("50x50")

gh <- image_canvas_ghcard("#EEE9EF") %>%
  image_compose(img_hex_gh, gravity = "East", offset = "+50+0") %>%
  image_annotate("What's on your mind?", gravity = "West", location = "+50-30",
                 color="#534B62", size=60, font="Aller", weight = 700) %>%
  image_compose(gh_logo, gravity="West", offset = "+50+40") %>%
  image_annotate("dmi3kno/musicbrainz", gravity="West", location="+120+45",
                 size=50, font="Ubuntu Mono") %>%
  image_border_ghcard("#EEE9EF")

gh

gh %>%
  image_write(here::here("data-raw", "mb_ghcard.png"))

