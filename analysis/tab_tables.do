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






