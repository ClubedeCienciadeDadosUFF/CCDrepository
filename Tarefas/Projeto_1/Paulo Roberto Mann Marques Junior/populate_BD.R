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
    
    library(RPostgreSQL)
    library(stringr)
    library(gdata)
    #options(encoding = "UTF-8")
    drv <- dbDriver('PostgreSQL')
    con <- dbConnect(drv, dbname='ondefuiroubado', port='5432', user='postgres', password='qwer1234')
    data <- data.frame()
    files <- list.files(path = NEW_PATH, pattern = "*.csv")
    
    for(v in 1:length(files)){
      data <- read.csv(files[v], strip.white = TRUE)
      for(i in 1:nrow(data)){
        cnames <- colnames(data)
        query <- "INSERT INTO occurrence(idoccurrence, latitude, longitude, city, type, title, object_1, object_2, object_3, object_4, object_5, object_6, object_7, object_8, object_9, object_10, object_11, object_12, object_13, object_14, object_15, object_16,object_17, object_18, object_19, date_time, description) VALUES("
        queries <- character()
        for(j in 2:length(cnames)){
          if(j == 27) {
            date_time <- as.character(data[i,j])
            date_time <- trim(date_time)
            time <- strsplit(date_time, split=" ")[[1]][2]
            date <- as.Date(strsplit(date_time, split=" ")[[1]][1], "%d/%m/%Y")
            query <- paste(query, '\'', paste(date,time,sep=" "), '\'' ,",", sep="")
          }
          else if(is.numeric(data[i,j]))
            query <- paste(query, data[i,j], ",", sep="")
          else
          {
            if(j != 28)
              query <- paste(query, '\'', trim(data[i,j]), '\'', ",", sep="")
            else
              if(j == 28)
                query <- paste(query, '\'', trim(data[i,j]), '\'', sep="")
          }
        }
        query <- paste(query, ");", sep="")
        print(query)
        rs <- dbSendQuery(con, query)
        print(fetch(rs,n=-1))
      }
    }
    lapply(dbListConnections(drv), dbDisconnect)
    dbUnloadDriver(drv)
    setwd(DEFAULT_PATH)
}