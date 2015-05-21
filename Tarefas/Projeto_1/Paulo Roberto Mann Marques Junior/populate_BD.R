#
# Clube de CiÃªncia de Dados - UFF (CCD-UFF)
# Author: Paulo Roberto Mann Marques JÃºnior
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
  unwanted_array = list('S'='S', 's'='s', 'Z'='Z', 'z'='z', 'À'='A', 'Á'='A', 'Â'='A', 'Ã'='A', 'Ä'='A',
                        'Å'='A', 'Æ'='A', 'Ç'='C', 'È'='E', 'É'='E','Ê'='E', 'Ë'='E', 'Ì'='I', 'Í'='I',
                        'Î'='I', 'Ï'='I', 'Ñ'='N', 'Ò'='O', 'Ó'='O', 'Ô'='O', 'Õ'='O', 'Ö'='O', 'Ø'='O',
                        'Ù'='U','Ú'='U', 'Û'='U', 'Ü'='U', 'Ý'='Y', 'Þ'='B', 'ß'='Ss', 'à'='a', 'á'='a',
                        'â'='a', 'ã'='a', 'ä'='a', 'å'='a', 'æ'='a', 'ç'='c','è'='e', 'é'='e', 'ê'='e',
                        'ë'='e', 'ì'='i', 'í'='i', 'î'='i', 'ï'='i', 'ð'='o', 'ñ'='n', 'ò'='o', 'ó'='o',
                        'ô'='o', 'õ'='o','ö'='o', 'ø'='o', 'ù'='u', 'ú'='u', 'û'='u', 'ý'='y', 'ý'='y',
                        'þ'='b', 'ÿ'='y', '`'='', '´'='', '^'='', 'ª'='', 'º'='', '~'='', '"'='',
                        #'¹'='1', '²'='2', '³'='3'
                        '£'='', '¢'='c', '¬'='', '§'='', '°'='', '|'='', '\\n'= ' ', '\\t' = ' ', '\\r' = ' ')
  library(RPostgreSQL)
  library(stringr)
  library(gdata)
  drv <- dbDriver('PostgreSQL')
  con <- dbConnect(drv, dbname='ondefuiroubado', port='5432', user='postgres', password='qwer1234')
  data <- data.frame()
  files <- list.files(path = NEW_PATH, pattern = "*.csv")
  query <- character(0)
  errors <- data.frame()
  
  
  for(v in 1:length(files)){
    data <- read.csv(files[v], strip.white = TRUE)
    for(i in 1:nrow(data)){
      cnames <- colnames(data)
      query <- "INSERT INTO occurrence VALUES("
      #(code, idoccurrence, latitude, longitude, city, type, title, object_1, object_2, object_3, object_4, object_5, object_6, object_7, object_8, object_9, object_10, object_11, object_12, object_13, object_14, object_15, object_16,object_17, object_18, object_19, date_time, description)
      query <- paste(query, data[i,2], ",", sep="")
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
          preproc_data <- as.character(gsub('\'', '', trim(data[i,j])))  
          if(j != 28){
            if(nchar(preproc_data) > 20)
              query <- paste(query, '\'', substr(preproc_data, 1, 20), '\'', ",", sep="")
            else
              query <- paste(query, '\'', preproc_data, '\'', ",", sep="")
          }
          else
            if(j == 28){
              if(nchar(preproc_data) == 0 || is.na(preproc_data))
                query <- paste(query, 'NULL', sep="")
              else if(nchar(preproc_data) > 350)
                query <- paste(query, '\'', substr(preproc_data, 1, 350), '\'', sep="")
              else if(nchar(preproc_data) != 0)
                query <- paste(query, '\'', preproc_data, '\'', sep="")
              
            }
        }
      }
      for(i in seq_along(unwanted_array))
        query <- gsub(names(unwanted_array)[i],unwanted_array[i],query)
      query <- paste(query, ");", sep="")
      print(query)
      result <- tryCatch( {
        rs <- dbSendQuery(con, query)
      }, error = function(e) {
        errors <- rbind(errors, c(files[v], query, e$message))
      })
    }
  }
  time <- gsub(":", "-", Sys.time())
  write.csv(  errors, 
              paste("[LOG]populate_bd ", "-", 
                    "TimeStamp ", time ,".csv", sep = ""))
  lapply(dbListConnections(drv), dbDisconnect)
  dbUnloadDriver(drv)
  setwd(DEFAULT_PATH)
}