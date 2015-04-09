library('rvest')
library('stringr')
robbed_page <- html("http://www.ondefuiroubado.com.br/denuncias/44783/assaltada-voltando-do-mercado")

title <- robbed_page %>%
  html_nodes("section.sd-info-denuncia h1") %>%
  html_text()
title

objects <- robbed_page %>%
  html_nodes("section.sd-objects div div.sd-objects-list") %>%
  html_text();
exp <- gregexpr("([A-Z][A-Za-zÀ-Ûà-û ]*)",objects, perl=TRUE )
objects <- regmatches(objects, exp)
objects

type <- robbed_page %>%
  html_nodes("section.sd-info-denuncia h2.sd-info-type") %>%
  html_text()
str_trim(type)

date_time <- robbed_page %>%
  html_nodes("section.sd-info-denuncia span.sd-info-data-hora") %>%
  html_text()
str_trim(date_time)

description <- robbed_page %>%
  html_nodes("section.sd-info-denuncia div.sd-info-desc") %>%
  html_text()
str_trim(description)