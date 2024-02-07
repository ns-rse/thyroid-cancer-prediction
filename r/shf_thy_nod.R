## How to data into R studio, first save file as csv and save into file
## of interest on my computer, then import file into R studio, open a new script
## there will be a code that is provided on the console, copy this to the script
## to read file in R studio, save file into r folder and then ready to go
library(readr)
shf_data <- read_csv("data/csv/sheffield_thyroid_nodule.csv")
## changing names of variables
var_labels <- c(
  study_id = "Study ID", age_at_scan = "Age", ethinicity = "Ethinicity",
  eligibility = "Eligibility", incidental_nodule = "Incidental nodule",
  palpable_nodule = "Palbaple nodule", rapid_enlargement = "Rapid enlargement",
  compressive_symtoms = "Compressive symptoms", hypertension = "Hypertension",
  vocal_cord_paresis = "Vocal cord paresis", graves_disease = "Graves' disease",
  hashimotos_thyroiditis = "Hashimoto's disease", family_history_thyroid_cancer =
    "Family history of thyroid cancer", exposure_radiation = "Exposure to radiation",
  albumin = "Albumin", tsh_value = "TSH value", lymphocytes = "Lymphocytes",
  monocyte = "Monocytes", bta_u_classification = "BTA U", size_nodule_mm = "Nodule size",
  consistency_nodule = "Nodule consistency", cervical_lymphadenopathy = "Cervical Lymphadenopathy",
  repeat_ultrasound = "Repeat ultrasound", repeat_bta_u_classification = "Repeat BTA U",
  fna_done = "FNA done", thy_classification = "Thy classification", repeat_fna_done = "Repeat FNA",
  repeat_thy_classification = "Repeat Thy class", thyroid_surgery = "Thyroid surgery",
  thyroid_histology_diagnosis = "Histology", final_pathology = "Final diagnosis"
)
## my data set to a data frame so I can compare it to original file (shf_raw)
shf <- tibble(shf_data)
Hmisc::label(shf) <- as.list(var_labels[match(names(shf), names(var_labels))])
## inspect data type for each variable
lapply(shf, typeof)
