library(plyr)
library(dplyr)
library(tidyr)
library(rvest)

bundesligR_fetch <- function(season, url, node) {
  bl <- url %>%
    read_html() %>%
    html_nodes(node) %>%
    html_table() %>%
    .[[1]] %>%
    as_data_frame() %>%
    mutate(Season = as.numeric(season),
           Position = extract_numeric(Pl.),
           Team = gsub(" \\(.*", "", Verein),
           Team = str_replace_all(Team, "ä", "ae"),
           Team = str_replace_all(Team, "ö", "oe"),
           Team = str_replace_all(Team, "ü", "ue"),
           Team = str_replace_all(Team, "ß", "ss"),
           Played = extract_numeric(Sp.),
           W = extract_numeric(S),
           D = extract_numeric(U),
           L = extract_numeric(N),
           GF = Tore %>% strsplit(":") %>% lapply(`[[`, 1) %>% extract_numeric(),
           GA = Tore %>% strsplit(":") %>% lapply(`[[`, 2) %>% substr(1, 2) %>% extract_numeric(),
           GD = GF - GA,
           Points = 3*W + 1*D + 0*L,
           Pts_pre_95 = 2*W + 1*D + 0*L) %>%
    select(Season, Position, Team, Played, W, D, L, GF, GA, GD, Points, Pts_pre_95)
  return(bl)
}
