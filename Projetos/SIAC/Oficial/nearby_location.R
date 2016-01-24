#
# Clube de Ciência de Dados - UFF (CCD-UFF)
# Author: Vítor Lourenço
#
# Last modified: 2015/10/01
#
# This script has the objective to discretize date and time
#

nearby_location <- function(position_radious = 1,
                                occurrences_path = "Niteroi_occurrences.csv",
                                locations_path   = "geo_places.csv") {
  
  haversine <- function(lat1, long1, lat2, long2) {
    KILOMETER_FACTOR = 6373  
    degrees_to_radians = pi/180.0 
    phi1 <- (90.0 - lat1) * degrees_to_radians
    phi2 <- (90.0 - lat2) * degrees_to_radians  
    theta1 <- long1 * degrees_to_radians
    theta2 <- long2 * degrees_to_radians
    
    return(acos((sin(phi1) * sin(phi2) * cos(theta1 - theta2) + cos(phi1) * cos(phi2))))
  }
  
  occ_db <- read.csv(occurrences_path)
  loc_db <- read.csv(locations_path)
  new_db <- data.frame()
  for (i in 1:length(occ_db$latitude)) {
    for (j in 1:length(loc_db$latitude)) {
      if(haversine(occ_db[i,]$latitude, occ_db[i,]$longitude,
                   loc_db[j,]$latitude, loc_db[j,]$longitude) <= position_radious/10000) {
        location_list <- occ_db[i,]
        location_list <- cbind(location_list, nearby_location = loc_db[j,]$type)
        new_db <- rbind(new_db, location_list)
      }
    }
  }
  write.csv(new_db, "nearby_location.csv")
}