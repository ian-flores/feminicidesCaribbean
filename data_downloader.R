# https://github.com/nicholasbucher/R_Scripts/blob/f79023c9a177097b4312279328b15cbe11c0381a/Cepal_API.R
library(XML)
library(httr)
library(xml2)
library(tidyverse)
library(purrr)
library(forcats)
library(ggthemr)
ggthemr('light')

get_indicator_response <- function(.indicator_id){
    indicator_response <-GET(paste0("http://interwp.cepal.org/sisgen/ws/cepalstat/getDimensions.asp?idIndicator=", .indicator_id))
    indicator_response <-xmlToList(xmlParse(read_xml(indicator_response)))
    return(indicator_response)
}

get_country_id <- function(.indicator_response, .country_of_interest){
    countries_list <- .indicator_response[[1]]
    countries_list$.attrs <- NULL
    countries <- as.tibble(Reduce(rbind, countries_list))
    country_id <- countries$id[countries$name == .country_of_interest]
    return(country_id)
}

indicator_id <- 2780 # femicides

indicator_response <- get_indicator_response(indicator_id)

get_data <- function(indicator_response, .country_of_interest){
    
    country_id <- get_country_id(indicator_response, .country_of_interest)
    
    if (length(country_id) == 0){
        #print(.country_of_interest)
    } else {
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
        
        if (length(data) == 1){
            #print(paste0(.country_of_interest, 'not enough'))
        } else{
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


crb_countries <- c("Anguila", "Antigua y Barbuda",
                         "Aruba", "Bahamas", "Barbados", 
                         "Bermudas", "Bonaire", "Cuba", 
                         "Curaçao", "Dominica", "Granada",
                         "Guadalupe", "Guayana Francesa",
                         "Guyana",  "Haití", "Islas Caimán",
                         "Islas Turcas y Caicos",
                         "Islas Vírgenes Británicas",
                         "Islas Vírgenes de los Estados Unidos",
                         "Jamaica", "Martinica", "Montserrat", 
                         "Puerto Rico", "República Dominicana", 
                         "Saint Kitts y Nevis",
                         "San Martín (parte neerlandesa)",
                         "San Vicente y las Granadinas",
                         "Santa Lucía", "Suriname", "Trinidad y Tobago")

crb_result <- map_df(crb_countries, ~ get_data(indicator_response, .x))

crb_result %>%
    filter(!(year %in% c('2017'))) %>%
    ggplot(aes(x = year, y = value, fill = fct_reorder(country, value, .desc = TRUE))) +
        geom_bar(stat = 'identity') +
        coord_flip() +
        ylim(0, NA) +
        labs(title = 'Number of Feminicides in the Caribbean per Year',
            x = 'Year', 
            y = 'Number of Feminicides', 
            fill = 'Country')

ca_countries <- c("Belize", "Costa Rica", 
                  "Guatemala", "Panama", 
                  "Nicaragua", "Honduras", "El Salvador")

ca_result <- map_df(ca_countries, ~ get_data(indicator_response, .x))

ca_result %>%
    ggplot(aes(x = year, y = value, fill = fct_reorder(country, value, .desc = TRUE))) +
    geom_bar(stat = 'identity') +
    coord_flip() +
    ylim(0, NA) +
    labs(title = 'Number of Feminicides in Central America per Year',
         x = 'Year', 
         y = 'Number of Feminicides', 
         fill = 'Country')

latam_countries <- c("Argentina",  
                           "Bolivia (Estado Plurinacional de)",
                           "Brazil", "Chile", "Colombia", 
                           "Ecuador", "Mexico",  
                           "Paraguay", "Peru", "Uruguay", 
                           "Venezuela (República Bolivariana de)")

latam_result <- map_df(latam_countries, ~ get_data(indicator_response, .x))

latam_result %>%
    ggplot(aes(x = year, y = value, fill = fct_reorder(country, value, .desc = TRUE))) +
    geom_bar(stat = 'identity') +
    coord_flip() +
    ylim(0, NA) +
    labs(title = 'Number of Feminicides in Continental Latinamerica per Year',
         x = 'Year', 
         y = 'Number of Feminicides', 
         fill = 'Country')