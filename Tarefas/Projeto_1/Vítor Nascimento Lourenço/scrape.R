scrape <- function() {
  library("XML")
  get_data <- function(page = 1) {
    tryCatch( {
      url <- paste("http://www.ondefuiroubado.com.br/denuncias/", page)
      html <- htmlTreeParse(url, useInternalNodes = TRUE, encoding = "UTF-8")
      lat <- xpathSApply(html, "//*[@id=\"lat\"]", xmlValue)
      lng <- xpathSApply(html, "//*[@id=\"lng\"]", xmlValue)
      report <- xpathSApply(html, "//*[@id=\"id_report\"]", xmlValue)
      objects <- xpathSApply(html, "//*[@class=\"obj-label valign-middle\"]", xmlValue)
      title <- xpathSApply(html, "//*[@class=\"sd-info-title\"]", xmlValue)
      type <- xpathSApply(html, "//*[@class=\"sd-info-type\"]", xmlValue)
      date_time <- xpathSApply(html, "//*[@class=\"sd-info-data-hora\"]", xmlValue)
      description <- xpathSApply(html, "//*[@class=\"description valign-top\"]", xmlValue)
      data <- data.frame(report, url, lat, lng, type, date_time, title, description, objects)
      return(data)
    }, error = function(e) {
      if (e$message == "failed to load HTTP resource\n") {
        return("end")
      }
      return("error")
    })
    end = FALSE
    page = 1
    data <- NULL
    while(!end) {
      end <- get_data(page)
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
}