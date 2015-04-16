extractData_Projeto1Tarefa1 <- function(first_element = 1,
    last_element = "ALL", repair = FALSE, update = FALSE, sample = 1000){
    
    # Clube de Ciência de Dados - UFF (CCD-UFF)
    # Author: Marcelo A. R. d'Almeida
    #
    # Last modified: 2015/04/16
    #
    # This script has the objective to extract the data from 'ondefuiroubado'
    # site
    #
    # Args:
    #   first_element = 1     : points out the first element to start the 
    #                           sweeping
    #   last_element  = "ALL" : points out the last element which will stop the
    #                           sweeping
    #   repair        = FALSE : points out if the script will only try to 
    #                           repair the missing elements
    #   update        = FALSE : points out if the script will only sweep from 
    #                           the last recorded element
    #   sample        = 1000  : points out the numbers of elements to record in
    #                           each .csv file 
    #
    # Returns:
    #   Several files with the retrieved data and several log files with the 
    #   outcome
    #
    #
    # Strong Points:
    #   - Stores the entire data in a relatively regular small data packages 
    #     (Default: 1000)
    #   - Enables partial data retrieving (first-to-last element sweep)
    #   - NOT YET IMPLEMENTED - Enables repairing the gathered data
    #   - NOT YET IMPLEMENTED - Enables incremental updates to gathered data
    #   - Stores log information
    #   - Organize the retrieved data and log in directory tree (folders)
    #   - Handles possible missing value in occurrence description
    #   - Handles errors to allow uninterrupted sweeping
    #   - File names contains date-time information
    #
    
    
    library(XML)
    dataset <- data.frame()
    dataset_log <- data.frame()
    
    DEFAULT_PATH <- getwd()
    OCCURRENCES_PATH <- "ondefuiroubado_occurrences"
    OCCURRENCES_LOG_PATH <- "ondefuiroubado_occurrences/LOG"
    BASE_URL <- "http://www.ondefuiroubado.com.br/denuncias/"
    
    if (!file.exists(OCCURRENCES_PATH)) {
        dir.create(OCCURRENCES_PATH)
        dir.create(OCCURRENCES_LOG_PATH)
    }
     
    n <- first_element
    start_index <- n
    end_of_pages <- FALSE
         
    missing_value <- list()
    
    
    while (ifelse(last_element == "ALL", 
                 (!end_of_pages), 
                 (!end_of_pages && (n <= last_element)))) {
        result <- tryCatch( {
            url <- paste(BASE_URL, n)
            
            # Retrieve the entire html page
            html <- htmlTreeParse(url, useInternalNodes = TRUE, 
                                  encoding = "UTF-8")
              
            # Retrieve field values with xpath notation
            n_occurrence           <- xpathSApply(html, 
                                        "//*[@id=\"id_report\"]", 
                                        xmlValue)
            latitude               <- xpathSApply(html, 
                                        "//*[@id=\"lat\"]", 
                                        xmlValue)
            longitude              <- xpathSApply(html, 
                                        "//*[@id=\"lng\"]", 
                                        xmlValue)
            city                   <- xpathSApply(html, 
                                        "//*[@class=\"hc-city-name\"]",
                                        xmlValue)
            occurrence_type        <- xpathSApply(html, 
                                        "//*[@class=\"sd-info-type\"]",
                                        xmlValue)
            occurrence_title       <- xpathSApply(html, 
                                        "//*[@class=\"sd-info-title\"]",
                                        xmlValue)
            spoil                  <- xpathSApply(html, 
                                        "//*[@class=\"obj-label valign-middle\"]",
                                        xmlValue)
            date_time              <- xpathSApply(html, 
                                        "//*[@class=\"sd-info-data-hora\"]",
                                        xmlValue)    
            occurrence_description <- xpathSApply(html, 
                                        "//*[@class=\"description valign-top\"]", 
                                        xmlValue)
            
            # There is some occurrences that description is missing
            if (identical(occurrence_description, missing_value)) {
                occurrence_description <- NA
            }
                         
            # organize the data retrieved
            occurrence_data <- data.frame(n_occurrence, latitude, longitude, 
                                          city, occurrence_type, spoil, 
                                          date_time, occurrence_description)
                         
        }, warning = function(w) {
            ##warning-handler-code
        }, error = function(e) {
            error <- e
            print(paste("\\", e, "\\"))
            if (e$message == "failed to load HTTP resource\n"){
                return("end_of_pages")
            } else {
                return("UNHANDLED_ERROR")
            }
        })
        
        # Code to handle error
        suppressWarnings(
        if (result == "end_of_pages") {
            ## end_of_pages = TRUE # Only works if the middle pages are 
                                   # 404 pages and final is another error
        } else {
            if (result == "UNHANDLED_ERROR") {
                dataset_log <- rbind(dataset_log, data.frame(
                    LOG = paste(n, " [UNHANDLED_ERROR] ", result, 
                              " TimeStamp: ", Sys.time()),
                    stringsAsFactors = FALSE))
                print(paste("UNHANDLED_ERROR:  ", result))
            }
        }
        )
        
        dataset_log <- rbind(dataset_log, data.frame(LOG = 
            paste("occurrence: ", n, " read.", " TimeStamp: ",Sys.time())
                , stringsAsFactors = FALSE))
        print(paste("occurrence : ", n, " read"))
        dataset <- rbind(dataset, occurrence_data)    
             
        if (((n %% sample) == 0) || end_of_pages || (n == last_element)) {
            time <- gsub(":", "-", Sys.time())
            setwd(paste(DEFAULT_PATH, "/", OCCURRENCES_PATH, sep = ""))
            write.csv(dataset, 
                      paste("ondefuiroubado_occurrences ", start_index, 
                            " - ", n, ". TimeStamp ", time ,".csv", sep = ""))
            
            setwd(paste(DEFAULT_PATH, "/", OCCURRENCES_LOG_PATH, sep = ""))
            write.table(dataset_log, 
                        paste("[LOG]ondefuiroubado_occurrences ", start_index, 
                              " - ", n, ". TimeStamp ", time ,".txt", sep = ""))
            
            dataset <- data.frame()
            dataset_log <- data.frame()
            
            start_index <- n + 1
        }
                 
        n <- n + 1
    } 
    
    # Set the working directory to original one
    setwd(DEFAULT_PATH)
}