library(tidyverse)
library(here)

df_Subject_Metrics <- readxl::read_excel(here("SubjectAnthropometrics.xlsx"))

txt_pipeline <- read_lines(here("osg-pipeline-template.v3s"))

for (subject in df_Subject_Metrics$SubjectID) {
  print(subject)  
  
}

subject_default <- "2015043"
mass_default <- "67"
height_default <-"172.5"

subject <- "2015042"
mass <-  "100"      
height <- "1.5"     

txt_pipeline <-  txt_pipeline %>% str_replace_all(subject_default, subject)
txt_pipeline <-  txt_pipeline %>% str_replace_all(mass_default, mass)
txt_pipeline <-  txt_pipeline %>% str_replace_all(height_default, height)

