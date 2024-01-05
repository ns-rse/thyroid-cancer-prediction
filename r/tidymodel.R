## Filename : tidymodel.R
## Description : Use the Tidymodel framework to carry out predictive modelling for Thyroid Cancer
##
## NB : This file demonstrates the _workflow_ as the final dataset is not available. It is meant to serve as a
## demonstration on how to take a clean dataset (see examples in r/clean.R) and use it for predictive modelling using
## statistical methods such as logistic regression, Elastic Nets, Regression Trees, Gradient Boosting and so forth on
## data that has been split into a training and test cohort and levearging various different validation techniques.
##
## IMPORTANT : The approach taken here is very similar to that taught by Nicola Rennie on the R Pharma 2023 Conference
## workshop _Introduction to Machine Learning with {tidymodels}_.
##
## The following resources will therefore be useful...
##
## Slides : https://nrennie.github.io/r-pharma-2023-tidymodels/#/title-slide
## GitHub Repo : https://github.com/nrennie/r-pharma-2023-tidymodels


## Load the saved data set
library(tidyverse)
library(tidymodels)
library(dplyr)
library(ggplot2)
library(ggdark)
library(knitr)
library(tidyr)

## Two options we can either source the cleaning file...
# source("r/master.R")
## Or we can load the file that is saved at the end and use that
df <- readRDS("data/r/clean.rds")


## IMPORTANT
##
## Because the dataset that has been provided is not the final dataset and has very sparse numbers of observations where
## it has been possible to define the final_pathology we create some dummy data.
##
## This is done in the file r/simulate_data.R and this will NOT be needed in the final work.
source("r/simulate_data.R")




## Split Data
##
## We now split the data into test and training data using an explicit seed value to ensure we get the same results each
## time.
set.seed(5039378)
split <- initial_split(df, prop = 0.75)
train <- training(split)
test <- testing(split)

## Cross Validation
##
## We create cross validation folds on the training data set
folds <- vfold_cv(train, v = 10, repeats = 10)

## Build a Recipe
##
## In Tidymodels a recipe is a series of pre-processing steps that are taken
dummy_recipe <- df_dummy |>
  recipes::recipe(data = train) |>
  recipes::step_dummy() |>
  recipes::step_normalize(all_numeric())

## Create a Workflow
##
## Create a workflow consists of a recipe and different models. The recipe is run before models are and so we add the
## recipe to dummy_workflow and will later add models to it.
dummy_workflow <- workflows::workflow() |>
  workflows::add_recipe(dummy_recipe)


## LASSO, Ridge regression and Elastic Net
##
## We wish to perform logistic regression but it is well known that step-wise variable selection is highly problematic
## (they often result in over-fitting to the training data and are highly prone to the order in which variables are
## added/removed).  A better alternative is to use Least Absolute Shrinkage and Selection Operator (LASSO)
tune_lasso <- parsnip::logistic_reg(penalty = tune(), mixture)
