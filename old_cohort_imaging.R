# old_cohort_imaging.R

##
# Libraries

library(readxl)
library(readr)
library(dplyr)
library(stringr)
library(tidyr)

##
# Source config and helpers

source("~/Box/Documents/R_helpers/config.R")
source("~/Box/Documents/R_helpers/helpers.R")

##
# Load raw data

dir_path <- "~/Box/MADC Box Account/Imaging Core/MRI_PET/Old Cohort MRI Project"
filename <- "Combined_Workbook_adj_mri_dates.xlsx"

df_raw <-
  read_excel(paste0(dir_path, "/", filename), col_types = "text")

df_cln <-
  df_raw %>%
  select(
    mrn = reg_num, 
    ptid = subject_id, 
    first_name, 
    last_name, 
    starts_with("mri_dates")
  ) %>%
  mutate(mrn = pad_with(mrn, char = "0", n = 9, side = "left")) %>%
  mutate(last_name = str_replace_all(last_name, "\\*", ""))
  

df_cln_mut_wide <-
  df_cln %>%
  mutate(
    mri_dates_1 = lubridate::mdy(mri_dates_1),
    mri_dates_2 = lubridate::mdy(mri_dates_2),
    mri_dates_3 = as.Date(as.integer(mri_dates_3), origin = "1899-12-30"),
    mri_dates_4 = as.Date(as.integer(mri_dates_4), origin = "1899-12-30")
  ) %>%
  filter(!is.na(mri_dates_1))

df_cln_mut_long <-
  df_cln_mut_wide %>%
    pivot_longer(
      starts_with("mri_dates_"), 
      names_to = "mri_count_",
      names_prefix = "mri_dates_",
      values_to = "mri_date"
    ) %>%
    filter(!is.na(mri_date)) %>%
    arrange(mrn, mri_date) %>%
    group_by(mrn) %>%
    mutate(mri_count = row_number()) %>%
    ungroup() %>%
    select(-mri_count_)

write_csv(df_cln_mut_wide, 
          paste0(dir_path, "/MADC-Old_Cohort_MRI_MRNs-wide.csv"))
write_csv(df_cln_mut_long, 
          paste0(dir_path, "/MADC-Old_Cohort_MRI_MRNs-long.csv"))
