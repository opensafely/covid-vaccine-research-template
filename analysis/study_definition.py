
from cohortextractor import (
    StudyDefinition,
    patients,
    codelist_from_csv,
    codelist,
    filter_codes_by_category,
    combine_codelists,
)

# Important Dates
campaign_start = "2020-12-07" # change this if you need to
latest_date = "2021-01-13" 

# Import Codelists
from codelists import *


# Specifiy study defeinition
study = StudyDefinition(
    # Configure the expectations framework
    default_expectations={
        "date": {"earliest": "1970-01-01", "latest": latest_date},
        "rate": "uniform",
        "incidence": 0.2,
    },

    # This line defines the study population
    population=patients.satisfying(
        """
        registered
        AND
        (age >= 18 AND age <= 110)
        AND
        NOT has_died
        """
    ),
    registered=patients.registered_as_of(
        campaign_start,  # day before vaccination campaign starts - discuss with team if this should be "today"
        return_expectations={"incidence": 0.98},
    ),
    has_died=patients.died_from_any_cause(
        on_or_before=campaign_start,
        returning="binary_flag",
        return_expectations={"incidence": 0.05},
    ),

    # https://github.com/opensafely/risk-factors-research/issues/49
    age=patients.age_as_of(
        "2020-02-01",
        return_expectations={
            "rate": "universal",
            "int": {"distribution": "population_ages"},
        },
    ),
    
    # https://github.com/opensafely/risk-factors-research/issues/46
    sex=patients.sex(
        return_expectations={
            "rate": "universal",
            "category": {"ratios": {"M": 0.49, "F": 0.51}},
        }
    ),

    # https://github.com/opensafely/risk-factors-research/issues/51
    bmi=patients.categorised_as(
        {
            "Not obese": "DEFAULT",
            "Obese I (30-34.9)": """ bmi_value >= 30 AND bmi_value < 35""",
            "Obese II (35-39.9)": """ bmi_value >= 35 AND bmi_value < 40""",
            "Obese III (40+)": """ bmi_value >= 40 AND bmi_value < 100""",
            # set maximum to avoid any impossibly extreme values being classified as obese
        },
        bmi_value=patients.most_recent_bmi(
            on_or_after="2015-12-01",
            minimum_age_at_measurement=16
            ),
        return_expectations={
            "rate": "universal",
            "category": {
                "ratios": {
                    "Not obese": 0.7,
                    "Obese I (30-34.9)": 0.1,
                    "Obese II (35-39.9)": 0.1,
                    "Obese III (40+)": 0.1,
                }
            },
        },
    ),


    has_follow_up_previous_year=patients.registered_with_one_practice_between(
        start_date="2019-12-07",
        end_date=campaign_start,
        return_expectations={"incidence": 0.95},
        ),

    registered_at_latest_date=patients.registered_as_of(
        reference_date=latest_date,
        return_expectations={"incidence": 0.95},
        ),

    # ETHNICITY IN 16 CATEGORIES
    ethnicity_16=patients.with_these_clinical_events(
        ethnicity_codes_16,
        returning="category",
        find_last_match_in_period=True,
        include_date_of_match=False,
        return_expectations={
            "category": {
                "ratios": {
                    "1": 0.0625,
                    "2": 0.0625,
                    "3": 0.0625,
                    "4": 0.0625,
                    "5": 0.0625,
                    "6": 0.0625,
                    "7": 0.0625,
                    "8": 0.0625,
                    "9": 0.0625,
                    "10": 0.0625,
                    "11": 0.0625,
                    "12": 0.0625,
                    "13": 0.0625,
                    "14": 0.0625,
                    "15": 0.0625,
                    "16": 0.0625,
                }
            },
            "incidence": 0.75,
        },
    ),

    # ETHNICITY IN 6 CATEGORIES
    ethnicity=patients.with_these_clinical_events(
        ethnicity_codes,
        returning="category",
        find_last_match_in_period=True,
        include_date_of_match=False,
        return_expectations={
            "category": {"ratios": {"1": 0.2, "2": 0.2, "3": 0.2, "4": 0.2, "5": 0.2}},
            "incidence": 0.75,
        },
    ),

    ################################################
    ###### PRACTICE AND PATIENT ADDRESS VARIABLES ##
    ################################################
    # practice pseudo id
    practice_id=patients.registered_practice_as_of(
        campaign_start,  # day before vaccine campaign start
        returning="pseudo_id",
        return_expectations={
            "int": {"distribution": "normal", "mean": 1000, "stddev": 100},
            "incidence": 1,
        },
    ),

    # stp is an NHS administration region based on geography
    stp=patients.registered_practice_as_of(
        campaign_start,
        returning="stp_code",
        return_expectations={
            "rate": "universal",
            "category": {
                "ratios": {
                    "STP1": 0.1,
                    "STP2": 0.1,
                    "STP3": 0.1,
                    "STP4": 0.1,
                    "STP5": 0.1,
                    "STP6": 0.1,
                    "STP7": 0.1,
                    "STP8": 0.1,
                    "STP9": 0.1,
                    "STP10": 0.1,
                }
            },
        },
    ),
    # NHS administrative region
    region=patients.registered_practice_as_of(
        campaign_start,
        returning="nuts1_region_name",
        return_expectations={
            "rate": "universal",
            "category": {
                "ratios": {
                    "North East": 0.1,
                    "North West": 0.1,
                    "Yorkshire and the Humber": 0.2,
                    "East Midlands": 0.1,
                    "West Midlands": 0.1,
                    "East of England": 0.1,
                    "London": 0.1,
                    "South East": 0.2,
                },
            },
        },
    ),

    # IMD - quintile
    imd=patients.categorised_as(
        {
            "0": "DEFAULT",
            "1": """index_of_multiple_deprivation >=1 AND index_of_multiple_deprivation < 32844*1/5""",
            "2": """index_of_multiple_deprivation >= 32844*1/5 AND index_of_multiple_deprivation < 32844*2/5""",
            "3": """index_of_multiple_deprivation >= 32844*2/5 AND index_of_multiple_deprivation < 32844*3/5""",
            "4": """index_of_multiple_deprivation >= 32844*3/5 AND index_of_multiple_deprivation < 32844*4/5""",
            "5": """index_of_multiple_deprivation >= 32844*4/5 AND index_of_multiple_deprivation < 32844""",
        },
        index_of_multiple_deprivation=patients.address_as_of(
            campaign_start,
            returning="index_of_multiple_deprivation",
            round_to_nearest=100,
        ),
        return_expectations={
            "rate": "universal",
            "category": {
                "ratios": {
                    "0": 0.05,
                    "1": 0.19,
                    "2": 0.19,
                    "3": 0.19,
                    "4": 0.19,
                    "5": 0.19,
                }
            },
        },
    ),

    # CAREHOME STATUS
    care_home_type=patients.care_home_status_as_of(
        campaign_start,
        categorised_as={
            "PC": """
              IsPotentialCareHome
              AND LocationDoesNotRequireNursing='Y'
              AND LocationRequiresNursing='N'
            """,
            "PN": """
              IsPotentialCareHome
              AND LocationDoesNotRequireNursing='N'
              AND LocationRequiresNursing='Y'
            """,
            "PS": "IsPotentialCareHome",
            "": "DEFAULT",  # use empty string
        },
        return_expectations={
            "rate": "universal",
            "category": {"ratios": {"PC": 0.05, "PN": 0.05, "PS": 0.05, "": 0.85, }, },
        },
    ),

    # simple care home flag
    care_home=patients.satisfying(
        """care_home_type""",
        return_expectations={
            "rate": "universal",
            "category": {"ratios": {1: 0.15, 0: 0.85, }},
        },
    ),

    ###############################################################################
    # COVID VACCINATION
    ###############################################################################
    # any COVID vaccination (first dose)
    covid_vacc_date=patients.with_tpp_vaccination_record(
        target_disease_matches="SARS-2 CORONAVIRUS",
        on_or_after="2020-12-01",  # check all december to date
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2020-12-08",  # first vaccine administered on the 8/12
                "latest": "2021-01-31",
            }
        },
    ),
    # SECOND DOSE COVID VACCINATION - any type, at least 19 d since first recorded dose
    covid_vacc_second_dose_date=patients.with_tpp_vaccination_record(
        target_disease_matches="SARS-2 CORONAVIRUS",
        on_or_after="covid_vacc_date + 19 days",
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2020-12-29",  # first reported second dose administered on the 29/12
                "latest": latest_date,
            }
        },
    ),
    # COVID VACCINATION TYPE = Pfizer BioNTech - first record of a pfizer vaccine 
       # NB *** may be patient's first COVID vaccine dose or their second if mixed types are given ***
    covid_vacc_pfizer_first_dose_date=patients.with_tpp_vaccination_record(
        product_name_matches="COVID-19 mRNA Vac BNT162b2 30mcg/0.3ml conc for susp for inj multidose vials (Pfizer-BioNTech)",
        on_or_after="2020-12-01",  # check all december to date
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2020-12-08",  # first vaccine administered on the 8/12
                "latest": latest_date,
            }
        },
    ),

    # SECOND DOSE COVID VACCINATION, TYPE = Pfizer (within at least 19 d of patient's first dose of same vaccine type)
        # NB will not pick up second doses in patients given mixed types
    covid_vacc_pfizer_second_dose_date=patients.with_tpp_vaccination_record(
        product_name_matches="COVID-19 mRNA Vac BNT162b2 30mcg/0.3ml conc for susp for inj multidose vials (Pfizer-BioNTech)",
        on_or_after="covid_vacc_pfizer_first_dose_date + 19 days",
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2020-12-29",  # first reported second dose administered on the 29/12
                "latest": latest_date,
            }
        },
    ),

    # COVID VACCINATION TYPE = Oxford AZ - first record of an Oxford AZ vaccine 
        # NB *** may be patient's first COVID vaccine dose or their second if mixed types are given ***
    covid_vacc_oxford_first_dose_date=patients.with_tpp_vaccination_record(
        product_name_matches="COVID-19 Vac AstraZeneca (ChAdOx1 S recomb) 5x10000000000 viral particles/0.5ml dose sol for inj MDV",
        on_or_after="2020-12-01",  # check all december to date
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2020-01-04",  # first vaccine administered on the 4/1
                "latest": latest_date,
            }
        },
    ),

    # SECOND DOSE COVID VACCINATION, TYPE = Oxford AZ (within at least 19 d of patient's first dose of same vaccine type)
        # NB will not pick up second doses in patients given mixed types
    covid_vacc_oxford_second_dose_date=patients.with_tpp_vaccination_record(
        product_name_matches="COVID-19 Vac AstraZeneca (ChAdOx1 S recomb) 5x10000000000 viral particles/0.5ml dose sol for inj MDV",
        on_or_after="covid_vacc_oxford_first_dose_date + 19 days",
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2021-01-19",  
                "latest": latest_date,
            }
        },
    ),

    ################################################
    ############ COVID CASES #########################
    ################################################
    # FIRST EVER SGSS POSITIVE
    first_SGSS_positive_test_date=patients.with_test_result_in_sgss(
        pathogen="SARS-CoV-2",
        test_result="positive",
        on_or_after="2020-02-01",
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {"earliest": "2020-02-01"},
            "rate": "exponential_increase",
        },
    ),
    # FIRST EVER PRIMARY CARE CASE IDENTIFICATION
    earliest_primary_care_covid_case_date=patients.with_these_clinical_events(
        combine_codelists(
            covid_primary_care_code,
            covid_primary_care_positive_test,
            covid_primary_care_sequalae,
        ),
        returning="date",
        find_first_match_in_period=True,
        date_format="YYYY-MM-DD",
        return_expectations={"rate": "exponential_increase"},
    ),
    # POST VACCINE SGSS POSITIVE    
    post_vaccine_SGSS_positive_test_date=patients.with_test_result_in_sgss(
        pathogen="SARS-CoV-2",
        test_result="positive",
        on_or_after="covid_vacc_date",
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {"earliest": "2021-01-01"},
            "rate": "exponential_increase",
        },
    ),
    # POST VACCINE PRIMARY CARE CASE IDENTIFICATION
    post_vaccine_primary_care_covid_case_date=patients.with_these_clinical_events(
        combine_codelists(
            covid_primary_care_code,
            covid_primary_care_positive_test,
            covid_primary_care_sequalae,
        ),
        returning="date",
        find_last_match_in_period=True,
        date_format="YYYY-MM-DD",
        on_or_after="covid_vacc_date",
        return_expectations={
            "date": {"earliest": "2021-05-01", "latest" : "2021-05-30"},
            "rate": "uniform",
            "incidence": 0.05,
        },
    ),
    # POST VACCINE COVID-RELATED HOSPITAL ADMISSION
    post_vaccine_admitted_date=patients.admitted_to_hospital(
        returning="date_admitted",
        with_these_diagnoses=covid_codes,
        on_or_after="covid_vacc_date",
        date_format="YYYY-MM-DD",
        find_first_match_in_period=True,
        return_expectations={
            "date": {"earliest": "2021-05-01", "latest" : "2021-05-30"},
            "rate": "uniform",
            "incidence": 0.05,
        },
    ),
    # COVID-RELATED DEATH
    coviddeath_date=patients.with_these_codes_on_death_certificate(
        covid_codes,
        returning="date_of_death",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {"earliest": "2021-06-01", "latest" : "2021-06-30"},
            "rate": "uniform",
            "incidence": 0.02
        },
    ),
    # ALL-CAUSE DEATH
    death_date=patients.died_from_any_cause(
        returning="date_of_death",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {"earliest": "2021-06-01", "latest" : "2021-06-30"},
            "rate": "uniform",
            "incidence": 0.02
        },
    ),
    
    ############################################################
    ######### CLINICAL CO-MORBIDITIES ##########################
    ############################################################
    #### NOTES: PLEASE PAY CLOSE ATTENTION TO THE DATES USED. ##
    ### THESE CODELISTS ARE AVAILABLE ON CODELISTS.OPENSAFELY.ORG
    #### AND CAN BE UPDATED. PLEASE REVIEW AND CHECK YOU ARE HAPPY
    #### WITH THE CODELIST USED #################################

    # https://github.com/opensafely/vaccine-eligibility/blob/master/analysis/study_definition.py
    chronic_cardiac_disease=patients.with_these_clinical_events(
        chronic_cardiac_disease_codes,
        on_or_before=campaign_start,
        returning="binary_flag",
        return_expectations={"incidence": 0.01},
    ),
    current_copd=patients.with_these_clinical_events(
        current_copd_codes,
        on_or_before=campaign_start,
        returning="binary_flag",
        return_expectations={"incidence": 0.01, },
    ),
    # on a dmard - indicative of immunosuppression
    dmards=patients.with_these_medications(
        dmards_codes,
        on_or_before=campaign_start,
        returning="binary_flag",
        return_expectations={"incidence": 0.01, },
    ),
    # dementia
    dementia=patients.with_these_clinical_events(
        dementia_codes,
        on_or_before=campaign_start,
        returning="binary_flag",
        return_expectations={"incidence": 0.01, },
    ),
    dialysis=patients.with_these_clinical_events(
        dialysis_codes,
        on_or_before=campaign_start,
        returning="binary_flag",
        return_expectations={"incidence": 0.01, },
    ),
    solid_organ_transplantation=patients.with_these_clinical_events(
        solid_organ_transplantation_codes,
        on_or_before=campaign_start,
        returning="binary_flag",
        return_expectations={"incidence": 0.01, },
    ),
    chemo_or_radio=patients.with_these_clinical_events(
        chemotherapy_or_radiotherapy_codes,
        on_or_before=campaign_start,
        returning="binary_flag",
        return_expectations={"incidence": 0.01, },
    ),
    intel_dis_incl_downs_syndrome=patients.with_these_clinical_events(
        intellectual_disability_including_downs_syndrome_codes,
        on_or_before=campaign_start,
        returning="binary_flag",
        return_expectations={"incidence": 0.01, },
    ),
    lung_cancer=patients.with_these_clinical_events(
        lung_cancer_codes,
        on_or_before=campaign_start,
        returning="binary_flag",
        return_expectations={"incidence": 0.01, },
    ),
    cancer_excl_lung_and_haem=patients.with_these_clinical_events(
        cancer_excluding_lung_and_haematological_codes,
        on_or_before=campaign_start,
        returning="binary_flag",
        return_expectations={"incidence": 0.01, },
    ),
    haematological_cancer=patients.with_these_clinical_events(
        haematological_cancer_codes,
        on_or_before=campaign_start,
        returning="binary_flag",
        return_expectations={"incidence": 0.01, },
    ),
    bone_marrow_transplant=patients.with_these_clinical_events(
        bone_marrow_transplant_codes,
        between=["2020-07-01", campaign_start],
        returning="binary_flag",
        return_expectations={"incidence": 0.01, },
    ),
    cystic_fibrosis=patients.with_these_clinical_events(
        cystic_fibrosis_codes,
        on_or_before=campaign_start,
        returning="binary_flag",
        return_expectations={"incidence": 0.01, },
    ),
    sickle_cell_disease=patients.with_these_clinical_events(
        sickle_cell_disease_codes,
        on_or_before=campaign_start,
        returning="binary_flag",
        return_expectations={"incidence": 0.01, },
    ),
    permanant_immunosuppression=patients.with_these_clinical_events(
        permanent_immunosuppression_codes,
        on_or_before=campaign_start,
        returning="binary_flag",
        return_expectations={"incidence": 0.01, },
    ),
    temporary_immunosuppression=patients.with_these_clinical_events(
        temporary_immunosuppression_codes,
        on_or_before=campaign_start,
        returning="binary_flag",
        return_expectations={"incidence": 0.01, },
    ),
    #
    psychosis_schiz_bipolar=patients.with_these_clinical_events(
        psychosis_schizophrenia_bipolar_affective_disease_codes,
        on_or_before=campaign_start,
        returning="binary_flag",
        return_expectations={"incidence": 0.01, },
    ),

    # https://github.com/opensafely/codelist-development/issues/4
    asplenia=patients.with_these_clinical_events(
        asplenia_codes,
        on_or_before=campaign_start,
        returning="binary_flag",
        return_expectations={"incidence": 0.01, },
    ),
)
