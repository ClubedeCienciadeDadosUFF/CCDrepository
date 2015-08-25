time_discretize <- function() {
  DEFAULT_PATH <- getwd()
  nearby_location_db <- read.csv("nearby_location.csv")
  new_db <- data.frame()
  for (i in 1:length(nearby_location_db[,1])) {
    #date
    new_line <- nearby_location_db[i, 1:26]
    x <- toString(nearby_location_db[i,]$date)
    x <- weekdays(as.Date(x,'%Y-%m-%d'))
    if (x == "domingo" || x == "sábado") {
      x <- "weekend"
    } else {
      x <- "business_day"
    }
    new_line <- cbind(new_line, date = x)
    #time
    x <- toString(nearby_location_db[i,]$time)
    x <- strsplit(x, ":")[[1]]
    x <- as.numeric(x[1])
    if(x >= 0 && x < 6) {
      new_line <- cbind(new_line, time = "dawn")
    } else if(x >= 6 && x < 12) {
      new_line <- cbind(new_line, time = "morning")
    } else if(x >= 12 && x < 18) {
      new_line <- cbind(new_line, time = "evening")
    } else if(x >= 18 && x < 24) {
      new_line <- cbind(new_line, time = "night")
    }
    new_line <- cbind(new_line, nearby_location = nearby_location_db[i, 29])
    new_db <- rbind(new_db, new_line)
    if(i%%10000 == 0) {
      write.csv(new_db, paste("time_discretize",".csv", sep = ""))
      print(paste(i, " completed"))
    }
  }
  print(paste("All the ", i, " are completed"))
  write.csv(new_db, paste("time_discretize",".csv", sep = ""))
}