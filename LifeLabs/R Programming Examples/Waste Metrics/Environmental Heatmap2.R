data<-read.csv("Environmental_Heatmap.csv")
data
library(ggplot2)
library(reshape2)
data<-melt(data)
names(data)<-c("Environmental.Aspect", "City", "Value")
data
p<-ggplot(data, aes(City, Environmental.Aspect))+
  geom_tile(aes(fill=(Value)), colour="white")+
  scale_fill_gradient2(low="white", mid="pink", high="red", name="Legend", labels=c("No program or reporting required", "No program in place", "Improvements in Progress", "Awaiting Approval from Ministy", "Meets or Exceeds Requirements"))
base_size<-9
p+theme_grey(base_size = base_size) + labs(x="", y="")+
  scale_y_discrete(expand=c(0,0))+
  theme(legend.position="right", legend.text=element_text(size=9),axis.ticks=element_blank(), axis.text.y=element_text(size=base_size*1.4),axis.text.x=element_text(size=base_size*1.4, angle=330, hjust=0, colour="grey50"), panel.border=element_rect(colour="black", fill=NA, size=1))
