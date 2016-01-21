# Copyright: Clube de Ciência de Dados
# Author: Vítor Lourenço
# Description: This file is especific for get information from the website
#   input: none
#   output: dataset
# Library: XML
# Functions:
#   scrape: gerate the dataset
#   getData: get all data from a specific URL

scrape <- function() {
  # Set up the dataset

  library("XML")
  getData <- function(page = 1) {
    # Get all important information from a specific URL
    # Args: 
    #   page: Number of the URL
    # Returns:
    #   In case it works: Dataframe
    #   In case it did not works: Error

    tryCatch( {
      # Set up the url to be parsed
      url <- paste("http://www.ondefuiroubado.com.br/denuncias/", page)
      # Create the parse tree
      html <- htmlTreeParse(url, useInternalNodes = TRUE, encoding = "UTF-8")

      # Get latitude
      lat <- xpathSApply(html,
                         "//*[@id=\"lat\"]",
                         xmlValue)
      # Get longitude
      lng <- xpathSApply(html,
                         "//*[@id=\"lng\"]",
                         xmlValue)
      # Get report
      report <- xpathSApply(html,
                            "//*[@id=\"id_report\"]",
                            xmlValue)
      # Get objects list
      objects <- xpathSApply(html,
                             "//*[@class=\"obj-label valign-middle\"]",
                             xmlValue)
      # Get title
      title <- xpathSApply(html,
                           "//*[@class=\"sd-info-title\"]",
                           xmlValue)
      # Get type
      type <- xpathSApply(html,
                          "//*[@class=\"sd-info-type\"]",
                          xmlValue)
      # Get date and time
      date_time <- xpathSApply(html,
                               "//*[@class=\"sd-info-data-hora\"]",
                               xmlValue)
      # Get description
      description <- xpathSApply(html,
                                 "//*[@class=\"description valign-top\"]",
                                 xmlValue)
      data <- data.frame(report, url, lat, lng, type, 
                         date_time, title, description, objects)
      return(data)
    }, error = function(e) {
      # In case end of pages
      if (e$message == "failed to load HTTP resource\n") {
        return("end")
      }
      # In case error
      return("error")
    })
  }
  end = FALSE
  page = 1
  data <- NULL
  # Continually getting data until ends
  while(!end) {
    end <- getData(page)
    page = page + 1
    if (end != "end" && end == "error") {
      return("error")
    } else if(end != "end") {
      data <- end
    } else {
      return(data)
    }
  }
}