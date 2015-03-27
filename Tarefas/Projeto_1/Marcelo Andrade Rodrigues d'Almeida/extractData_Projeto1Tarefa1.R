extractData_Projeto1Tarefa1 <- function(firstElement = 1, lastElement = "ALL", repair = FALSE, update = FALSE, sample = 1000)
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
     
    n <- firstElement
    startIndex <- n
    endOfPages <- FALSE
         
    missingValue <- list()
     
    while(ifelse(lastElement == "ALL", 
                 (!endOfPages), 
                 (!endOfPages && (n <= lastElement))))
    {
        result <- tryCatch(
        {
            url <- paste("http://www.ondefuiroubado.com.br/denuncias/", n)
            html <- htmlTreeParse(url, useInternalNodes = TRUE, encoding = "UTF-8")
              
            n_ocorrencia <- xpathSApply(html, "//*[@id=\"id_report\"]", xmlValue)
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
            error <<- e
            print(paste("\\", e, "\\"))
            if (e$message == "failed to load HTTP resource\n")
            {
                return("endOfPages")
            }
            else
            {
                return("UNHANDLED_ERROR")
            }
        }, finally = {
            ##cleanup-code
        })
        
        suppressWarnings(
        if(result == "endOfPages")
        {
            endOfPages = TRUE
        }
        else
        {
            if(result == "UNHANDLED_ERROR")
            {
                datasetLOG <- rbind(datasetLOG, data.frame(
                    LOG = paste(n, " [UNHANDLED_ERROR] ", result, " TimeStamp: ", Sys.time()),
                    stringsAsFactors = FALSE))
                print(paste("UNHANDLED_ERROR:  ", result))
            }
        }
        )
        datasetLOG <- rbind(datasetLOG, data.frame(LOG = 
            paste("nº de ocorrência: ", n, " lido.", " TimeStamp: ",Sys.time())
                , stringsAsFactors = FALSE))
        print(paste("nº de ocorrência: ", n, " lido"))
        dataset <- rbind(dataset, ocorrenciaData)    
             
        if (((n %% sample) == 0) || endOfPages || (n == lastElement))
        {
            time <- gsub(":", "-", Sys.time())
            setwd(paste(DEFAULT_PATH, "/", ocorrencias_PATH, sep = ""))
            write.csv(dataset, paste("ocorrencias_ondefuiroubado ", startIndex, " - ", n, ". TimeStamp ", time ,".csv", sep = ""))
            
            setwd(paste(DEFAULT_PATH, "/", ocorrencias_LOG_PATH, sep = ""))
            write.table(datasetLOG, paste("[LOG]ocorrencias_ondefuiroubado ", startIndex, " - ", n, ". TimeStamp ", time ,".txt", sep = ""))
            
            dataset <- data.frame()
            datasetLOG <- data.frame()
            
            startIndex <- n + 1
        }
                 
        n <- n + 1
    } 
    setwd(DEFAULT_PATH)
}

collect <- function()
{
    
}

update <- function()
{
    
}

repair <- function()
{
    
}