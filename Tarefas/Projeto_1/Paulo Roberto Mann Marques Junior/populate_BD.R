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
    
    library(RMySQL)
    library(gdata)
    mydb = dbConnect(MySQL(), user="root", password="qwer1234", dbname = "ondefuiroubado", host="localhost")
    dbListTables(mydb)
    
    data <- data.frame()
    files <- list.files(path = NEW_PATH, pattern = "*.csv")
    
    for(i in 1:1){
      data <- read.csv(files[i])
      cnames <- colnames(data)
      query <- "INSERT INTO occurrence(idOccurrence, latitude, longitude, city, type, title,object_1, object_2, object_3, object_4, object_5, object_6, object_7, object_8,object_9, object_10, object_11, object_12, object_13, object_14, object_15, object_16,object_17, object_18, object_19, date_time, description) VALUES("
      queries <- character()
      for(j in 2:length(cnames)){
        if(j >= 8 && j <= 26){
          if(data[i,j] == "TRUE")
            query <- paste(query, 1, ",", sep="")
          else
            query <- paste(query, 0, ",", sep="")
        }
        else if(j == 27)
          query <- paste(query, '\'', as.POSIXct(data[i,j], "%Y-%m-%d %H:%M:%S"), '\'' ,",", sep="") #Do not work.
        else if(is.numeric(data[i,j]))
          query <- paste(query, data[i,j], ",", sep="")
        else
          query <- paste(query, '\'', trim(data[i,j]), '\'', ",", sep="")
      }
      query <- paste(query, ");", sep="")
      cbind(queries, query)
      print(query)
    }
    lapply(dbListConnections(MySQL()), dbDisconnect)
    setwd(DEFAULT_PATH)
}