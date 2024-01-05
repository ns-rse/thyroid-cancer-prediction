## Filename : simulate_data.R
## Description : Generates dummy variables for the purpose of demonstrating modelling workflow
##
## The code here was guided by the article https://www.r-bloggers.com/2021/05/how-to-generate-correlated-data-in-r/



## Load the saved data set
library(MASS)
library(tidyverse)
library(tidymodels)
library(ggdark)
library(knitr)
library(tidyr)

## Two options we can either source the cleaning file...
# source("r/master.R")
## Or we can load the file that is saved at the end and use that
df <- readRDS("data/r/clean.rds")

## Set a seed for random number generation. This ensures we get the same results each time the code is run.
set.seed(17010880)

## Create a varianc co-variance matrix
sigma <- rbind(
  c(1.1265924, 0.6387496, -0.2630270, 0.2875068),
  c(0.6387496, 1.2053968, 0.8055271, -0.2540865),
  c(0.2630270, 0.8055271, 1.1482047, -0.4735176),
  c(0.2875068, -0.2540865, -0.4735176, 1.0012329)
)
det(sigma)

## Generate the mean vector
mu <- c(44, 10, 6, 3)

## Generate the multivariate normal distribution
dummy <- as.data.frame(MASS::mvrnorm(n = nrow(df), mu = mu, Sigma = sigma))

## Generate binary outcome variable with noise
dummy <- dummy |>
  mutate(
    final_pathology_dummy = ifelse(V4 > median(V4),
      sample(c(0, 1), n(), replace = TRUE, p = c(0.25, 0.75)),
      sample(c(0, 1), n(), replace = TRUE, p = c(0.75, 0.25))
    ),
    ## final_pathology_dummy = case_when(
    ##   V4 <= median(V4) ~ sample(c("Bengin", "Malignant"),
    ##     n(),
    ##     replace = TRUE,
    ##     p = c(0.25, 0.75)),
    ##   TRUE ~ sample(c("Bengin", "Malignant"),
    ##     n(),
    ##     replace = TRUE,
    ##     p = c(0.75, 0.25))),
    dummy_cat_1 = case_when(
      V3 < quantile(V3, 0.25) ~ sample(c("a", "b", "c", "d"),
        n(),
        replace = TRUE,
        p = c(0.7, 0.1, 0.1, 0.1)
      ),
      V3 < quantile(V3, 0.50) ~ sample(c("a", "b", "c", "d"),
        n(),
        replace = TRUE,
        p = c(0.1, 0.7, 0.1, 0.1)
      ),
      V3 < quantile(V3, 0.75) ~ sample(c("a", "b", "c", "d"),
        n(),
        replace = TRUE,
        p = c(0.1, 0.1, 0.7, 0.1)
      ),
      TRUE ~ sample(c("a", "b", "c", "d"),
        n(),
        replace = TRUE,
        p = c(0.1, 0.1, 0.7, 0.1)
      )
    ),
    dummy_cat_2 = case_when(
      V2 < quantile(V2, 0.15) ~ sample(c("I", "II", "III", "IV"),
        n(),
        replace = TRUE,
        p = c(0.8, 0.1, 0.05, 0.05)
      ),
      V2 < quantile(V2, 0.65) ~ sample(c("I", "II", "III", "IV"),
        n(),
        replace = TRUE,
        p = c(0.1, 0.8, 0.05, 0.05)
      ),
      V2 < quantile(V2, 0.85) ~ sample(c("I", "II", "III", "IV"),
        n(),
        replace = TRUE,
        p = c(0.1, 0.05, 0.8, 0.05)
      ),
      TRUE ~ sample(c("I", "II", "III", "IV"),
        n(),
        replace = TRUE,
        p = c(0.1, 0.05, 0.05, 0.8)
      )
    )
  )
GGally::ggpairs(dummy)

df_dummy <- cbind(df, dummy)
