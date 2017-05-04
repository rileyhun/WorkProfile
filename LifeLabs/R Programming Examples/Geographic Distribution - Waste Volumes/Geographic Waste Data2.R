data<-read.csv("Stericycle Waste Data.csv")
library(reshape2)
library(ggplot2)
library(plyr)
library(data.table)
library(ggmap)
names(data)<-c("ID1","ID2", "Site.Address", "Type", "City", "Province", "Category", "Density", "Nov-14", "Dec-14", "Jan-15", "Feb-15", "Mar-15", "Apr-15", "May-15", "Jun-15", "Jul-15", "Aug-15", "Sep-15", "Oct-15", "Nov-15", "Dec-15", "Jan-16")
data<-melt(data, c("ID1","ID2", "Site.Address","Type", "City", "Province", "Category", "Density"))
data<-na.omit(data)
data_grouped<-ddply(data, c("Site.Address", "Type","City", "Province", "Category", "Density", "variable"), summarise, value=sum(value))
names(data_grouped)<-c("Site.Address", "Type", "City", "Province", "Category", "Density", "Month", 'Waste.Mass')
###---###

dummy<-read.csv('locations-coordinates.csv')
geodata<-merge(data_grouped, dummy, by.x="Site.Address", by.y="Site.Address", all.y=TRUE)
View(geodata)

s<-geodata
a = rep(NA, nrow(s))
for (i in 1:nrow(s)) {
  if (s$Waste.Mass[i]>20000){
    a[i] = 10
  } else if (s$Waste.Mass[i]>10000) {
    a[i] = 8
  } else if (s$Waste.Mass[i]>1000) {
    a[i] = 7
  } else if (s$Waste.Mass[i]> 100) {
    a[i] = 5
  } else if (s$Waste.Mass[i]> 10) {
    a[i] = 3
  } else if (s$Waste.Mass[i]> 1) {
    a[i] = 2
  } else {
    a[i] = 1
    i= i+1
  }
  a
}

r<-geodata
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
geodata<-cbind(geodata, rank, density_factor)
d = geodata$density_factor
d = factor(d)
cols <- rainbow(length(levels(d)), alpha=NULL)
geodata$colors <- cols[unclass(d)]

Nov14<-subset(geodata, Month=="Nov-14")
Dec14<-subset(geodata, Month=="Dec-14")
Jan15<-subset(geodata, Month=="Jan-15")
Feb15<-subset(geodata, Month=="Feb-15")
Mar15<-subset(geodata, Month=="Mar-15")
Apr15<-subset(geodata, Month=="Apr-15")
May15<-subset(geodata, Month=="May-15")
Jun15<-subset(geodata, Month=="Jun-15")
Jul15<-subset(geodata, Month=="Jul-15")
Aug15<-subset(geodata, Month=="Aug-15")
Sep15<-subset(geodata, Month=="Sep-15")
Oct15<-subset(geodata, Month=="Oct-15")
Nov15<-subset(geodata, Month=="Nov-15")
Dec15<-subset(geodata, Month=="Dec-15")
Jan15<-subset(geodata, Month=="Jan-15")

###---###
library(leaflet)
newmap <- leaflet() %>% 
  addTiles() %>%
  addCircleMarkers(data = Nov14, lng = ~lon, lat = ~lat, weight = 1, radius = ~rank*1.5, color = ~colors,  popup = paste("Site Address: ", Nov14$Site.Address, "<br>", "Category: ", Nov14$Category, "<br>", "Waste: ", round(Nov14$Waste.Mass,2)), group = "Nov 2014") %>%
  addCircleMarkers(data = Dec14, lng = ~lon, lat = ~lat, weight = 1, radius = ~rank*1.5, color = ~colors,  popup = paste("Site Address: ", Dec14$Site.Address, "<br>", "Category: ", Dec14$Category, "<br>", "Waste: ", round(Dec14$Waste.Mass,2)), group = "Dec 2014") %>%
  addCircleMarkers(data = Jan15, lng = ~lon, lat = ~lat, weight = 1, radius = ~rank*1.5, color = ~colors,  popup = paste("Site Address: ", Jan15$Site.Address, "<br>", "Category: ", Jan15$Category, "<br>", "Waste: ", round(Jan15$Waste.Mass,2)), group = "Jan 2015") %>%
  addCircleMarkers(data = Feb15, lng = ~lon, lat = ~lat, weight = 1, radius = ~rank*1.5, color = ~colors,  popup = paste("Site Address: ", Feb15$Site.Address, "<br>", "Category: ", Feb15$Category, "<br>", "Waste: ", round(Feb15$Waste.Mass,2)), group = "Feb 2015") %>%
  addCircleMarkers(data = Mar15, lng = ~lon, lat = ~lat, weight = 1, radius = ~rank*1.5, color = ~colors,  popup = paste("Site Address: ", Mar15$Site.Address, "<br>", "Category: ", Mar15$Category, "<br>", "Waste: ", round(Mar15$Waste.Mass,2)), group = "Mar 2015") %>%
  addCircleMarkers(data = Apr15, lng = ~lon, lat = ~lat, weight = 1, radius = ~rank*1.5, color = ~colors,  popup = paste("Site Address: ", Apr15$Site.Address, "<br>", "Category: ", Apr15$Category, "<br>", "Waste: ", round(Apr15$Waste.Mass,2)), group = "Apr 2015") %>%
  addCircleMarkers(data = May15, lng = ~lon, lat = ~lat, weight = 1, radius = ~rank*1.5, color = ~colors,  popup = paste("Site Address: ", May15$Site.Address, "<br>", "Category: ", May15$Category, "<br>", "Waste: ", round(May15$Waste.Mass,2)), group = "May 2015") %>%
  addCircleMarkers(data = Jun15, lng = ~lon, lat = ~lat, weight = 1, radius = ~rank*1.5, color = ~colors,  popup = paste("Site Address: ", Jun15$Site.Address, "<br>", "Category: ", Jun15$Category, "<br>", "Waste: ", round(Jun15$Waste.Mass,2)), group = "Jun 2015") %>%
  addCircleMarkers(data = Jul15, lng = ~lon, lat = ~lat, weight = 1, radius = ~rank*1.5, color = ~colors,  popup = paste("Site Address: ", Jul15$Site.Address, "<br>", "Category: ", Jul15$Category, "<br>", "Waste: ", round(Jul15$Waste.Mass,2)), group = "Jul 2015") %>%
  addCircleMarkers(data = Aug15, lng = ~lon, lat = ~lat, weight = 1, radius = ~rank*1.5, color = ~colors,  popup = paste("Site Address: ", Aug15$Site.Address, "<br>", "Category: ", Aug15$Category, "<br>", "Waste: ", round(Aug15$Waste.Mass,2)), group = "Aug 2015") %>%
  addCircleMarkers(data = Sep15, lng = ~lon, lat = ~lat, weight = 1, radius = ~rank*1.5, color = ~colors,  popup = paste("Site Address: ", Sep15$Site.Address, "<br>", "Category: ", Sep15$Category, "<br>", "Waste: ", round(Sep15$Waste.Mass,2)), group = "Sep 2015") %>%
  addCircleMarkers(data = Oct15, lng = ~lon, lat = ~lat, weight = 1, radius = ~rank*1.5, color = ~colors,  popup = paste("Site Address: ", Oct15$Site.Address, "<br>", "Category: ", Oct15$Category, "<br>", "Waste: ", round(Oct15$Waste.Mass,2)), group = "Oct 2015") %>%
  addCircleMarkers(data = Nov15, lng = ~lon, lat = ~lat, weight = 1, radius = ~rank*1.5, color = ~colors,  popup = paste("Site Address: ", Nov15$Site.Address, "<br>", "Category: ", Nov15$Category, "<br>", "Waste: ", round(Nov15$Waste.Mass,2)), group = "Nov 2015") %>%
  addCircleMarkers(data = Dec15, lng = ~lon, lat = ~lat, weight = 1, radius = ~rank*1.5, color = ~colors,  popup = paste("Site Address: ", Dec15$Site.Address, "<br>", "Category: ", Dec15$Category, "<br>", "Waste: ", round(Dec15$Waste.Mass,2)), group = "Dec 2015") %>%
  addCircleMarkers(data = Mar15, lng = ~lon, lat = ~lat, weight = 1, radius = ~rank*1.5, color = ~colors,  popup = paste("Site Address: ", Jan15$Site.Address, "<br>", "Category: ", Jan15$Category, "<br>", "Waste: ", round(Jan15$Waste.Mass,2)), group = "Jan 2016") %>%
  addLayersControl(
  overlayGroups = c("Nov 2014","Dec 2014", "Jan 2015", "Feb 2015", "Mar 2015", "Apr 2015", "May 2015", "Jun 2015", "Jul 2015", "Aug 2015", "Sep 2015", "Oct 2015", "Nov 2015", "Dec 2015", "Jan 2016")
) %>%
  hideGroup("Nov 2014") %>%
  hideGroup("Dec 2014") %>%
  hideGroup("Jan 2015") %>%
  hideGroup("Feb 2015") %>%
  hideGroup("Mar 2015") %>%
  hideGroup("Apr 2015") %>%
  hideGroup("Mar 2015") %>%
  hideGroup("Apr 2015") %>%
  hideGroup("May 2015") %>%
  hideGroup("Jun 2015") %>%
  hideGroup("Jul 2015") %>%
  hideGroup("Aug 2015") %>%
  hideGroup("Sep 2015") %>%
  hideGroup("Oct 2015") %>%
  hideGroup("Nov 2015") %>%
  hideGroup("Dec 2015")
newmap

###---###
