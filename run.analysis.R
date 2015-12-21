# Load the libraries you need
library(reshape2)
library(plyr)
library(dplyr)

# Download the file and unzip it
if(!file.exists("./data")) {
        dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/getdata.zip", method = "curl")
unzip(zipfile = "./data/getdata.zip", exdir = "./data")
setwd("./data")

# Read data from the files
activityTest <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
activityTrain <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
featuresTest <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
featuresTrain <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)

# Merges the training and the test sets to create one data set
activityTot <- bind_rows(activityTest, activityTrain)
subjectTot <- bind_rows(subjectTest, subjectTrain)
featuresTot <- bind_rows(featuresTest, featuresTrain)

# Rename the variables and merge in one data frame
activityTot <- rename(activityTot, activity = V1)
subjectTot <- rename(subjectTot, subject = V1)

featuresNames <- read.table("UCI HAR Dataset/features.txt", header = FALSE)
names(featuresTot) <- featuresNames$V2

dataPart <- bind_cols(activityTot, subjectTot)
dataTot <- bind_cols(featuresTot, dataPart)

# Extracts only the measurements on the mean and sTd for each measurement
subFeaturesNames <- featuresNames$V2[grep("mean\\(\\)|std\\(\\)", featuresNames$V2)]
extractedNames <- c(as.character(subFeaturesNames), "subject", "activity")
dataTot <- subset(dataTot, select = extractedNames)

# Uses descriptive activity names to name the activities in data set
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)
dataTot$activity <- factor(dataTot$activity, levels = activityLabels[,1], labels = activityLabels[,2])

# Appropriately labels the data set with descriptive variable names
names(dataTot) <- gsub("^t", "time", names(dataTot))
names(dataTot) <- gsub("^f", "frequency", names(dataTot))
names(dataTot) <- gsub("Acc", "Accelerometer", names(dataTot))
names(dataTot) <- gsub("Gyro", "Gyroscope", names(dataTot))
names(dataTot) <- gsub("Mag", "Magnitude", names(dataTot))
names(dataTot) <- gsub("BodyBody", "Body", names(dataTot))

# Creates a second,independent tidy data set and with the average of
# each variable for each actvity and each subject
tidyData <- aggregate(. ~subject + activity, dataTot, mean)
tidyData <- tidyData[order(tidyData$subject, tidyData$activity), ]
write.table(tidyData, file = "tidydata.txt", row.names = FALSE)