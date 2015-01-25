url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"


if(!file.exists("data")) dir.create("data")
#download.file(url, destfile = "data/data.zip")
apply_labels = function(vec){
  
  factor(vec, levels = activity_labels$V1, labels = levels(activity_labels$V2))
}
  

makeFilePath = function(s,fileName){
  
  paste("data/UCI HAR Dataset/",s,"/",fileName,"_",s,".txt",sep="")
}

#files = unzip("data/data.zip",exdir="data")
makeDataset = function(s){
  
  subject <- read.table(makeFilePath(s,"subject"), quote="\"", col.names = "Subject")
  Y <- read.table(makeFilePath(s,"Y"), quote="\"", col.names = "Activity")
  X <- read.table(makeFilePath(s,"X"), quote="\"", colClasses=importClasses)
  names(X) = names(cols)
  cbind(subject,Y,X)
}
library(dplyr)
features <- read.table("data/UCI HAR Dataset/features.txt", quote="\"")
featuresFiltered = features[grep("mean|std",features$V2),]
cols = featuresFiltered$V1
names(cols) = featuresFiltered$V2
importClasses = rep("NULL",561)
importClasses[cols] = "double"      
activity_labels <- read.table("data/UCI HAR Dataset/activity_labels.txt", quote="\"")
levels(activity_labels$V2) = activity_labels$V1
testData = makeDataset("test")
trainData = makeDataset("train")
combinedData = rbind(testData,trainData)
combinedData$Activity= apply_labels(combinedData$Activity)
meansTable = summarise_each(group_by(combinedData,Subject,Activity),funs(mean))
write.table(meansTable,file = "data/meansTable.txt", row.names = F)