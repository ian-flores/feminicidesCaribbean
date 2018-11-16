library(XML)
library(httr)
library(xml2)
library(tidyverse)

get_country_id <- function(.indicator_response, .country_of_interest){
    countries_list <- .indicator_response[[1]]
    countries_list$.attrs <- NULL
    countries <- as.tibble(Reduce(rbind, countries_list))
    country_id <- countries$id[countries$name == .country_of_interest]
    return(country_id)
}