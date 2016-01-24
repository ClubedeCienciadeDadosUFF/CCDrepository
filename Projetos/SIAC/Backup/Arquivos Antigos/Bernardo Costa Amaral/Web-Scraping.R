# Copyright: Clube de Ciência de Dados
# Author: Bernardo Costa Amaral
# Description: This file is responsable for retrieving of information from 
  # "Onde Fui Roubado" (http://www.ondefuiroubado.com.br) and organizing it
  # into a .csv format dataset
#   input: none
#   output: .csv format dataset
# Library: XML
# Functions:
#   main: get the data from the website and generate the dataset
#   getStolen: convert a list of characters of stolen objects into a 
      # Boolean vector
#   getDesc: get and clean the description of the theft

library("XML")

getStolen <- function(objects, options){
  # convert list of characters of stolen objects into a Boolean vector
  #
  # Args:
  #   objects: a list of characters representing all stolen objects
  #   options: a vector of characters representing all possible  stolen objects
  #
  # Returns:
  #   A Boolean vector representing the stolen vector
  
  res <- c()
  for (obj in options){
    res <- c(res, any(objects == obj))
  }
  return(res)
}

getDesc <- function(page){
  # get and clean the description of the theft
  #
  # Args:
  #   page: the HTML page of which the data will be retrieved
  #
  # Returns:
  #   The clean description of the theft
  
  result = tryCatch({
    res <-xpathApply(page, "//section/div/h3", xmlValue)
    clean_data <- str_replace_all(toString(res), "\r", "")
    clean_data <- str_replace_all(clean_data, "\n", "")
    clean_data <- str_replace_all(clean_data, ";", "")
    clean_data <- str_replace_all(clean_data, ",", "")
    clean_data <- str_replace_all(clean_data, "\t", "")
    if (regexpr("[a-z]", clean_data) == -1) {
      clean_data <- "Sem descrição"
    }
    return(clean_data)
    }, error = function(e) result = "Sem descrição")
  return(result)
  }

OPTIONS <- c("Carteira", "Bolsa ou Mochila", "Celular", "Documentos",
             "Notebook", "Tablet", "MP4 ou Ipod", "Cartão de Crédito", "Outros",
             "Relógio", "Equipamento de Som", "Tv", "DVD", "Som", "Móveis",
             "Computador", "Estepe", "Bicicleta", "Dinheiro")
TABLE_COL <- c("id","titulo", "tipo", "hora", "desc", "cidade", "latitude",
               "longitude", "Carteira", "Bolsa ou Mochila", "Celular", 
               "Documentos", "Notebook", "Tablet", "MP4 ou Ipod",
               "Cartão de Crédito", "Outros", "Relógio", "Equipamento de Som",
               "Tv", "DVD", "Som", "Móveis", "Computador", "Estepe",
               "Bicicleta", "Dinheiro")
BASE_PAGE <-"http://www.ondefuiroubado.com.br/denuncias/"
setwd("//CCDrepository/Tarefas/Projeto_1")

prev_id <- 0
id<- 1
write.table(matrix(as.character(TABLE_COL), nrow = 1),
            file = "dados_de_roubos.csv", append =TRUE, row.names = FALSE,
            col.names = FALSE,sep = ",", eol = "\r\n")
page_counter<- 1

while (prev_id != id){
  prev_id <- id  
  results <- data.frame(NA[1:100],NA[1:100],NA[1:100],NA[1:100],NA[1:100],
                        NA[1:100],NA[1:100],NA[1:100],NA[1:100],NA[1:100],
                        NA[1:100],NA[1:100],NA[1:100],NA[1:100],NA[1:100],
                        NA[1:100],NA[1:100],NA[1:100],NA[1:100],NA[1:100],
                        NA[1:100],NA[1:100],NA[1:100],NA[1:100],NA[1:100],
                        NA[1:100],NA[1:100])
  colnames(results) <- TABLE_COL
  for (page_counter in (page_counter):(page_counter+99)){
    caught = tryCatch({
      page <- htmlTreeParse(paste(BASE_PAGE, page_counter),
                            useInternalNodes = TRUE, encoding = "UTF-8")
      
      results[id,"latitude"]  <- xpathApply(page, "//div[@id='lat']", xmlValue)
      results[id,"longitude"] <- xpathApply(page, "//div[@id='lng']", xmlValue)
      city                    <- xpathApply(page, "//div/div/h4", xmlValue)
      results[id,"cidade"]    <- city[1]
      results[id,"titulo"]    <- xpathApply(page, "//section/h1", xmlValue)
      results[id,"tipo"]      <- xpathApply(page, "//section/h2", xmlValue)
      results[id,"hora"]      <- as.POSIXct(strptime(xpathApply(page,
                            "//section/span",xmlValue), "%d/%m/%Y %H:%M"))
      stolen <- xpathApply(page, "//section/div/div/div/span", xmlValue)
      
      vect_presence <- getStolen(stolen, OPTIONS)
      
      for (col in 1:19)
        results[id,8+col] <- vect_presence[col]
      results[id, "id"]  <- id
      results[id,"desc"] <- getDesc(page)
      id <- id+1
    },error = function(e) print(page_counter))
  }
  write.table(results[prev_id:(id-1),], file = "dados_de_roubos.csv",
              append =TRUE, row.names = FALSE,col.names = FALSE, sep = ",",
              eol = "\r\n")
}