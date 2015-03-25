extractData_Projeto1Tarefa1 <- function(firstElement = 1, lastElement = "ALL", repair = FALSE, sample = 1000)
{
    library(XML)
    dataset <- data.frame()
    datasetLOG <- data.frame()
    
    DEFAULT_PATH <- getwd()
    ocorrencias_PATH <- "ocorrencias_ondefuiroubado"
    ocorrencias_LOG_PATH <- "ocorrencias_ondefuiroubado/LOG"
    if (!file.exists(ocorrencias_PATH))
    {
        dir.create(ocorrencias_PATH)
        dir.create(ocorrencias_LOG_PATH)
    }
     
    n_ocorrencia <- firstElement
    startIndex <- n_ocorrencia
    endOfPages <- FALSE
         
    missingValue <- list()
     
    while(ifelse(lastElement == "ALL", 
                 (!endOfPages), 
                 (!endOfPages || (n_ocorrencia > lastElement))))
    {
        result = tryCatch(
        {
            url <- paste("http://www.ondefuiroubado.com.br/denuncias/", n_ocorrencia)
            html <- htmlTreeParse(url, useInternalNodes = TRUE, encoding = "UTF-8")
              
            ##n_ocorrencia
            ##endereco <- xpathSApply(html, "//*[@class=\"sd-info-title\"]", xmlValue)
            latitude <- xpathSApply(html, "//*[@id=\"lat\"]", xmlValue)
            longitude <- xpathSApply(html, "//*[@id=\"lng\"]", xmlValue)
            cidade <- xpathSApply(html, "//*[@class=\"hc-city-name\"]", xmlValue)
            tipo_ocorrencia <- xpathSApply(html, "//*[@class=\"sd-info-type\"]", xmlValue)
            titulo_ocorrencia <- xpathSApply(html, "//*[@class=\"sd-info-title\"]", xmlValue)
            objetos_roubados <- xpathSApply(html, "//*[@class=\"obj-label valign-middle\"]", xmlValue)
            data_hora <- xpathSApply(html, "//*[@class=\"sd-info-data-hora\"]", xmlValue)
                         
            descricao_ocorrencia <- xpathSApply(html, "//*[@class=\"description valign-top\"]", xmlValue)
            if(identical(descricao_ocorrencia, missingValue))
            {
                descricao_ocorrencia <- NA
            }
                         
            ocorrenciaData <- data.frame(n_ocorrencia, latitude, longitude, cidade, tipo_ocorrencia, 
                                         objetos_roubados, data_hora, descricao_ocorrencia)
                         
        }, warning = function(w) {
            ##warning-handler-code
        }, error = function(e) {
            if (e == "failed to load HTTP resource")
            {
                endOfPages <- TRUE   
            }
            else
            {
                datasetLOG <- rbind(datasetLOG, data.frame(LOG =
                    paste(n_ocorrencia, " [UNHANDLED_ERROR] ", e, " TimeStamp: ", Sys.time())
                        , stringsAsFactors = FALSE))
                print(paste("UNHANDLED_ERROR:  ", e))
            }
        }, finally = {
            ##cleanup-code
        })
        
        datasetLOG <- rbind(datasetLOG, data.frame(LOG = 
            paste("nº de ocorrência: ", n_ocorrencia, " lido.", " TimeStamp: ",Sys.time())
                , stringsAsFactors = FALSE))
        print(paste("nº de ocorrência: ", n_ocorrencia, " lido"))
        dataset <- rbind(dataset, ocorrenciaData)    
             
        if (((n_ocorrencia %% sample) == 0) || endOfPages)
        {
            time <- gsub(":", "-", Sys.time())
            setwd(paste(DEFAULT_PATH, "/", ocorrencias_PATH, sep = ""))
            write.csv(dataset, paste("ocorrencias_ondefuiroubado ", startIndex, " - ", n_ocorrencia, ". TimeStamp ", time ,".csv", sep = ""))
            
            setwd(paste(DEFAULT_PATH, "/", ocorrencias_LOG_PATH, sep = ""))
            write.table(datasetLOG, paste("[LOG]ocorrencias_ondefuiroubado ", startIndex, " - ", n_ocorrencia, ". TimeStamp ", time ,".txt", sep = ""))
            startIndex <- n_ocorrencia + 1
        }
                 
        n_ocorrencia <- n_ocorrencia + 1
    } 
    setwd(DEFAULT_PATH)
    return(dataset)
}