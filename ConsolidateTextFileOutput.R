
txt_to_df <- function(txt_file) {
 
   
  
}


get_field_name <- function(column) {
  
  column <-  txt_file[,2]
  field_name <- column[2,] %>% as.character()
  dimension <- column[5,] %>% as.character()
  
}



field_name <- paste(field_name, dimension, sep = "_")

txt_file <- read_tsv(here("output_summary","2014001_C1_01.c3d_output.txt"),
                     col_names = FALSE)

# iteratively arrive at the origin of the file
origin <- txt_file[[1,2]]
origin <-  origin %>% str_split("_")
origin <- origin[[1]][1]

