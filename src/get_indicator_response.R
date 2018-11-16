library(XML)
library(httr)
library(xml2)

get_indicator_response <- function(.indicator_id){
    indicator_response <- GET(paste0("http://interwp.cepal.org/sisgen/ws/cepalstat/getDimensions.asp?idIndicator=", .indicator_id))
    indicator_response <- xmlToList(xmlParse(read_xml(indicator_response)))
    return(indicator_response)
}