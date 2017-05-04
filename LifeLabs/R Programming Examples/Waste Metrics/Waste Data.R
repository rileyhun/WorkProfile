library(grid)
# pos - where to add new labels
# newpage, vp - see ?print.ggplot
facetAdjust <- function(x, pos = c("up", "down"), 
                        newpage = is.null(vp), vp = NULL)
{
  # part of print.ggplot
  ggplot2:::set_last_plot(x)
  if(newpage)
    grid.newpage()
  pos <- match.arg(pos)
  p <- ggplot_build(x)
  gtable <- ggplot_gtable(p)
  # finding dimensions
  dims <- apply(p$panel$layout[2:3], 2, max)
  nrow <- dims[1]
  ncol <- dims[2]
  # number of panels in the plot
  panels <- sum(grepl("panel", names(gtable$grobs)))
  space <- ncol * nrow
  # missing panels
  n <- space - panels
  # checking whether modifications are needed
  if(panels != space){
    # indices of panels to fix
    idx <- (space - ncol - n + 1):(space - ncol)
    # copying x-axis of the last existing panel to the chosen panels 
    # in the row above
    gtable$grobs[paste0("axis_b",idx)] <- list(gtable$grobs[[paste0("axis_b",panels)]])
    if(pos == "down"){
      # if pos == down then shifting labels down to the same level as 
      # the x-axis of last panel
      rows <- grep(paste0("axis_b\\-[", idx[1], "-", idx[n], "]"), 
                   gtable$layout$name)
      lastAxis <- grep(paste0("axis_b\\-", panels), gtable$layout$name)
      gtable$layout[rows, c("t","b")] <- gtable$layout[lastAxis, c("t")]
    }
  }
  # again part of print.ggplot, plotting adjusted version
  if(is.null(vp)){
    grid.draw(gtable)
  }
  else{
    if (is.character(vp)) 
      seekViewport(vp)
    else pushViewport(vp)
    grid.draw(gtable)
    upViewport()
  }
  invisible(p)
}




data<-read.csv("Stericycle Waste Data.csv")
library(reshape2)
library(ggplot2)
library(plyr)
library(data.table)
names(data)<-c("ID1","ID2", "Site.Address", "Type", "City", "Province", "Category", "Nov-14", "Dec-14", "Jan-15", "Feb-15", "Mar-15", "Apr-15", "May-15", "Jun-15", "Jul-15", "Aug-15", "Sep-15", "Oct-15", "Nov-15", "Dec-15", "Jan-16")
data<-melt(data, c("ID1","ID2", "Site.Address","Type", "City", "Province", "Category"))
View(data)
data<-na.omit(data)

data_grouped<-ddply(data, c("Site.Address", "Type","City", "Province", "Category", "variable"), summarise, value=sum(value))
data_snapshot<-subset(data_grouped, value>1000)
View(data_snapshot)

p<-ggplot(data_snapshot, aes(variable, value, group=City)) + 
  geom_point(size=2)+
  stat_smooth(method="lm", formula = y ~splines::bs(x,3), colour="darkred")+
  facet_wrap(~City, ncol=2, scales="free_y")+
  theme(axis.text.y=element_text(size=11.5), axis.title=element_text(size=12, face="bold"),axis.text.x=element_text(size=10, angle=330, vjust=-0.01),panel.border=element_rect(colour="black", fill=NA, size=1))+
  labs(x = "Month", y = "Weight (L)")
facetAdjust(p)

