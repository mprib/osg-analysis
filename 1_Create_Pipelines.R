library(tidyverse)
library(here)

# Create Individual Pipelines ---------------------------------------------


df_Subject_Metrics <- readxl::read_excel(here("SubjectAnthropometrics.xlsx"))

txt_pipeline_template <- read_lines(here("osg-pipeline-template.v3s"))

# These are the values in the file above that will be overwritten
subject_default <- "2014001"
mass_default <- "67"
height_default <-"172.5"


for (subjectID in df_Subject_Metrics$SubjectID) {
  
  subject <- as.character(subjectID)
  
  mass <- df_Subject_Metrics %>% 
          filter(SubjectID == subjectID) %>% 
          select(Mass) %>% as.character()
  
  height <- df_Subject_Metrics %>% 
            filter(SubjectID == subjectID) %>% 
            select(Height)%>% as.character()
  
  txt_pipeline <- txt_pipeline_template %>% str_replace_all(subject_default, subject)
  txt_pipeline <- txt_pipeline %>% str_replace_all(mass_default, mass)
  txt_pipeline <- txt_pipeline %>% str_replace_all(height_default, height)
  
  write_lines(txt_pipeline, here("pipelines", paste0(subject, ".v3s")))
  
}



# Consolidate All Pipelines into Single File ------------------------------


library(fs)

pipelines <- as_tibble(dir_ls("pipelines")) %>% rename(v3s_path = value)

pipelines <- pipelines %>% 
  mutate(text_files = map(v3s_path, read_lines),
         txt_df = map(text_files, as_tibble)) %>% 
  select(-text_files)


all_pipelines <- pipelines %>% unnest(txt_df) %>% select(-v3s_path)

all_pipelines %>% write_lines(path = "All_Pipelines.txt", sep = "\r\n", na = "-1")

# note, for reasons that I do not understand I can't get this to work as a single operation
# and it takes a very long time to do it in a loop
for (line in seq_along(all_pipelines$value)) {
 
  # print(all_pipelines$value[line])
  print(line)
  all_pipelines$value[line] %>% write_lines(path = "All_Pipelines.txt", sep = "\r\n", append = TRUE)
  
}
