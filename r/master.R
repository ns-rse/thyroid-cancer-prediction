## Filename    : master.R
## Description : Master file that controls running of all subsequent scripts.
library(tidyverse)

## Set directories based on current location
base_dir <- getwd()
data_dir <- paste(base_dir, "data", sep = "/")
csv_dir <- paste(data_dir, "csv", sep = "/")

## Read the data
df <- read_csv(paste(csv_dir, "Thy3000_DATA_LABELS_Raw.csv", sep = "/"))

colnames(df) <- c(
  "record_id",
  "center",
  "study_id",
  "referal_date"
)
