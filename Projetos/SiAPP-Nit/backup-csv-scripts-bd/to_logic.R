normalize <- function(input) {
#   subf <- c(" ", "�", "�", "�", "�", "�", "�", "�", "�", "'", "�", "�")
#   subt <- c("_", "a", "e", "i", "o", "u", "a", "e", "o", "_", "c", "a")
#   unwanted_array = list(    'S'='S', 's'='s', 'Z'='Z', 'z'='z', '�'='A', '�'='A', '�'='A', '�'='A', '�'='A', '�'='A', '�'='A', '�'='C', '�'='E', '�'='E',
#                             '�'='E', '�'='E', '�'='I', '�'='I', '�'='I', '�'='I', '�'='N', '�'='O', '�'='O', '�'='O', '�'='O', '�'='O', '�'='O', '�'='U',
#                             '�'='U', '�'='U', '�'='U', '�'='Y', '�'='B', '�'='Ss', '�'='a', '�'='a', '�'='a', '�'='a', '�'='a', '�'='a', '�'='a', '�'='c',
#                             '�'='e', '�'='e', '�'='e', '�'='e', '�'='i', '�'='i', '�'='i', '�'='i', '�'='o', '�'='n', '�'='o', '�'='o', '�'='o', '�'='o',
#                             '�'='o', '�'='o', '�'='u', '�'='u', '�'='u', '�'='y', '�'='y', '�'='b', '�'='y' )
    input <- tolower(input)
#   for(i in seq_along(unwanted_array))
#     input <- gsub(names(unwanted_array)[i],unwanted_array[i],input)
#   
    return(input)
}

to_logic <- function(FILE_NAME = "time_discretize_suburb_updated.csv") {
  dataset <- read.csv(FILE_NAME) #header = TRUE, encoding = "utf8")
  last_occ = -1
  last_sub = "-1"
  obj <- c("carteira", "bolsa_ou_mochila", "celular", "documentos",
           "notebook", "tablet", "mp4_ou_ipod", "cartao_de_credito",
           "outros", "relogio", "equipamento_de_som", "tv", "dvd", "som",
           "moveis", "computador", "estepe", "bicicleta", "dinheiro")
  for(i in 1:length(dataset$n_occurrence)) {        
    if(dataset$n_occurrence[i] != last_occ) {
      last_occ = dataset$n_occurrence[i]
      last_sub = dataset$suburb[i]
      #.f
      write(paste("occurrence(",
                  dataset$n_occurrence[i],
                  ",",
                  normalize(substr(dataset$occurrence_type[i], 1, nchar(as.vector(dataset$occurrence_type[i]))-1)),
                  #normalize(dataset$occurrence_type[i]),
                  ").", sep = ""),
            "siac.f", append = TRUE, sep = "\n")
      
      #.b   
      #geo_position
      write(paste("geo_position(",
                  last_occ,
                  ",",
                  normalize(dataset$suburb[i]),
                  ").", sep = ""),
            "siac.b", append = TRUE, sep = "\n")
      #date
      if(dataset$date[i] == "business_day") {
        write(paste("business_day(",
                    last_occ,
                    ").", sep = ""),
              "siac.b", append = TRUE, sep = "\n")
      } else {
        write(paste("weekend(",
                    last_occ,
                    ").", sep = ""),
              "siac.b", append = TRUE, sep = "\n")
      }
      #time
      if(dataset$time[i] == "morning") {
        write(paste("morning(",
                    last_occ,
                    ").", sep = ""),
              "siac.b", append = TRUE, sep = "\n")
      } else if(dataset$time[i] == "dawn") {
        write(paste("dawn(",
                    last_occ,
                    ").", sep = ""),
              "siac.b", append = TRUE, sep = "\n")
      } else if(dataset$time[i] == "night") {
        write(paste("night(",
                    last_occ,
                    ").", sep = ""),
              "siac.b", append = TRUE, sep = "\n")
      } else {
        write(paste("evening(",
                    last_occ,
                    ").", sep = ""),
              "siac.b", append = TRUE, sep = "\n")
      }
      #obj
      for(j in obj) {
        if(with(dataset[i,], get(j)) == "TRUE") {
          write(paste("object(",
                      last_occ,
                      ",",
                      j,
                      ").", sep = ""),
                "siac.b", append = TRUE, sep = "\n")
        }
      }
    }
    #.b
    #nearby_location
    if(dataset$nearby_location[i] != "")
    {
      write(paste("nearby_location(",
                  last_occ,
                  ",",
                  normalize(dataset$nearby_location[i]),
                  ").", sep = ""),
            "siac.b", append = TRUE, sep = "\n")
      #in
      write(paste("in(",
                  normalize(dataset$nearby_location[i]),
                  ",",
                  normalize(last_sub),
                  ").", sep = ""),
            "siac.b", append = TRUE, sep = "\n")
    }
  }
}

build_negative <- function(FILE_NAME = "time_discretize_suburb_updated.csv") {
  dataset <- read.csv(FILE_NAME)
  crime_list <- c("roubo","furto","assalto_relampago", "roubo_de_veiculo","assalto_a_grupo",
                  "arrombamento_veicular","arrombamento_domiciliar","sequestro_relampago")
  last_occ <- -1
  for(i in 1:length(dataset$n_occurrence)) {
    crime <- normalize(substr(dataset$occurrence_type[i],
                              1, nchar(as.vector(dataset$occurrence_type[i]))-1))
    if(last_occ != dataset$n_occurrence[i])
    {
      repeat
      {
        index <- sample(1:length(crime_list), 2, replace=F)
        if((crime_list[index[1]] != crime) && (crime_list[index[2]] != crime))
        {
          #.n
          write(paste("occurrence(",
                      dataset$n_occurrence[i],
                      ",",
                      crime_list[index[1]],
                      ").", sep = ""),
                "siac.n", append = TRUE, sep = "\n")
          write(paste("occurrence(",
                      dataset$n_occurrence[i],
                      ",",
                      crime_list[index[2]],
                      ").", sep = ""),
                "siac.n", append = TRUE, sep = "\n")
          break
        }
      }   
      last_occ = dataset$n_occurrence[i]
    }
  }
}