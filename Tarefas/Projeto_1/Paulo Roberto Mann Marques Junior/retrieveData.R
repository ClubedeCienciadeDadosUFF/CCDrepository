retrieveData <- function(rows = 30, baseUrl = "http://www.ondefuiroubado.com.br/denuncias/")
{
  library(XML)
  library(stringr)
  actual_ocurrence <- 1
  data <- data.frame()
  while(actual_ocurrence <= rows)
  {
    
    result <- tryCatch(
    {
      url <- paste(baseUrl, actual_ocurrence, sep="")
      html_Doc <- htmlTreeParse(url, useInternalNodes = TRUE, encoding= "UTF-8")
      #adress <- xpathSApply(html_Doc, "//span[@class=\"sd-adress-desc\"]", xmlValue)
      lat <- xpathSApply(html_Doc, "//*[@id=\"lat\"]", xmlValue)
      lng <- xpathSApply(html_Doc, "//*[@id=\"lng\"]", xmlValue)
      city <- xpathSApply(html_Doc, "//*[@class=\"hc-city-name\"]", xmlValue)
      type <- xpathSApply(html_Doc, "//*[@class=\"sd-info-type\"]", xmlValue)
      title <- xpathSApply(html_Doc, "//*[@class=\"sd-info-title\"]", xmlValue)
      stolen_objects <-  xpathSApply(html_Doc, "//*[@class=\"obj-label valign-middle\"]", xmlValue)
      stolen_objects <- paste(stolen_objects, collapse=",")
      date_time <- xpathSApply(html_Doc, "//*[@class=\"sd-info-data-hora\"]", xmlValue)
      date <- strsplit(str_trim(date_time)," ")[[1]][1]
      time <- strsplit(str_trim(date_time)," ")[[1]][2]
      description <- xpathSApply(html_Doc, "//*[@class=\"description valign-top\"]", xmlValue)
      if(identical(description, list()))
      {
        description <- NA
      }
      actual_data <- data.frame(actual_ocurrence, lat, lng, city, type, title,
                                stolen_objects, date, time, description)
      data <- rbind(data, actual_data)
    } , error = function(e)
    {
        print(e)
    })
    actual_ocurrence <- actual_ocurrence + 1
  }
  colnames(data) <- c("N_Ocorrencia", "Latitude", "Longitude", "Cidade", "Tipo_Assalto", 
                        "Titulo", "Objetos_Roubados", "Data", "Hora", "Descricao")
  write.csv2(data, file = "ondefuiroubado.csv", row.names = FALSE)
}

