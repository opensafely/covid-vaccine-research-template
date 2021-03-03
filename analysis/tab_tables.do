**********************************************
*************** IMPORT DATA ******************
**********************************************

// Please note this dataset is currently importing synthetic data. Please
// change the path for different datasets. 
import delimited /Users/carolinemorton/Documents/ebmdatalab/covid19/covid-vaccine-research-template/output/input.csv, clear


**********************************************
*************** DATA PROCESS *****************
**********************************************

// Change vaccine dates to binary values
gen vaccine_ever_bin = 0
replace vaccine_ever_bin = 1 if covid_vax_1_date != ""

gen vaccine_2nd_dose_bin = 0
replace vaccine_2nd_dose_bin = 1 if covid_vax_2_date != ""

gen vaccine_3rd_dose_bin = 0
replace vaccine_3rd_dose_bin = 1 if covid_vax_3_date != ""

gen vaccine_4th_dose_bin = 0
replace vaccine_4th_dose_bin = 1 if covid_vax_4_date != ""

gen pfizer_1st_dose_bin = 0
replace pfizer_1st_dose_bin = 1 if covid_vax_pfizer_1_date != ""

gen pfizer_2nd_dose_bin = 0
replace pfizer_2nd_dose_bin = 1 if covid_vax_pfizer_2_date != ""

gen pfizer_3rd_dose_bin = 0
replace pfizer_3rd_dose_bin = 1 if covid_vax_pfizer_3_date != ""

gen pfizer_4th_dose_bin = 0
replace pfizer_4th_dose_bin = 1 if covid_vax_pfizer_4_date != ""

gen oxford_1st_dose_bin = 0
replace oxford_1st_dose_bin = 1 if covid_vax_az_1_date != ""

gen oxford_2nd_dose_bin = 0
replace oxford_2nd_dose_bin = 1 if covid_vax_az_2_date != ""

gen oxford_3rd_dose_bin = 0
replace oxford_3rd_dose_bin = 1 if covid_vax_az_3_date != ""

gen oxford_4th_dose_bin = 0
replace oxford_4th_dose_bin = 1 if covid_vax_az_4_date != ""

// label data
lab var patient_id "Patient ID number"
lab var covid_vax_1_date "Date of 1st COVID vaccination (any type)"
lab var covid_vax_2_date "Date of 2nd COVID vaccination (any type)"
lab var covid_vax_3_date "Date of 3rd COVID vaccination (any type)"
lab var covid_vax_4_date "Date of 4th COVID vaccination (any type)"

lab var covid_vax_pfizer_1_date "Date of 1st COVID vaccination (Pfizer)"
lab var covid_vax_pfizer_2_date "Date of 2nd COVID vaccination (Pfizer)"
lab var covid_vax_pfizer_3_date "Date of 3rd COVID vaccination (Pfizer)"
lab var covid_vax_pfizer_4_date "Date of 4th COVID vaccination (Pfizer)"

lab var covid_vax_az_1_date "Date of 1st COVID vaccination (Oxford)"
lab var covid_vax_az_2_date "Date of 2nd COVID vaccination (Oxford)"
lab var covid_vax_az_3_date "Date of 3rd COVID vaccination (Oxford)"
lab var covid_vax_az_4_date "Date of 4th COVID vaccination (Oxford)"

lab var prior_positive_test_date "Date of Positive COVID test in SGSS prior to study"
lab var prior_primary_care_covid_case_da "Date of diagnosis of COVID in primary care prior to study"
lab var prior_admitted_for_covid_date "Date of Hospital Admission with COVID prior to study"

lab var positive_test_1_date "Date of 1st Positive COVID test in SGSS during study"
lab var primary_care_covid_case_1_date "Date of 1st diagnosis of COVID in primary care during study"
lab var admitted_1_date "Date of 1st Hospital Admission with COVID during study"
lab var coviddeath_date "Date of COVID-related death"
lab var death_date "Date of death (all-cause)"

lab var age "Age of Patient as of 1st Feb 2020"
lab var sex "Sex of Patient"
lab var bmi "BMI categories"
lab var has_follow_up_previous_year "Has a year of Follow-up prior to study start"
lab var ethnicity_16 "Ethnicity in 16 groups"
lab var ethnicity "Ethnicity in 5 groups"
lab var practice_id "Practice ID Number"
lab var stp "STP"
lab var region "NHS Region"
lab var care_home_type "Type of Care Home"
lab var care_home "Lives within a Care Home"
lab var imd "Index of Multiple Deprivation"

lab var chronic_cardiac_disease "History of Chronic Cardiac Disease"
lab var current_copd "History of COPD"
lab var dmards "History of DMARD prescription"
lab var dementia "History of Dementia"
lab var dialysis "History of Dialysis"
lab var solid_organ_transplantation "History of Solid Organ Transplant"
lab var chemo_or_radio "History of Chemotherapy or Radiotherapy Ever"
lab var intel_dis_incl_downs_syndrome "History of Learning Disability including Down's Syndrome"
lab var lung_cancer "History of Lung Cancer"
lab var cancer_excl_lung_and_haem "History of Cancer excluding Lung or Haematological ever"
lab var haematological_cancer "History of Haematological Cancer"
lab var bone_marrow_transplant "History of Bone Marrow Transplant in last 6 months"
lab var cystic_fibrosis "History of Cystic Fibrosis"
lab var sickle_cell_disease "History of Sickle Cell Disease"
lab var permanant_immunosuppression "History of Permanent Immunosuppression"
lab var temporary_immunosuppression "History of Temporary Immunosuppression in last year"
lab var psychosis_schiz_bipolar "History of Severe Mental Health Disorder"
lab var asplenia "History of Asplenia"

label var vaccine_ever_bin "Covid Vaccination Ever (at least 1 dose, any type)"
label var vaccine_2nd_dose_bin "Covid Vaccination 2nd Dose (any type)"
label var vaccine_3rd_dose_bin "Covid Vaccination 3rd Dose (any type)"
label var vaccine_4th_dose_bin "Covid Vaccination 4th Dose (any type)"

label var pfizer_1st_dose_bin "Pfizer Covid Vaccination 1st Dose"
label var pfizer_2nd_dose_bin "Pfizer Covid Vaccination 2nd Dose"
label var pfizer_3rd_dose_bin "Pfizer Covid Vaccination 3rd Dose"
label var pfizer_4th_dose_bin "Pfizer Covid Vaccination 4th Dose"

label var oxford_1st_dose_bin "Oxford Covid Vaccination 1st Dose"
label var oxford_2nd_dose_bin "Oxford Covid Vaccination 2nd Dose"
label var oxford_3rd_dose_bin "Oxford Covid Vaccination 3rd Dose"
label var oxford_4th_dose_bin "Oxford Covid Vaccination 4th Dose"

label var prior_positive_sgss_bin "Positive COVID test in SGSS before study start"
label var sgss_post_vaccine_positive_bin "Positive COVID test in SGSS during study"

label var prior_primary_care_covid_bin "COVID diagnosed in primary care before study start"
label var primary_care_covid_post_vacc_bin "COVID diagnosed in primary care during study"

label var prior_hospital_bin "Hospital admission with COVID before study start"
label var hospital_post_vacc_bin "Hospital admission with COVID during study"

label var covid_death_bin "COVID death during study"
label var death_bin "Death (any cause) during study"



// label binary
label define binaryLabel 0 "No" 1 "Yes"
label val vaccine_ever_bin vaccine_2nd_dose_bin vaccine_3rd_dose_bin vaccine_4th_dose_bin pfizer_1st_dose_bin pfizer_2nd_dose_bin pfizer_3rd_dose_bin pfizer_4th_dose_bin oxford_1st_dose_bin oxford_2nd_dose_bin oxford_3rd_dose_bin oxford_4th_dose_bin prior_positive_sgss_bin sgss_post_vaccine_positive_bin prior_primary_care_covid_bin primary_care_covid_post_vacc_bin prior_hospital_bin hospital_post_vacc_bin covid_death_bin binaryLabel
label val care_home has_follow_up_previous_year chronic_cardiac_disease current_copd dmards dementia dialysis solid_organ_transplantation chemo_or_radio intel_dis_incl_downs_syndrome lung_cancer cancer_excl_lung_and_haem haematological_cancer bone_marrow_transplant cystic_fibrosis sickle_cell_disease permanant_immunosuppression temporary_immunosuppression psychosis_schiz_bipolar asplenia binaryLabel

// lab ethnicity
lab def eth5Label 1 "White" 2 "Mixed" 3 "South Asian" 4 "Black" 5 "Other"
lab val ethnicity eth5Label

lab def eth16Label 1 "British or Mixed British" 2 "Irish" 3 "Other White" 4 "White + Black Caribbean" 5 "White + Black African" 6 "White + Asian" 7 "Other mixed" 8 "Indian or British Indian" 9 "Pakistani or British Pakistani" 10 "Bangladeshi or British Bangladeshi" 11 "Other Asian" 12 "Carribean" 13 "African" 14 "Other Black" 15 "Chinese" 16 "Other"
lab val ethnicity_16 eth16Label

// imd 
lab def imdLab 0 "Unknown" 1 "1 - Most deprived" 2 "2" 3 "3" 4 "4" 5 "5 - Least deprived"
lab val imd imdLab

// Change outcome dates to binary values

**************** SGSS **********************

// SGSS positive covid test prior to study 
gen prior_positive_sgss_bin = 0
replace prior_positive_sgss_bin = 1 if prior_positive_test_date != ""

// diagnosis within study   
gen sgss_post_vaccine_positive_bin = 0
replace sgss_post_vaccine_positive_bin = 1 if positive_test_1_date != ""

******** PRIMARY CARE COVID DIAGNOSIS ********

// primary care diagnosis with covid test prior to study 
gen prior_primary_care_covid_bin = 0
replace prior_primary_care_covid_bin = 1 if prior_primary_care_covid_case_da != ""

// primary care covid diagnosis within study
gen primary_care_covid_post_vacc_bin = 0
replace primary_care_covid_post_vacc_bin = 1 if primary_care_covid_case_1_date != ""


************ HOSPITAL ADMISISON ***************

// HOSPITAL ADMISSION prior to study with covid 
gen prior_hospital_bin = 0
replace prior_hospital_bin = 1 if prior_admitted_for_covid_date != ""

// HOSPITAL ADMISSION  within study
gen hospital_post_vacc_bin = 0
replace hospital_post_vacc_bin = 1 if admitted_1_date != ""


************ DEATHS  ***************

// DEATH from COVID within study
gen covid_death_bin = 0
replace covid_death_bin = 1 if coviddeath_date != ""

// DEATH from any cause within study
gen death_bin = 0
replace death_bin = 1 if death_date != ""

**********************************************
************ ONE-WAY TABS ********************
**********************************************

**** Vaccine Exposure ****


tab vaccine_ever_bin
tab vaccine_2nd_dose_bin
tab vaccine_3rd_dose_bin
tab vaccine_4th_dose_bin 
tab pfizer_1st_dose_bin
tab pfizer_2nd_dose_bin 
tab pfizer_3rd_dose_bin
tab pfizer_4th_dose_bin
tab oxford_1st_dose_bin
tab oxford_2nd_dose_bin
tab oxford_3rd_dose_bin 
tab oxford_4th_dose_bin

****  Outcomes ****

// SGSS positive in study

tab sgss_post_vaccine_positive_bin

// Primary care diagnosis in study

tab primary_care_covid_post_vacc_bin

// Covid hospital admisison in study

tab hospital_post_vacc_bin

// Deaths

tab covid_death_bin

**** Prior Exposures or Outcomes ****

// SGSS positive before study

tab prior_positive_sgss_bin

// Primary care diagnosis before study

tab prior_primary_care_covid_bin

// Covid hospital admisison before study

tab prior_hospital_bin


**** DEMOGRAPHICS ****

tab bmi

hist age

tab sex

tab ethnicity_16

tab ethnicity

tab stp

tab imd

tab region 

**** CARE HOME ****

tab care_home_type 

tab care_home

**** COMORBDITIES *** 

foreach x in chronic_cardiac_disease current_copd dmards dementia dialysis solid_organ_transplantation chemo_or_radio intel_dis_incl_downs_syndrome lung_cancer cancer_excl_lung_and_haem haematological_cancer bone_marrow_transplant cystic_fibrosis sickle_cell_disease permanant_immunosuppression temporary_immunosuppression psychosis_schiz_bipolar asplenia{
tab `x'
}


**********************************************
************ TWO-WAY TABS ********************
**********************************************

**** VACCINES ****
// One dose, any type

tab sex vaccine_ever_bin, row

tab bmi vaccine_ever_bin, row

tab ethnicity vaccine_ever_bin, row

tab imd vaccine_ever_bin, row

tab region vaccine_ever_bin, row

tab stp vaccine_ever_bin, row

foreach x in chronic_cardiac_disease current_copd dmards dementia dialysis solid_organ_transplantation chemo_or_radio intel_dis_incl_downs_syndrome lung_cancer cancer_excl_lung_and_haem haematological_cancer bone_marrow_transplant cystic_fibrosis sickle_cell_disease permanant_immunosuppression temporary_immunosuppression psychosis_schiz_bipolar asplenia{
tab `x' vaccine_ever_bin, row
}

// Two doses, any type

tab sex vaccine_2nd_dose_bin, row

tab bmi vaccine_2nd_dose_bin, row

tab ethnicity vaccine_2nd_dose_bin, row

tab imd vaccine_2nd_dose_bin, row

tab region vaccine_2nd_dose_bin, row

tab stp vaccine_2nd_dose_bin, row

foreach x in chronic_cardiac_disease current_copd dmards dementia dialysis solid_organ_transplantation chemo_or_radio intel_dis_incl_downs_syndrome lung_cancer cancer_excl_lung_and_haem haematological_cancer bone_marrow_transplant cystic_fibrosis sickle_cell_disease permanant_immunosuppression temporary_immunosuppression psychosis_schiz_bipolar asplenia{
tab `x' vaccine_2nd_dose_bin, row
}

**** OUTCOMES ****

// 1 dose any type
// SGSS
tab vaccine_ever_bin sgss_post_vaccine_positive_bin, row

// primary care diagnosis
tab vaccine_ever_bin primary_care_covid_post_vacc_bin, row

// hospital admission
tab vaccine_ever_bin hospital_post_vacc_bin, row

/// death
tab vaccine_ever_bin covid_death_bin, row
tab vaccine_ever_bin death_bin, row


// 2 dose any type
// SGSS
tab vaccine_2nd_dose_bin sgss_post_vaccine_positive_bin, row

// primary care diagnosis
tab vaccine_2nd_dose_bin primary_care_covid_post_vacc_bin, row

// hospital admission
tab vaccine_2nd_dose_bin hospital_post_vacc_bin, row

/// death
tab vaccine_2nd_dose_bin covid_death_bin, row
tab vaccine_2nd_dose_bin death_bin, row


// outcomes by vaccination excluding any previous covid diagnosis (SGSS)
// 1st dose any type
tab vaccine_ever_bin sgss_post_vaccine_positive_bin if prior_positive_sgss_bin == 0, row

// primary care diagnosis
tab vaccine_ever_bin primary_care_covid_post_vacc_bin if prior_positive_sgss_bin == 0, row

// hospital admission
tab vaccine_ever_bin hospital_post_vacc_bin if prior_positive_sgss_bin == 0, row

/// death
tab vaccine_ever_bin covid_death_bin if prior_positive_sgss_bin == 0, row
tab vaccine_ever_bin death_bin if prior_positive_sgss_bin == 0, row






















