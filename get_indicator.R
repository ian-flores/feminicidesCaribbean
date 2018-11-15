library(XML)
library(httr)
library(xml2)

response<-GET("http://interwp.cepal.org/sisgen/ws/cepalstat/getThematicTree.asp?language=english")
response<-xmlToList(xmlParse(read_xml(response)))
Indicators<-data.frame(matrix(unlist(response$item), nrow = 508, ncol = 2, byrow = TRUE))
colnames(Indicators)<-c("name","id")
View(Indicators)