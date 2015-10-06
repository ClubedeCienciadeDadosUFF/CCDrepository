get_suburb <- function(FILE_NAME = "geo_places.csv") {
  library(rjson)
  DEFAULT_URL <- 'http://nominatim.openstreetmap.org/reverse?format=json&lat=<<LAT>>&lon=<<LON>>&zoom=18&addressdetails=1'
  result_data <- data.frame(stringsAsFactors=FALSE)
  data <- read.csv(FILE_NAME)
  suburb <- 'DEFAULT'
  temp_dataframe <- data.frame()
  for(i in 1:length(data$latitude))
  {
    temp_dataframe <- data[i,]
    lat <- data[i,]$latitude
    lon <- data[i,]$longitude
    URL <- gsub('<<LAT>>', lat, DEFAULT_URL)
    URL <- gsub('<<LON>>', lon, URL)
    result <- fromJSON(readLines(URL, warn = FALSE)[1])
    suburb <- as.character(result$address$suburb)
    if(identical(suburb, character(0)))
      suburb <- NA    
    temp_dataframe <- cbind(temp_dataframe, suburb)
    result_data <- rbind(result_data, temp_dataframe)
    print(i)
  }
  colnames(result_data) <- c(names(data), 'suburb')
  write.csv(result_data, paste("locations_neighbourhoods.csv", sep=""))
}