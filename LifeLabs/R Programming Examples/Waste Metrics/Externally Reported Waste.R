library(ggplot2)
library(reshape2)
library(plyr)
Location = c('Sudbury','Sudbury', 'Ottawa', 'Ottawa', 'Burnaby', 'Burnaby')
Classification = c('Unplanned Discharge', 'Not an Unplanned Discharge', 
                   'Unplanned Discharge', 'Not an Unplanned Discharge', 'Unplanned Discharge', 'Not an Unplanned Discharge')
Oct = c(1,0,0,0,0,0)
Nov = c(0,0,0,2,0,0)
Dec = c(1,5,0,1,0,0)
Jan = c(0,3,0,0,0,0)
Feb = c(0,0,0,0,0,1)
rdata<-data.frame(Location, Classification,Oct,Nov,Dec,Jan,Feb)
rdata<-melt(rdata, id.vars=c("Location", "Classification"))
names(rdata)<-c("Location","Classification", "Month", "Number.Incidents")
plotrdata<-ggplot(rdata, aes(y=Number.Incidents, x=Month, color=Location))+
  geom_point(size=5)+
  geom_smooth(aes(group=1), method="lm", formula = y~log(x), se=FALSE, color="red")+
  facet_wrap(~Classification)+
  theme(text=element_text(size=18))
plotrdata

View(rdata)
