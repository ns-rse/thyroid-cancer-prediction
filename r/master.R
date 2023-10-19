## Filename    : master.R
## Description : Master file that controls running of all subsequent scripts.
library(tidyverse)

## Set directories based on current location
base_dir <- getwd()
data_dir <- paste0(base_dir, "data")
