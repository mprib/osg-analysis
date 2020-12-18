library(tidyverse)
library(here)
# txt_file_name <- "2014001_C1_01.c3d_output.txt"

txt_to_df <- function(txt_file_name) {
 
  txt_file <- read_tsv(here(txt_file_name), col_names = FALSE)
  origin <- txt_file %>% get_origin()
 
  cols <- dim(txt_file)[2]
  for (col in seq(2,cols)) {
   field_name <- get_field_name(txt_file[,col])
   names(txt_file)[col] <- field_name
  }
  
  txt_file <- txt_file[-(1:5),]
  
  names(txt_file)[1] <- "Origin"
  txt_file$Origin <- origin
 
  return(txt_file) 
}


get_field_name <- function(column) {
  
  # tack on the axis, but otherwise drop most things
  field_name <- column[2,] %>% as.character()
  dimension <- column[5,] %>% as.character()
  field_name <- paste(field_name, dimension, sep = "_")
  
  return(field_name)
}

get_origin <- function(txt_file) {
  
  # iteratively arrive at the origin of the file
  origin <- txt_file[[1,2]]
  # origin <-  origin %>% str_split("_")
  origin <- origin[[1]][1]
  
  return(origin)
  
}


# test_txt <- txt_to_df(txt_file_name)

library(fs)

files <-as.tibble(fs::dir_ls("output_summary"))

names(files)[1] <- "OutputFile"

files <- files %>% 
  mutate(df_version = map(OutputFile,txt_to_df)) %>%  # why don't I use the map_df function here? That didn't seem to work...
  unnest(df_version)

files <- files %>% select(-OutputFile)

files_long <- files %>% 
  pivot_longer(-Origin) %>% 
  rename(Variable = name) %>% 
  mutate(dim = str_sub(Variable,-1),
         side = case_when(str_sub(Variable,1,1) == "R" ~ "Right",
                          str_sub(Variable,1,1) == "L" ~ "Left",
                          TRUE ~ NA_character_),
         Measure = case_when(str_detect(Variable, "HIP") ~ "Hip_Moment",
                             str_detect(Variable, "KNEE") ~ "Knee_Moment",
                             str_detect(Variable, "VGRF") ~ "VGRF",
                             str_detect(Variable, "Speed") ~ "Speed",
                             TRUE ~ NA_character_),
         Measure_Type = case_when(str_detect(Variable, "Max") ~ "Max",
                                  str_detect(Variable, "Min") ~ "Min",
                                  TRUE ~ NA_character_)) %>% 
  separate(Origin, c("Subject", "Condition", "Trial"), "_")  %>% 
  mutate(Trial = str_sub(Trial,2,2)) # %>% # Need to clean up the .c3d that's hanging around

files_long <- files_long %>% 
  mutate(Variable_final = paste(Measure, Measure_Type, dim, sep = "_")) %>% 
  select(-c(Variable, dim, Measure, Measure_Type))

files_wide <- files_long %>% pivot_wider(names_from = "Variable_final") %>% filter(!is.na(side))


files_wide %>% write_csv("Consolidated_v3d_Output.csv")
files_wide <- read_csv("Consolidated_v3d_Output.csv")

files_wide <- files_wide %>% 
  mutate(Hip_Abduction_Max = if_else(side == "Left", -1 * Hip_Moment_Min_X, Hip_Moment_Max_X),
         Knee_Extension_Max = Knee_Moment_Max_Y,
         VGRF_Max = VGRF_Max_Z) %>% 
  select(Subject, Condition, Trial, side, Hip_Abduction_Max, Knee_Extension_Max, VGRF_Max, everything())

files_wide %>% write_csv("Consolidated_v3d_Output.csv")
