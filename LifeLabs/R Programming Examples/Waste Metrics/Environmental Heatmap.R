data<-read.csv(file.choose())
data
library(ggplot2)
library(reshape2)
data<-melt(data)
names(data)<-c("Environmental.Category", "Environmental.Aspect", "City", "Value")
colors=c("lightgray", "red", "yellow", "orange", "green")
data
p<-ggplot(data, aes(City, Environmental.Aspect))+
  geom_tile(aes(fill=factor(Value)), colour="black")+
  scale_fill_manual(values=colors)
p
base_size<-9
p+theme_grey(base_size = base_size) + labs(x="", y="")+
  scale_y_discrete(expand=c(0,0))+
  theme(legend.position="bottom", axis.ticks=element_blank(), axis.text.y=element_text(size=base_size*1.4),axis.text.x=element_text(size=base_size*1.4, angle=330, hjust=0, colour="grey50"))
