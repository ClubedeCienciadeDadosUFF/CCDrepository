get_nearby_location <- function() {
  
  haversine <- function(lat1, long1, lat2, long2) {
    KILOMETER_FACTOR = 6373  
    degrees_to_radians = pi/180.0 
    phi1 <- (90.0 - lat1) * degrees_to_radians
    phi2 <- (90.0 - lat2) * degrees_to_radians
    
    theta1 <- long1 * degrees_to_radians
    theta2 <- long2 * degrees_to_radians
    
    return(acos((sin(phi1) * sin(phi2) * cos(theta1 - theta2) + cos(phi1) * cos(phi2))))
  }
  DEFAULT_PATH <- getwd()
  setwd(paste(DEFAULT_PATH, "/ondefuiroubado_occurrences", sep=""))
  occ_db <- read.csv("Niteroi_occurrences.csv")
  loc_db <- read.csv("geo_places.csv")
  new_db <- data.frame()
  
  for (i in 1:length(occ_db[,3])) {
    for (j in 1:length(loc_db[,1])) {
      if(haversine(occ_db[i, 3], occ_db[i, 4], loc_db[j, 1], loc_db[j, 2]) <= 0.0005) {
        x <- occ_db[i,]
        x <- cbind(x, nearby_location = loc_db[j, 5])
        new_db <- rbind(new_db, x)
      }
    }
    print(paste("nova ocorrencia ", i))
  }
  setwd(DEFAULT_PATH)
  
  write.csv(new_db, 
            paste("nearby_location",".csv", sep = ""))
}