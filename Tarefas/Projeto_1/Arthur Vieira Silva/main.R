library('rvest')
library('stringr')

get_data <- function(page){
  robbed_page <- html(page)
  
  title <- robbed_page %>%
    html_nodes("section.sd-info-denuncia h1") %>%
    html_text()
  title
  
  objects <- robbed_page %>%
    html_nodes("section.sd-objects div div.sd-objects-list") %>%
    html_text();
  exp <- gregexpr("([A-Z][A-Za-zÀ-Ûà-û ]*)",objects, perl=TRUE )
  objects <- regmatches(objects, exp)[[1]]
  
  type <- robbed_page %>%
    html_nodes("section.sd-info-denuncia h2.sd-info-type") %>%
    html_text()
  type <- str_trim(type)
  
  date_time <- robbed_page %>%
    html_nodes("section.sd-info-denuncia span.sd-info-data-hora") %>%
    html_text()
  date_time <- strsplit(str_trim(date_time), " ")[[1]]
  
  description <- robbed_page %>%
    html_nodes("section.sd-info-denuncia div.sd-info-desc") %>%
    html_text()
  description <- str_trim(description)
  
  text <- paste(title, type, date_time[1], date_time[2], paste(objects, collapse=","), sep=";")
}

text <- get_data("http://www.ondefuiroubado.com.br/denuncias/44783/assaltada-voltando-do-mercado")
data <- read.table(col.names=c("title","type", "date", "time", "objects"), text=text, sep=';')