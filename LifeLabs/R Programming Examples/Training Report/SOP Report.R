library(date)
library(reshape2)
library(plyr)

# read in raw data
data<-read.csv("SOP Batch.csv")

# concatenate strings: Employee First Name and Employee Last Name
data$EmployeeName<-paste(data$LastName, data$FirstName, sep=", ")

# clean up Batch Number string
data$BatchNumber<-gsub("[^0-9]", "", data$Title)
data$BatchNumber<-gsub("^$", "New Hire", data$BatchNumber)

# Reduce columns
data<-subset(data, select=c("ManagerName", "EmployeeName", 
                            "Employee.ID", "BatchNumber", "FirstLaunch", "Score", "Location"))

# clean up launch date
data$FirstLaunch<-gsub( " .*$","",data$FirstLaunch)

# organize in appropriate order and then remove duplicate entries
data<-data[order(data$ManagerName, data$EmployeeName, data$BatchNumber, data$Score),]
data<-data[!duplicated(data[c("ManagerName", "EmployeeName", "Employee.ID", "BatchNumber")]),]

# create pivot table
data<-recast(data,data$ManagerName+data$EmployeeName+data$Employee.ID+data$Location~data$BatchNumber, 
             measure.var=c("Score"))

# reorganize columns and relabel columns
data<-subset(data, select = c("data$ManagerName", "data$EmployeeName", "data$Employee.ID", "data$Location", 
                              "New Hire", "1", "2"))
colnames(data)<-c("ManagerName", "Employee Name", "Employee ID", "Location", "New Hire", "Batch 1", "Batch 2")

# subsitute values
data[data==100]<-1
data[data==0]<-""
data[is.na(data)] <- ""

# Make all Batch 1 entries a '1' if their New Hire is a '1'
data<-transform(data, `New Hire` = ifelse(`Batch 1` == 1, 1, `New Hire`))


# read in hiring dates of LL employees
hiring_data <- read.csv("hiring_data.csv")

# filter hiring data for only LL employees
hiring_data <- hiring_data[hiring_data$Affiliation=='LifeLabs',]
# for these LL employees on the list, make the New Hire values a '1'
data[data$Employee.ID %in% hiring_data$Employee.Number,]$New.Hire <- 1

# export to spreadsheet
write.csv(data,"SOPData.csv", row.names = FALSE)

