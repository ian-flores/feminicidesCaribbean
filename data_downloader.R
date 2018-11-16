# https://github.com/nicholasbucher/R_Scripts/blob/f79023c9a177097b4312279328b15cbe11c0381a/Cepal_API.R
library(XML)
library(httr)
library(xml2)
library(tidyverse)
library(purrr)
library(forcats)
library(ggthemr)
library(feather)
ggthemr('earth')

source('src/get_indicator_response.R')
source('src/get_country_id.R')
source('src/get_data.R')
source('src/save_results_en.R')
source('src/save_results_es.R')

indicator_id <- 2780 # femicides

indicator_response <- get_indicator_response(indicator_id)

crb_countries <- c("Anguila", "Antigua y Barbuda", "Aruba", "Bahamas", 
                   "Barbados", "Bermudas", "Bonaire", "Cuba", 
                    "Curaçao", "Dominica", "Granada", "Guadalupe", 
                   "Guayana Francesa", "Guyana",  "Haití", "Islas Caimán",
                    "Islas Turcas y Caicos", "Islas Vírgenes Británicas",
                    "Islas Vírgenes de los Estados Unidos", "Jamaica", 
                   "Martinica", "Montserrat",  "Puerto Rico", 
                   "República Dominicana",  "Saint Kitts y Nevis", 
                   "San Martín (parte neerlandesa)", 
                   "San Vicente y las Granadinas", 
                   "Santa Lucía", "Suriname", "Trinidad y Tobago")

ca_countries <- c("Belize", "Costa Rica", 
                  "Guatemala", "Panama", 
                  "Nicaragua", "Honduras", "El Salvador")

latam_countries <- c("Argentina",  
                     "Bolivia (Estado Plurinacional de)",
                     "Brazil", "Chile", "Colombia", 
                     "Ecuador", "Mexico",  
                     "Paraguay", "Peru", "Uruguay", 
                     "Venezuela (República Bolivariana de)")

save_results_en(crb_countries, 'the Caribbean', 'caribbean_countries', indicator_response)

save_results_en(ca_countries, 'Central America', 'central-america_countries', indicator_response)

save_results_en(latam_countries, 'the Continental LATAM', 'continental-latam_countries', indicator_response)


save_results_es(crb_countries, 'el Caribe', 'caribbean_countries', indicator_response)

save_results_es(ca_countries, 'Centroamérica', 'central-america_countries', indicator_response)

save_results_es(latam_countries, 'Latino América Continental', 'continental-latam_countries', indicator_response)