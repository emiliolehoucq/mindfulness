# Cleaning 2022 NHIS data
# Emilio Lehoucq

# Loading libraries -------------------------------------------------------

library(tidyverse)

# Reading data ------------------------------------------------------------

df <- read_csv("nhis_2022_data.csv", guess_max = 7464)
# guess_max = 7464 per suggestion of the NHIS (see data_nhis_2022_readme.txt)
# There are some problems:
problems(df)

# Cleaning column names ---------------------------------------------------

df <- janitor::clean_names(df)
# not using library(janitor) because it conflicts with some stats functions

# Taking a look at meditation variables -----------------------------------

# Creating vector with variable names to use later
meditation_variables <- c(
  "meditate_a",
  "medipain_a",
  "medihlth_a",
  "yoga_a",
  "yogabrth_a",
  "yogamed_a",
  "yogapain_a",
  "yogahlth_a"
)

# Getting frequency distributions
map(
  meditation_variables,
  ~ {list(variable = .x, table = table(df[[.x]], useNA = "always"))}
  )

# Converting columns of interest to factors -------------------------------

df <- mutate(df, across(all_of(meditation_variables), factor))

# Saving clean data -------------------------------------------------------

save(df, file = paste0(paste("nhis_2022_data_clean", format(Sys.time(), "%Y_%m_%d"), sep = "_"), ".RData"))
