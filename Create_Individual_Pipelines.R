library(tidyverse)
library(here)

df_Subject_Metrics <- readxl::read_excel(here("SubjectAnthropometrics.xlsx"))

txt_pipeline_template <- read_lines(here("osg-pipeline-template.v3s"))

# These are the values in the file above that will be overwritten
subject_default <- "2014001"
mass_default <- "67"
height_default <-"172.5"


for (subjectID in df_Subject_Metrics$SubjectID) {
  
  print(subject)  
  
  subject <- as.character(subjectID)
  
  mass <- df_Subject_Metrics %>% 
          filter(SubjectID == subjectID) %>% 
          select(Mass) %>% as.character()
  
  height <- df_Subject_Metrics %>% 
            filter(SubjectID == subjectID) %>% 
            select(Height)%>% as.character()
  
  txt_pipeline <-  txt_pipeline_template %>% str_replace_all(subject_default, subject)
  txt_pipeline <-  txt_pipeline %>% str_replace_all(mass_default, mass)
  txt_pipeline <-  txt_pipeline %>% str_replace_all(height_default, height)
  
  write_lines(txt_pipeline, here("pipelines", paste0(subject, ".v3s")))
  
}


