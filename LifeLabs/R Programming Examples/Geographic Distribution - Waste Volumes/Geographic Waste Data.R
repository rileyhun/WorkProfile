data<-read.csv("Stericycle Waste Data.csv")
library(reshape2)
library(ggplot2)
library(plyr)
library(data.table)
library(ggmap)
names(data)<-c("ID1","ID2", "Site.Address", "Type", "City", "Province", "Category", "Density", "Nov-14", "Dec-14", "Jan-15", "Feb-15", "Mar-15", "Apr-15", "May-15", "Jun-15", "Jul-15", "Aug-15", "Sep-15", "Oct-15", "Nov-15", "Dec-15", "Jan-16")
data<-melt(data, c("ID1","ID2", "Site.Address","Type", "City", "Province", "Category", "Density"))
View(data)
data<-na.omit(data)
data_grouped<-ddply(data, c("Site.Address", "Type","City", "Province", "Category", "Density", "variable"), summarise, value=sum(value))
View(data_grouped)
names(data_grouped)<-c("Site.Address", "Type", "City", "Province", "Category", "Density", "Month", 'Waste.Mass')
###---###
dummy<-data_grouped[!duplicated(data_grouped[,1]),]
coordinates<-geocode(as.character(dummy[,1]))
dummy<-cbind(dummy,coordinates)
dummy<-subset(dummy, select=c("Site.Address", "lon", "lat"))
write.csv(dummy, "locations-coordinates.csv")
###---####

dummy<-read.csv('locations-coordinates.csv')
geodata<-merge(data_grouped, dummy, by.x="Site.Address", by.y="Site.Address", all.y=TRUE)
View(geodata)

library(shiny)
saveas <- function(map, file){
  class(map) <- c("saveas", class(map))
  attr(map, "filesave")=file
  map
}

print.saveas <- function(x, ..){
  class(x) = class(x)[class(x)!="saveas"]
  htmltools::save_html(x, file=attr(x,"filesave"))
}

geodata_avg<-ddply(geodata, c("Site.Address", "Type", "City", "Province", "Category", "Density", "lon", "lat"), summarise, value = mean(Waste.Mass))
View(geodata_avg)
s<-geodata_avg
a = rep(NA, nrow(s))
for (i in 1:nrow(s)) {
  if (s$value[i]>1000){
    a[i] = 10
  } else if (s$value[i]>100) {
    a[i] = 8
  } else if (s$value[i]> 44.5) {
    a[i] = 6
  } else if (s$value[i]> 26.2) {
    a[i] = 4
  } else if (s$value[i]> 15.5) {
    a[i] = 2
  } else {
    a[i] = 1
    i= i+1
  }
  a
}

r<-geodata_avg
b = rep(NA, nrow(s))
for (j in 1:nrow(s)) {
  if (r$Density[j]>300){
    b[j] = 1
  } else if (r$Density[j]>100) {
    b[j] = 2
  } else if (r$Density[j]> 40) {
    b[j] = 3
  } else if (r$Density[j]> 10) {
    b[j] = 4
  } else {
    b[j] = 5
    j= j+1
  }
  b
}

density_factor = b
rank = a
geodata_avg<-cbind(geodata_avg, rank, density_factor)

###---###

library(leaflet)
newmap <- leaflet(data=geodata_avg) %>% addTiles() %>%
  addMarkers(~lon, ~lat, popup = paste("Site Address: ", geodata_avg$Site.Address, "<br>", "Category: ", geodata_avg$Category, "<br>", "Average Waste: ", geodata_avg$value), clusterOptions = markerClusterOptions())
newmap

###---###
library(leaflet)
d = geodata_avg$density_factor
d = factor(d)
cols <- rainbow(length(levels(d)), alpha=NULL)
geodata_avg$colors <- cols[unclass(d)]
newmap <- leaflet(data=geodata_avg) %>% addTiles() %>%
addCircleMarkers(lng = ~lon, lat = ~lat, weight = 1, radius = ~rank*1.1, color = ~colors,  popup = paste("Site Address: ", geodata_avg$Site.Address, "<br>", "Category: ", geodata_avg$Category, "<br>", "Average Waste: ", geodata_avg$value))
newmap

###---###

map <- get_map(location=c(lon = -103.00069, lat = 55.29957), zoom = 4, source="google",maptype="roadmap")
foo <- ggmap(map)+
  scale_x_continuous(limits = c(-129.5910, -73.73920), expand = c(0,0)) +
  scale_y_continuous(limits = c(43.03795, 56.75598), expand = c(0,0))+
  geom_point(aes(x=lon, y=lat, size=Density, alpha=Density, color=value), data=geodata_avg)+
  scale_color_gradient(low="green",high="red")
foo
