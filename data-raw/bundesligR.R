library(plyr)

bundesligR <- lapply(bundesligR_links, function(x) bundesligR_fetch(x[1], x[2], x[3]))
bundesligR <- rbind.fill(bundesligR)

devtools::use_data(bundesligR, pkg = ".", overwrite = TRUE)
