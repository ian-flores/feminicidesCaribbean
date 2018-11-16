library(XML)
library(httr)
library(xml2)

get_all_indicators <- function(){
    response<-GET("http://interwp.cepal.org/sisgen/ws/cepalstat/getThematicTree.asp?language=english")
    response<-xmlToList(xmlParse(read_xml(response)))
    indicators<-data.frame(matrix(unlist(response$item), nrow = 508, ncol = 2, byrow = TRUE))
    colnames(indicators)<-c("name","id")
    
    return(indicators)
}
