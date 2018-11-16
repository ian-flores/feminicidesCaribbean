library(XML)
library(httr)
library(xml2)
library(tidyverse)

get_data <- function(indicator_response, .country_of_interest){
    
    country_id <- get_country_id(indicator_response, .country_of_interest)
    
    if (length(country_id) != 0){
        print(paste0('Getting data for: ', .country_of_interest))
        years_list <- indicator_response[[2]]
        years_list$.attrs <- NULL
        years <- as.tibble(Reduce(rbind, years_list))
        year_id <- paste0(years$id, collapse = ',')
        
        base_url <-paste0("http://interwp.cepal.org/sisgen/ws/cepalstat/getDataMeta.asp?IdIndicator=", indicator_id)
        full_url <-paste0(base_url, "&language=", "spanish", "&dim_208=", country_id, "&dim_29117=", year_id)
        #print(full_url)
        
        data_response <-GET(full_url)
        data_response <-xmlToList(xmlParse(read_xml(data_response)))
        data_response$datos$.attrs <- NULL
        data <- as.tibble(Reduce(rbind, data_response$datos))
        
        if (length(data) != 1){
            data %>%
                transmute(year = years[which(years$id %in% dim_29117), ]$name,
                          country = .country_of_interest,
                          source_id = data_response$fuentes$fuente[['descripcion']],
                          value = as.numeric(valor),
                          iso3 = iso3) %>%
                select(country, iso3, year, value, source_id) ->
                data
            
            return(data)   
        }
    }
    
}