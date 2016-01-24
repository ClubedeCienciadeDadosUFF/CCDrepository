#
# Clube de Ciência de Dados - UFF (CCD-UFF)
# Author: Paulo Roberto Mann Marques Júnior
#
# Last modified: 2015/05/12
#
# This script has the objective to populate the database.
#
populate <- function()
{
  
  DEFAULT_PATH <- getwd()
  OCCURRENCES_PATH <- "ondefuiroubado_occurrences"
  setwd(paste(DEFAULT_PATH, OCCURRENCES_PATH, sep="/"))
  NEW_PATH <- getwd()
  data <- data.frame()
  files <- list.files(path = NEW_PATH, pattern = "*.csv")
  
  
  for(v in 1:length(files)){
    data <- read.csv(files[v], strip.white = TRUE)
    new_data <- data.frame()
    d <- c()
    for(i in 1:nrow(data)){
      cnames <- colnames(data)
      id <- data[i,j]
      for(j in 2:length(cnames - 1)){
        d <- cbind(data[i,j])
      }
      new_data <- rbind(d)
    }
    write.csv(files[v] + "copy.csv")
  }
  setwd(DEFAULT_PATH)
}