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


is_all_numeric <- function(x) {
  !any(is.na(suppressWarnings(as.numeric(na.omit(x))))) & is.character(x)
}

# test_txt <- txt_to_df(txt_file_name)

library(fs)

files <-as.tibble(dir_ls("pipelines/pipe_out"))

names(files)[1] <- "OutputFile"

df_trunk_speed <- files %>% 
  mutate(df_version = map(OutputFile,txt_to_df)) %>%  # why don't I use the map_df function here? That didn't seem to work...
  unnest(df_version)


df_trunk_speed <- df_trunk_speed %>% select(-OutputFile)

df_trunk_speed <- df_trunk_speed %>% 
  separate(Origin, into = c("Participant", "Condition", "Trial"), extra = "drop") %>%
  filter(Participant != "2014051") %>% 
  mutate_if(is_all_numeric,as.numeric) %>% 
  mutate(Trunk_Rot_Range = Max_R_ThoraxOnPelvis_Z - Min_R_ThoraxOnPelvis_Z,
         Trunk_LF_Range = Max_R_ThoraxOnPelvis_Y - Min_R_ThoraxOnPelvis_Y) %>% 
  rename(Speed = Speed_X) %>% 
  select(Participant,
         Condition,
         Trial,
         Speed,
         Trunk_Rot_Range,
         Trunk_LF_Range,
         everything())

df_trunk_speed %>% write_csv("trunk_speed_output.csv")

