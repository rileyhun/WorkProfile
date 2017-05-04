#Import Training Data and set up as a data frame
data<-read.csv("Training Report.csv")

#Concatenate First Name and Last Names of Employees
data$EmployeeName<-paste(data$LastName, data$FirstName, sep=",")
data<-subset(data,select=c("ManagerName", "EmployeeName","Employee.ID", "Title", "Score"))

#Filter out Scores less than 80, except for Hazard & Incident Reporting and Hazard Identification
data<-subset(data,data$Score>=80)

# Take the Maximum score of Each Employee per module
data<-aggregate(Score ~ ManagerName + EmployeeName + Employee.ID + Title, data = data, FUN = max)

#Create Pivot Table
library("reshape2")
frequency<-c("Frequency")
data[,frequency]<-"1"
data<-recast(data,data$ManagerName+data$EmployeeName+data$Employee.ID~data$Title, measure.var=c("Frequency"))
data <- sapply(data, as.character)
data[is.na(data)] <- ""

#Re-order Columns as indicated in Training Matrix
colnames(data)<-c("Manager Name", "Employee Name", "Employee ID", "Biohazardous Waste", "Chemical Waste", "Waste Manifests")

#Export Back to Excel
write.csv(data,"TrainingData.csv", row.names = FALSE)


# sum(na.omit(data$New.Hire == 1))
