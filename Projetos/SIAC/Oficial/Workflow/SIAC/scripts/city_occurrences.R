#
# Clube de Ci?ncia de Dados - UFF (CCD-UFF)
# Author: Paulo Roberto Mann Marques Junior
#
# Last modified: 2015/06/16
#
# This script has the objective to get all the occurrences that is from a generic city.
#
city_occurrences <- function(CITY = "Niteroi", input = "", output="city_occurrences.csv")
{
  # Args:
  #   CITY = "Niteroi" : It's the city to filter by. 
  #                     (doesn't matter if the word is lower or upper case or have accents)
  # Returns:
  #   A .csv file containing all the occurrences in the parameter city.
  #   Note 1: The csv file is written in the actual working directory.
  #   Note 2: In order to execute this algorithm YOU MUST have an "ondefuiroubado_occurrences"
  #           directory(inside your working directory) containing all the csv files with
  #           all the occurrences csv's.
  DEFAULT_PATH <- getwd()
  OCCURRENCES_PATH <- "ondefuiroubado_occurrences"
  NEW_PATH <- paste(DEFAULT_PATH, OCCURRENCES_PATH, sep="/")
  print(NEW_PATH)

  #This map is used to remove accents.
  unwanted_array = list('S'='S', 's'='s', 'Z'='Z', 'z'='z', '?'='A', '?'='A', '?'='A', '?'='A', '?'='A',
                        '?'='A', '?'='A', '?'='C', '?'='E', '?'='E','?'='E', '?'='E', '?'='I', '?'='I',
                        '?'='I', '?'='I', '?'='N', '?'='O', '?'='O', '?'='O', '?'='O', '?'='O', '?'='O',
                        '?'='U','?'='U', '?'='U', '?'='U', '?'='Y', '?'='B', '?'='Ss', '?'='a', '?'='a',
                        '?'='a', '?'='a', '?'='a', '?'='a', '?'='a', '?'='c','?'='e', '?'='e', '?'='e',
                        '?'='e', '?'='i', '?'='i', '?'='i', '?'='i', '?'='o', '?'='n', '?'='o', '?'='o',
                        '?'='o', '?'='o','?'='o', '?'='o', '?'='u', '?'='u', '?'='u', '?'='y', '?'='y',
                        '?'='b', '?'='y', '`'='', '?'='', '^'='', '?'='', '?'='', '~'='', '"'='', '?' = 'u',
                        '?'='1/2', '?'='3/4', '?'='1/4', '?'='>>', '?'='?', '?'='o', '?'='<<', '?'='', '?'='!',
                        '?'='1', '?'='2', '?'='3', '?'='', '?'='c', '?'='', '?'='', '?'='', '|'='',
                        '\\n'= ' ', '\\t' = ' ', '\\r' = ' ')
  library(stringr)
  library(gdata)
  
  #Remove accents from the CITY parameter
  for(q in seq_along(unwanted_array))
    CITY <- gsub(names(unwanted_array)[q], unwanted_array[q], CITY)
  
  data <- data.frame()
  files <- list.files(path = NEW_PATH, pattern = paste(input,"*.csv"))
  result_data <- data.frame()
  
  
  for(v in 1:length(files))
  {
    print(files[v])
    data <- read.csv(paste(NEW_PATH, files[v], sep="/"), strip.white = TRUE)
    
    for(i in 1:nrow(data))
    {
      #CITY PART
      city <- as.character(data[i, "city"])
      city <- trim(city)
      #Remove accents
      for(j in seq_along(unwanted_array))
        city <- gsub(names(unwanted_array)[j],unwanted_array[j], city)
      if(tolower(city) != tolower(CITY))
        next
      #END CITY PART
      
      data_row <- data.frame()
      n_occurrence <- data[i,"n_occurrence"]
      latitude <- data[i, "latitude"]
      longitude <- data[i, "longitude"]
      occurrence_type <- data[i, "occurrence_type"]
      
      #OBJECTS
      object_names <- colnames(data)
      objects <- c()
      for(k in 8:26)
      {
        objects <- cbind(objects, data[i,k])
      }
      colnames(objects) <- object_names[8:26]
      #END OBJECTS
      
      #DATE AND TIME
      date_time <- as.character(data[i,"date_time"])
      date_time <- trim(date_time)
      time <- strsplit(date_time, split=" ")[[1]][2]
      date <- as.Date(strsplit(date_time, split=" ")[[1]][1], "%d/%m/%Y")
      #END DATE AND TIME
      
      data_row <- data.frame(n_occurrence, latitude, longitude, city, occurrence_type, objects, date, time)
      result_data <- rbind(result_data, data_row)
    }
  }
  write.csv(result_data, output)
  setwd(DEFAULT_PATH)
}
args <- commandArgs(trailingOnly = TRUE)
city_occurrences(args[1], args[2], args[3])