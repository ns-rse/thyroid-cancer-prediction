## Filename : clean.R
## Description : Load and clean raw data, saving as a .RData file for subsequent analyses.

## Read the data and convert to tibble
df_raw <- read_csv(paste(csv_dir, "Thy3000_DATA_LABELS_Raw.csv", sep = "/"))
df_raw <- as_tibble(df_raw)
## Rename columns using dplyr::rename()
df_raw <- dplyr::rename(df_raw,
  record_id = "Record ID",
  data_access_group = "Data Access Group",
  study_id = "Study ID",
  date_referral = "1.1 Date of referral",
  clinic_recruiting = "1.2 Which clinic was the patient recruited from?",
  clinic_recruiting_other = "If Other",
  date_clinic = "1.3. The date the patient was seen in clinic",
  referral_source = "1.4 Referral source",
  referral_source_other = "If Other, please specify",
  two_week_wait_referral = "1.4.1 If GP, was it 2-week wait referral?",
  presentation = "1.5. Presentation",
  presentation_complete = "Complete?...12",
  age = "2.1. Age of the patient when seen in clinic",
  bmi = "2.2. Body Mass Index of patient",
  smoking_status = "2.3. Smoking status",
  previous_neck_irradiation = "2.4. Previous neck irradiation",
  asa_score = "2.5 American Society of Anaesthesiologist (ASA) score",
  presentation_complete2 = "Complete?...18",
  neck_symptoms = "3.1. Presentation (choice=Neck symptoms)",
  incidental_lesion = "3.1. Presentation (choice=Incidental lesion on imaging)",
  hyperthyroidism = "3.1. Presentation (choice=HypErthyroidism on thyroid function test)",
  hypothyroidism = "3.1. Presentation (choice=HypOthyroidism on thyroid function test)",
  abnormal_thyroid_function = "3.1. Presentation (choice=Symptoms of abnormal thyroid function)",
  presentation_not_known = "3.1. Presentation (choice=Not known)",
  presentation_other = "3.1. Presentation (choice=Other)",
  presentation_other_value = "If other, please specify...26",
  no_symptoms = "3.1.1 Symptomatology (choice=No symptoms)",
  neck_lump = "3.1.1 Symptomatology (choice=Neck lump (noted by patient, family or doctor))",
  compressive_symptoms = paste0(
    "3.1.1 Symptomatology (choice=Compressive symptoms (breathing or ",
    "swallowing difficulty or voice change))"
  ),
  thyroid_dysfunction = "3.1.1 Symptomatology (choice=Symptoms of thyroid dysfunction)",
  symptoms_other = "3.1.1 Symptomatology (choice=Other)",
  symptoms_other_value = "If other, please specify...32",
  incidental_imaging = "3.1.2 Was this nodule found incidentally on imaging?",
  incidental_imaging_type = "If yes, what imaging",
  clinical_assessment = "3.2 Clinical Assessment",
  retrosternal = "3.2.1 Retrosternal on clinical examination",
  palpable_lymphadenopathy = "3.2.2 Palpable lymphadenopathy",
  nodule_rapid_growth = "3.2.3 Patient perception of rapid growth of nodule",
  thyroid_function_3months = "3.4 Thyroid function tests done within 3 months of presentation to clinic",
  ultrasound = "3.5 Ultrasound performed",
  nodule_maxmimum_diameter_mm = paste0(
    "3.5.1 Reported maximum diameter of the largest thyroid nodule on ",
    "ultrasound in millimetres"
  ),
  nodule_ultrasound_description = "3.5.2 Description of thyroid nodule(s) on ultrasound",
  nodule_ultrasound_u_stage = "3.5.3 If Ultrasound performed, U stage reported:",
  nodule_ultrasound_tirads = "3.5.4 If Ultrasound performed, TIRADS reported",
  nodule_ultrasound_lymphadenopathy = "3.5.5 If Ultrasound performed, was lymphadenopathy documented",
  elastography = "3.5.6 Elastography performed",
  ct_neck = "3.5.7 CT neck performed",
  ct_neck_local_invasion = paste0(
    "3.5.8 If CT neck performed, reason for performing it ",
    "(choice=Extrathyroid extention/local invasion)"
  ),
  ct_neck_plan_surgical_approach = paste0(
    "3.5.8 If CT neck performed, reason for performing it ",
    "(choice=Retrosternal extension/plan surgical approach)"
  ),
  ct_neck_lymphadenopathy_extent = paste0(
    "3.5.8 If CT neck performed, reason for performing it ",
    "(choice=Extent of lymphadenopathy)"
  ),
  ct_neck_tracheal_compression = paste0(
    "3.5.8 If CT neck performed, reason for performing it ",
    "(choice=Tracheal compression)"
  ),
  ct_neck_unknown = paste0(
    "3.5.8 If CT neck performed, reason for performing it ",
    "(choice=Not known)"
  ),
  ct_neck_unrelated = paste0(
    "3.5.8 If CT neck performed, reason for performing it ",
    "(choice=Unrelated to thyroid pathology)"
  ),
  mri_neck = "3.5.9 MRI neck performed",
  mri_neck_local_invasion = paste0(
    "3.5.10 If MRI neck performed, reason for performing it ",
    "(choice=Extrathyroid extention/local invasion)"
  ),
  mri_neckplan_surgical_approach = paste0(
    "3.5.10 If MRI neck performed, reason for performing it ",
    "(choice=Retrosternal extension/plan surgical approach)"
  ),
  mri_neck_lymphadenopathy_extent = paste0(
    "3.5.10 If MRI neck performed, reason for performing it ",
    "(choice=Extent of lymphadenopathy)"
  ),
  mri_neck_tracheal_compression = paste0(
    "3.5.10 If MRI neck performed, reason for performing it ",
    "(choice=Tracheal compression)"
  ),
  mri_neck_unknown = paste0(
    "3.5.10 If MRI neck performed, reason for performing it ",
    "(choice=Not known)"
  ),
  mri_neck_unrelated = paste0(
    "3.5.10 If MRI neck performed, reason for performing it ",
    "(choice=Unrelated to thyroid pathology)"
  ),
  iodine_scan = "3.5.11 Iodine-123 scan performed",
  nodule_fna = "3.6. FNA of thyroid nodule performed (either at time of ultrasound or later)",
  nodule_fna_result = "3.6.1 If FNA performed, was Thy or Bethesda stage reported",
  nodule_fna_thy = "3.6.1.1 Thy result",
  nodule_fna_bethesda = "3.6.1.2 Bethesda result",
  core_biopsy = "3.7 Core biopsy performed",
  lymph_node_fna = "3.8 FNA of lymph node performed",
  lymph_node_fna_result = "3.8.1 If FNA lymph node performed, result",
  assessment_complete = "Complete?...69",
  initial_management_decision = "4.1 Initial management decision",
  date_initial_management_decision = "4.2 Date of decision (either clinic letter or MDT date)",
  date_treatment = "4.3 Date of surgery or start of other treatment (if interventional)",
  routine_review_offered = "4.4. In case of no intervention, was a routine review offered",
  routine_review_offered_interval_weeks = "4.4.1 If yes, what was the planned interval (in weeks)",
  routine_review_ultrasound = "4.4.2 Was Ultrasound repeated at routine review?",
  routine_review_fna = "4.4.3 Was FNA repeated at routine review",
  routine_review_management_strategy_review = paste0(
    "4.4.4 If routine review performed, was management ",
    "strategy changed at review"
  ),
  routine_review_management_revised = "4.4.4.1 If management strategy changed at review, revised management decision",
  routine_review_management_revised_reason = "4.4.4.2 If yes, reason for change in management",
  routine_review_management_revised_reason_other = "If other",
  routine_review_date_last_seen = "4.4.4.3 If no change in management decision: date last seen by 'thyroid' team",
  routine_review_confirm_management_plan = paste0(
    "4.4.4.4 If no change in management strategy at review, confirm ",
    "management plan when last seen"
  ),
  routine_review_patient_signposting_information = paste0(
    "4.4.5 Patient was signposted to appropriate patient ",
    "SUPPORT organisation  and/or provided with written PATIENT ",
    "information about thyroid nodules (including leaflets)"
  ),
  routine_review_complete = "Complete?...84",
  thyroid_surgery = "5.1 Type of thyroid surgery",
  thyroid_surgery_lymph_node_dissection = "5.1.1 Lymph node dissection done at this surgery",
  thyroid_surgery_lymph_node_pathology = "5.1.2 Pathology",
  thyroid_surgery_lymph_node_pathology_other_type = "If other cancer/other diagnosis, please state",
  thyroid_surgery_complete = "Complete?...89"
)

## Label variables, we simply use the original column names as labels
var_labels <- c(
  record_id = "Record ID",
  data_access_group = "Data Access Group",
  study_id = "Study ID",
  date_referral = "1.1 Date of referral",
  clinic_recruiting = "1.2 Which clinic was the patient recruited from?",
  clinic_recruiting_other = "If Other",
  date_clinic = "1.3. The date the patient was seen in clinic",
  referral_source = "1.4 Referral source",
  referral_source_other = "If Other, please specify",
  two_week_wait_referral = "1.4.1 If GP, was it 2-week wait referral?",
  presentation = "1.5. Presentation",
  presentation_complete = "Complete?...12",
  age = "2.1. Age of the patient when seen in clinic",
  bmi = "2.2. Body Mass Index of patient",
  smoking_status = "2.3. Smoking status",
  previous_neck_irradiation = "2.4. Previous neck irradiation",
  asa_score = "2.5 American Society of Anaesthesiologist (ASA) score",
  presentation_complete2 = "Complete?...18",
  neck_symptoms = "3.1. Presentation (choice=Neck symptoms)",
  incidental_lesion = "3.1. Presentation (choice=Incidental lesion on imaging)",
  hyperthyroidism = "3.1. Presentation (choice=HypErthyroidism on thyroid function test)",
  hypothyroidism = "3.1. Presentation (choice=HypOthyroidism on thyroid function test)",
  abnormal_thyroid_function = "3.1. Presentation (choice=Symptoms of abnormal thyroid function)",
  presentation_not_known = "3.1. Presentation (choice=Not known)",
  presentation_other = "3.1. Presentation (choice=Other)",
  presentation_other_value = "If other, please specify...26",
  no_symptoms = "3.1.1 Symptomatology (choice=No symptoms)",
  neck_lump = "3.1.1 Symptomatology (choice=Neck lump (noted by patient, family or doctor))",
  compressive_symptoms = paste0(
    "3.1.1 Symptomatology (choice=Compressive symptoms (breathing or ",
    "swallowing difficulty or voice change))"
  ),
  thyroid_dysfunction = "3.1.1 Symptomatology (choice=Symptoms of thyroid dysfunction)",
  symptoms_other = "3.1.1 Symptomatology (choice=Other)",
  symptoms_other_value = "If other, please specify...32",
  incidental_imaging = "3.1.2 Was this nodule found incidentally on imaging?",
  incidental_imaging_type = "If yes, what imaging",
  clinical_assessment = "3.2 Clinical Assessment",
  retrosternal = "3.2.1 Retrosternal on clinical examination",
  palpable_lymphadenopathy = "3.2.2 Palpable lymphadenopathy",
  nodule_rapid_growth = "3.2.3 Patient perception of rapid growth of nodule",
  thyroid_function_3months = "3.4 Thyroid function tests done within 3 months of presentation to clinic",
  ultrasound = "3.5 Ultrasound performed",
  nodule_maxmimum_diameter_mm = paste0(
    "3.5.1 Reported maximum diameter of the largest thyroid nodule on ",
    "ultrasound in millimetres"
  ),
  nodule_ultrasound_description = "3.5.2 Description of thyroid nodule(s) on ultrasound",
  nodule_ultrasound_u_stage = "3.5.3 If Ultrasound performed, U stage reported:",
  nodule_ultrasound_tirads = "3.5.4 If Ultrasound performed, TIRADS reported",
  nodule_ultrasound_lymphadenopathy = "3.5.5 If Ultrasound performed, was lymphadenopathy documented",
  elastography = "3.5.6 Elastography performed",
  ct_neck = "3.5.7 CT neck performed",
  ct_neck_local_invasion = paste0(
    "3.5.8 If CT neck performed, reason for performing it ",
    "(choice=Extrathyroid extention/local invasion)"
  ),
  ct_neck_plan_surgical_approach = paste0(
    "3.5.8 If CT neck performed, reason for performing it ",
    "(choice=Retrosternal extension/plan surgical approach)"
  ),
  ct_neck_lymphadenopathy_extent = paste0(
    "3.5.8 If CT neck performed, reason for performing it ",
    "(choice=Extent of lymphadenopathy)"
  ),
  ct_neck_tracheal_compression = paste0(
    "3.5.8 If CT neck performed, reason for performing it ",
    "(choice=Tracheal compression)"
  ),
  ct_neck_unknown = paste0(
    "3.5.8 If CT neck performed, reason for performing it ",
    "(choice=Not known)"
  ),
  ct_neck_unrelated = paste0(
    "3.5.8 If CT neck performed, reason for performing it ",
    "(choice=Unrelated to thyroid pathology)"
  ),
  mri_neck = "3.5.9 MRI neck performed",
  mri_neck_local_invasion = paste0(
    "3.5.10 If MRI neck performed, reason for performing it ",
    "(choice=Extrathyroid extention/local invasion)"
  ),
  mri_neckplan_surgical_approach = paste0(
    "3.5.10 If MRI neck performed, reason for performing it ",
    "(choice=Retrosternal extension/plan surgical approach)"
  ),
  mri_neck_lymphadenopathy_extent = paste0(
    "3.5.10 If MRI neck performed, reason for performing it ",
    "(choice=Extent of lymphadenopathy)"
  ),
  mri_neck_tracheal_compression = paste0(
    "3.5.10 If MRI neck performed, reason for performing it ",
    "(choice=Tracheal compression)"
  ),
  mri_neck_unknown = paste0(
    "3.5.10 If MRI neck performed, reason for performing it ",
    "(choice=Not known)"
  ),
  mri_neck_unrelated = paste0(
    "3.5.10 If MRI neck performed, reason for performing it ",
    "(choice=Unrelated to thyroid pathology)"
  ),
  iodine_scan = "3.5.11 Iodine-123 scan performed",
  nodule_fna = "3.6. FNA of thyroid nodule performed (either at time of ultrasound or later)",
  nodule_fna_result = "3.6.1 If FNA performed, was Thy or Bethesda stage reported",
  nodule_fna_thy = "3.6.1.1 Thy result",
  nodule_fna_bethesda = "3.6.1.2 Bethesda result",
  core_biopsy = "3.7 Core biopsy performed",
  lymph_node_fna = "3.8 FNA of lymph node performed",
  lymph_node_fna_result = "3.8.1 If FNA lymph node performed, result",
  assessment_complete = "Complete?...69",
  initial_management_decision = "4.1 Initial management decision",
  date_initial_management_decision = "4.2 Date of decision (either clinic letter or MDT date)",
  date_treatment = "4.3 Date of surgery or start of other treatment (if interventional)",
  routine_review_offered = "4.4. In case of no intervention, was a routine review offered",
  routine_review_offered_interval_weeks = "4.4.1 If yes, what was the planned interval (in weeks)",
  routine_review_ultrasound = "4.4.2 Was Ultrasound repeated at routine review?",
  routine_review_fna = "4.4.3 Was FNA repeated at routine review",
  routine_review_management_strategy_review = paste0(
    "4.4.4 If routine review performed, was management ",
    "strategy changed at review"
  ),
  routine_review_management_revised = "4.4.4.1 If management strategy changed at review, revised management decision",
  routine_review_management_revised_reason = "4.4.4.2 If yes, reason for change in management",
  routine_review_management_revised_reason_other = "If other",
  routine_review_date_last_seen = "4.4.4.3 If no change in management decision: date last seen by 'thyroid' team",
  routine_review_confirm_management_plan = paste0(
    "4.4.4.4 If no change in management strategy at review, confirm ",
    "management plan when last seen"
  ),
  routine_review_patient_signposting_information = paste0(
    "4.4.5 Patient was signposted to appropriate patient ",
    "SUPPORT organisation  and/or provided with written PATIENT ",
    "information about thyroid nodules (including leaflets)"
  ),
  routine_review_complete = "Complete?...84",
  thyroid_surgery = "5.1 Type of thyroid surgery",
  thyroid_surgery_lymph_node_dissection = "5.1.1 Lymph node dissection done at this surgery",
  thyroid_surgery_lymph_node_pathology = "5.1.2 Pathology",
  thyroid_surgery_lymph_node_pathology_other_type = "If other cancer/other diagnosis, please state",
  thyroid_surgery_complete = "Complete?...89"
)
## , we assign it to df so that we can compare values in df_raw to the cleaned data
## and make sure what we are doing makes sense.
df <- tibble(df_raw)
Hmisc::label(df) <- as.list(var_labels[match(names(df), names(var_labels))])

## Inspect the data types of each variables
lapply(df, typeof)

## Convert dates to elapsed dates using lubridate
df <- df |>
  mutate(
    date_referral = lubridate::dmy(date_referral),
    date_clinic = lubridate::dmy(date_clinic),
    date_initial_management_decision = lubridate::dmy(date_initial_management_decision),
    date_treatment = lubridate::dmy(date_treatment),
    routine_review_date_last_seen = lubridate::dmy(routine_review_date_last_seen)
  )

## Convert variables that are meant to be numeric but aren't
df <- df |>
  mutate(
    bmi = as.numeric(bmi),
    nodule_maxmimum_diameter_mm = as.numeric(nodule_maxmimum_diameter_mm)
  )

## Convert all binary variables Checked/Unchecked/Not Known to TRUE/FALSE/NA
## This uses dplyr::mutate() and instead of muitating every variable we use dply::across() to repeat the dplyr::recode()
## across all variables
df <- df |>
  dplyr::mutate(
    neck_symptoms = dplyr::recode(neck_symptoms,
      "Checked" = 1,
      "Unchecked" = 0,
      "Not Known" = NA_real_
    ),
    incidental_lesion = dplyr::recode(incidental_lesion,
      "Checked" = 1,
      "Unchecked" = 0,
      "Not Known" = NA_real_
    )
    ## TODO - Add remaining binary variables listed below or get the below example using across() working. This would
    ## take a long time of copying and pasting and changing the variable names, a bit boring and tedious.
  )

## The following is a more succinct way (there are often more succinct ways of doing things than writing them all out,
## the trick is learning them).
##
## 1. Make a list of variables tha are Checked/Unchecked/Not Known
## 2. Use the mutate() function but apply it across(all_of()) this list.
## 3. Apply the dplyr::recode() function to each of these columns
check_cols <- c(
  "neck_symptoms",
  "incidental_lesion",
  "hyperthyroidism",
  "hypothyroidism",
  "abnormal_thyroid_function",
  "presentation_not_known",
  "presentation_other",
  "no_symptoms",
  "neck_lump",
  "compressive_symptoms",
  "thyroid_dysfunction",
  "symptoms_other",
  "ct_neck_local_invasion",
  "ct_neck_plan_surgical_approach",
  "ct_neck_lymphadenopathy_extent",
  "ct_neck_tracheal_compression",
  "ct_neck_unknown",
  "ct_neck_unrelated",
  "mri_neck_local_invasion",
  "mri_neckplan_surgical_approach",
  "mri_neck_lymphadenopathy_extent",
  "mri_neck_tracheal_compression",
  "mri_neck_unknown",
  "mri_neck_unrelated",
  "assessment_complete",
  "routine_review_patient_signposting_information",
  "routine_review_complete",
  "thyroid_surgery_lymph_node_dissection",
  "thyroid_surgery_complete"
)
df <- df |>
  dplyr::mutate(dplyr::across(dplyr::all_of(check_cols), ~ dplyr::recode(.x,
    "Checked" = 1,
    "Unchecked" = 0,
    "Not Known" = NA_real_
  )))
## Other columns are Yes/Now/Unknown so we tidy those up now too in the same manner.
check_cols <- c(
  "previous_neck_irradiation",
  "incidental_imaging",
  "retrosternal",
  "palpable_lymphadenopathy",
  "nodule_rapid_growth",
  "thyroid_function_3months",
  "ultrasound",
  "elastography",
  "ct_neck",
  "mri_neck",
  "iodine_scan",
  "nodule_fna",
  "core_biopsy",
  "routine_review_ultrasound",
  "routine_review_fna",
  "routine_review_patient_signposting_information"
)
df <- df |>
  dplyr::mutate(across(all_of(check_cols), ~ dplyr::recode(.x,
    "Yes" = 1,
    "No" = 0,
    "Not Known" = NA_real_
  )))
## Its good practice to check that your encoding has been done correctly, as you wrote you want to make sure its
## worked. Because we have stored the original in df_raw we can compare variables.
##
## If we tabulate the same variable from each data frame we should have the same numbers...
df_raw$iodine_scan |> table()
df$iodine_scan |> table()


## Categorical variables
##
## These can't be simplified to using across() (if it worked!) since each variable has different values and we are
## instead using the as.factor() function to convert to categorical variables which means internally R recodes strings
## to numerical variables and adds labels to each.
df <- df |>
  dplyr::mutate(
    data_access_group = as.factor(data_access_group),
    asa_score = recode("Not known" = NA_real_),
    asa_score = as.factor(asa_score)
  )

## ToDo - Inspect each of the variables listed below and determine how they need handling to convert to a factor.
##
## This can be done for example by looking at the values using table()
##
df$referral_source |> table()
##
## Some need more cleaning than others, for example df$referral_source_other has GP etnered in multiple different ways..
##
df$referral_source_other |> table()
##
## ...and so you are likely to want to correct this first as with the above asa_score being recoded first.
##
## Its unlikely this particular value is needed but you may want to create a level in df$referral_source that is "GP"
## based on the multiple different values of df$referral_source_other


## data_access_group
## clinic_recruiting
## clinic_recruiting_other
## referral_source
## referral_source_other
## two_week_wait_referral
## smoking_status
## previous_neck_irradiation
## asa_score (possibly numeric)
## presentation_other_value
## symptoms_other_value
## incidental_imaging_type
## clinical_assessment
## nodule_ultrasound_description
## nodule_ultrasound_u_stage
## nodule_ultrasound_tirads
## nodule_ultrasound_lymphadenopathy
## nodule_fna_result (Thy, Bethesda, Not done)
## nodule_fna_thy
## nodule_dna_bethesda (Not Applicable)
## lymph_node_fna_result
## initial_management_decision
## routine_review_offered
## routine_review_offered_interval_weeks
## routine_review_ultrasound
## routine_review_dna
## routine_review_management_strategy_review
## routine_review_management_revised
## routine_review_management_revised_reason
## routine_review_confirm_management_plan
## thyroid_surgery
## thyroid_surgery_lymph_node_pathology




## Free text fields
##
## presentation
## routine_review_management_revised_reason_other
## thyroid_surgery_lymph_node_pathology_other_type
