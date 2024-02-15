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
dummy <- simulate_data()
summary(dummy)

## Split Data
##
## We now split the data into test and training data using an explicit seed value to ensure we get the same results each
## time.
## Split Data
##
## We now split the data into test and training data using an explicit seed value to ensure we get the same results each
## time.
#| label: test-train-split
#| eval: true
#| echo: true
#| output: false
set.seed(5039378)
split <- rsample::initial_split(dummy, prop = 0.75)
train <- rsample::training(split)
test <- rsample::testing(split)

## Build a Recipe
##
## In Tidymodels a recipe is a series of pre-processing steps that are taken
#| label: recipe
#| eval: true
#| echo: true
#| output: false
thyroid_recipe <- recipes::recipe(final_pathology ~ gender + nodule_size + age + asa_score + smoking_status + nodule_fna_thy, data = train) |>
  # recipes::step_num2factor(final_pathology, levels = c("Benign", "Malignant")) |>
  recipes::step_dummy(gender, asa_score, smoking_status, nodule_fna_thy) |>
    recipes::step_normalize(all_numeric())


## Cross Validation
##
## We create cross validation folds on the training data set. There is vfold (often referred to as k-fold) and leave one
## out (loo) cross-validation created here.
#| label: cv-vfold
#| eval: true
#| echo: true
#| output: false
cv_folds <- rsample::vfold_cv(train, v = 10, repeats = 10)

#| label: cv-loo
#| eval: true
#| echo: true
#| output: false
cv_loo <- rsample::loo_cv(train)


## Create a Workflow
##
## Create a workflow consists of a recipe and different models. The recipe is run before models are and so we add the
## recipe to dummy_workflow and will later add models to it.
#| label: workflow
#| eval: true
#| echo: true
#| output: false
thyroid_workflow <- workflows::workflow() |>
    workflows::add_recipe(thyroid_recipe)


## LASSO, Ridge regression and Elastic Net
##
## We wish to perform logistic regression but it is well known that step-wise variable selection is highly problematic
## (they often result in over-fitting to the training data and are highly prone to the order in which variables are
## added/removed).  A better alternative is to use Least Absolute Shrinkage and Selection Operator (LASSO) or Ridge
## Regression. These are opposite ends of the spectrum in terms of two forms of penalties/regularisation termed L1 and
## L2. L1 is useful for feature selection as it allows/encourages coefficients for predictor variables in the model to
## tend towards zero, i.e. they have negligible effect. L2 regularisation helps when there are predictor variables that
## are collinear/co-dependant (i.e. correlated variables) which increases the variability of the coefficients.
##
## We fit the model using the parsnip::logistic_reg() function with a mixture value of 0.5 which gives an equal trade
## off to LASSO (L1) and Ridge Regression (L2) regularisation. This is termed an "Elastic Net", a value of 0 for mixture
##is full ridge-regression whilst a value of 1 is a full LASSO model (i.e. all L1 and no L2).
## The model is fitted using the "engine" glmnet.
#| label: lasso-specification
#| eval: true
#| echo: true
#| output: false
tune_spec_lasso <- parsnip::logistic_reg(penalty = hardhat::tune(), mixture = 0.5) |>
    parsnip::set_engine("glmnet")

## Cross validate the model; using tune::tune_grid(), this takes the worflow (thyroid_workflow) that has been defined
## along with the model we wish to fit (in terms of model type and parameters) and the cross validation we wish to
## perform and then fits the model repeatedly by sampling from the training data set.
#| label: lasso-kfold-tune
#| eval: true
#| echo: true
#| output: false
lasso_grid <- tune::tune_grid(
  object = workflows::add_model(thyroid_workflow, tune_spec_lasso),
  resamples = cv_folds,
  grid = dials::grid_regular(penalty(), levels = 50)
)

## We now extract the model with the best Receiver Operating Characterisitc Area Under the Curve...
#| label: lasso-kfold-best
#| eval: true
#| echo: true
#| output: false
lasso_kfold_roc_auc <- lasso_grid |>
    tune::select_best(metric = "roc_auc")

## ...and fit that model one last time to get our final LASSO model.
#| label: lasso-kfold-fit-final
#| eval: true
#| echo: true
#| output: false
final_lasso_kfold <- tune::finalize_workflow(
  workflows::add_model(thyroid_workflow, tune_spec_lasso),
  lasso_kfold_roc_auc
)


## We take that last fir and extract the metrics from it. Here the accuracy and ROC AUC are roughly 50% which means the
## ability to categorise people into "Malignant" or "Benign" based on the variables we chose is no better than chance
## alone. This is NOT surprising as we are currently working with simulated data!
#| label: lasso-kfold-eval-metrics
#| eval: true
#| echo: true
#| output: false
tune::last_fit(object = final_lasso_kfold, split = split) |>
    tune::collect_metrics()

## We can get an indication of the importance of variables in the model to see what the coefficients for each are.
#| label: lasso-kfold-eval-importance
#| eval: true
#| echo: true
#| output: false
final_lasso_kfold |>
  fit(train) |>
  hardhat::extract_fit_parsnip() |>
  vip::vi(lambda = lasso_kfold_roc_auc$penalty) |>
  dplyr::mutate(
    Importance = abs(Importance),
    Variable = fct_reorder(Variable, Importance)
  ) |>
  ggplot(mapping = aes(x = Importance, y = Variable, fill = Sign)) +
  geom_col() +
  dark_theme_minimal()

## The Tidymodel framework allows us to use the same workflow that we setup to easily run other types of modelling. Here
## we use a Random Forest to classify. Random Forests itteratively search through the variables to work out which
## provides the best method of classifying people into either "Malignant" or "Benign". It tries all variables in
## turn. For binary variables such as gender this is straight-forward. For continuous variables a number of different
## thresholds for dichotomising the variable are tested for each possible split and the optimal cut-point is selected.
## This process is repeated so that after for example after selecting gender to be a strong predictor the remaining
## variables will tested for their predictive ability and the best selected. The number of trees that are created and
## tested is defined by the 'trees' parameter which here is set to 100.
#| label: random-forest-specify
#| eval: true
#| echo: true
#| output: false
rf_tune <- parsnip::rand_forest(
    mtry = tune(),
    trees = 100,
    min_n = tune()) |>
  set_mode("classification") |>
    set_engine("ranger", importance = "impurity")

## As before the process is repeated using Cross validation.
#| label: random-forest-tune
#| eval: true
#| echo: true
#| output: false
rf_grid <- tune::tune_grid(
    add_model(thyroid_workflow, rf_tune),
    resamples = cv_folds, ## cv_loo,
    grid = grid_regular(mtry(range = c(5, 10)), # smaller ranges will run quicker
        min_n(range = c(2, 25)),
        levels = 3
    )
)
## ...and the best model based on the ROC AUC selected...
#| label: random-forest-model
#| eval: true
#| echo: true
#| output: false
rf_highest_roc_auc <- rf_grid |>
    select_best("roc_auc")
final_rf <- tune::finalize_workflow(
    add_model(thyroid_workflow, rf_tune),
    rf_highest_roc_auc
)

## ...and the metrics calculated.
#| label: random-forest-evaluate
#| eval: true
#| echo: true
#| output: false
tune::last_fit(final_rf, split) |>
    tune::collect_metrics()

#| label: rf-kfold-eval-importance
#| eval: true
#| echo: true
#| output: false
final_rf|>
  fit(train) |>
  hardhat::extract_fit_parsnip() |>
  vip::vi(lambda = final_rf$penalty) |>
  dplyr::mutate(
    Importance = abs(Importance),
    Variable = fct_reorder(Variable, Importance)
  ) |>
  ggplot(mapping = aes(x = Importance, y = Variable, fill = Sign)) +
  geom_col() +
  dark_theme_minimal()


#| label: svm-specify
#| eval: true
#| echo: true
#| output: false
svm_tune_spec <- svm_rbf(cost = tune()) |>
    set_engine("kernlab") |>
    set_mode("classification")

#| label: svm-tune-hyperparameters
#| eval: true
#| echo: true
#| output: false
svm_grid <-  tune::tune_grid(
  workflows::add_model(thyroid_workflow, svm_tune_spec),
  resamples = cv_folds, ## cv_loo,
  grid = dials::grid_regular(cost(), levels = 20)
)

#| label: svm-model
#| eval: true
#| echo: true
#| output: false
svm_highest_roc_auc <- svm_grid |>
  tune::select_best("roc_auc")
final_scm <- tune::finalize_workflow(
  add_model(thyroid_workflow, svm_tune_spec),
  svm_highest_roc_auc
)

#| label: svm-evaluate
#| eval: true
#| echo: true
#| output: false
tune::last_fit(final_rf, split,
               metrics = metric_set(roc_auuc, accuracy, f_meas)) |>
    tune::collect_metrics()

## Create a confusion matrix
