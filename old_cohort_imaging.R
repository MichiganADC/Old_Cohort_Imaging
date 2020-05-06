# old_cohort_imaging.R

##
# Libraries

library(readxl)
library(readr)
library(dplyr)
library(stringr)

##
# Source config and helpers

source("~/Box/Documents/R_helpers/config.R")
source("~/Box/Documents/R_helpers/helpers.R")

##
# Load raw data

dir_path <- "~/Box/MADC Box Account/Imaging Core/MRI_PET/Old Cohort MRI Project"
filename <- "Combined_Workbook.xlsx"

df_raw <-
  read_excel(paste0(dir_path, "/", filename), col_types = "text")
