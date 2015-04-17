# -----------------------------------------------------------------
# Author : Paulo Mann.
#
# Data science group - UFF
# 
# Script : Extract data from "ondefuiroubado.com.br" - It gives
#          the description of the assault occurrence.
# -----------------------------------------------------------------


retrieveData <- function (start   = 1,
                rows   = 30,
                base_url   = "http://www.ondefuiroubado.com.br/denuncias/")
{
  #  Create a .CSV file containing all information in the base_url.
  #
  #  Args : 
  #   start : The occurrence that the algorithm will start to fetch.
  #   rows : How many occurrences it will fetch.
  #   base_url : The base url that the algorithm uses to fetch information.
  #
  #  Returns : 
  #   This function generates(return) a .CSV data containing all information
  #   given start, rows and base_url.
  
  library (XML)
  library (stringr)
  actual_occurrence <- start
  data <- data.frame ()
  while (actual_occurrence <= rows)
  {
    
    result <- tryCatch (
    {
      url <- paste (base_url,
                    actual_occurrence,
                    sep   = "")
      html_Doc <- htmlTreeParse (url, 
                                useInternalNodes   = TRUE,
                                encoding   = "UTF-8")
      lat <- xpathSApply (html_Doc, 
                         "//*[@id=\"lat\"]",
                         xmlValue)
      lng <- xpathSApply (html_Doc,
                         "//*[@id=\"lng\"]",
                         xmlValue)
      city <- xpathSApply (html_Doc,
                          "//*[@class=\"hc-city-name\"]",
                          xmlValue)
      type <- xpathSApply (html_Doc,
                          "//*[@class=\"sd-info-type\"]",
                          xmlValue)
      title <- xpathSApply (html_Doc, 
                           "//*[@class=\"sd-info-title\"]",
                           xmlValue)
      stolen_objects <-  xpathSApply (html_Doc, 
                                     "//*[@class=\"obj-label valign-middle\"]",
                                     xmlValue)
      stolen_objects <- paste (stolen_objects,
                               collapse   = ",")
      
      date_time <- xpathSApply(html_Doc,
                               "//*[@class=\"sd-info-data-hora\"]",
                               xmlValue)
      date <- strsplit (str_trim (date_time)," ")[[1]][1]
      time <- strsplit (str_trim (date_time)," ")[[1]][2]
      
      description <- xpathSApply (html_Doc, 
                                 "//*[@class=\"description valign-top\"]",
                                 xmlValue)
      
      if (identical (description, list ())) 
      {
        description <- NA
      }
      actual_data <- data.frame (actual_occurrence, lat, 
                                lng, city, type, title,
                                stolen_objects, date,
                                time, description)
      
      data <- rbind (data, actual_data)
    } , error = function (e)
    {
        print (e)
    })
    actual_occurrence <- actual_occurrence + 1
  }
  colnames (data) <- c ("N_Ocorrencia", "Latitude", "Longitude",
                        "Cidade", "Tipo_Assalto", "Titulo",
                        "Objetos_Roubados", "Data", "Hora",
                        "Descricao")
  write.csv2 (data, 
              file   = "ondefuiroubado.csv", 
              row.names   = FALSE)
}

