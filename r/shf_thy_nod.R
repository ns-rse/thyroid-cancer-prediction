## How to data into R studio, first save file as csv and save into file
## of interest on my computer, then import file into R studio, open a new script
## there will be a code that is provided on the console, copy this to the script
## to read file in R studio, save file into r folder and then ready to go
library(readr)
shf_data <- read_csv("data/csv/sheffield_thyroid_nodule.csv")
## create label for variables
