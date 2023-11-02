## Filename : summary.R
## Description : Examples of how to summarise the data
##
## Useful references
##
## https://dplyr.tidyverse.org/articles/colwise.html introduces across()

df |>
  summarise(across(where(is.factor), nlevels))
