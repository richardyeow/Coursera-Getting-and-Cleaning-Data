fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "Dataset.zip", mode= "wb")
unzip("Dataset")

##Read Features Files
FeaturesTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
FeaturesTest <- read.table("UCI HAR Dataset/test/X_test.txt")

##Read Activity Files
ActivityTrain <- read.table("UCI HAR Dataset/train/Y_train.txt")
ActivityTest <- read.table("UCI HAR Dataset/test/Y_test.txt")

##Read Subject Files
SubjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
SubjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")


##Q1: Merges the training and the test sets to create one data set
Features <- rbind(FeaturesTrain, FeaturesTest)
Activity <- rbind(ActivityTrain, ActivityTest)
Subject <- rbind(SubjectTrain, SubjectTest)

names(Activity) <- c("Activity")
names(Subject) <- c("Subject")

FeaturesName <- read.table("UCI HAR Dataset/features.txt")
names(Features) <- FeaturesName$V2

AllData <- cbind(Features, Subject, Activity)


##Q2: Extracts only the measurements on the mean and standard deviation for each measurement.
Mean_StdDev <- FeaturesName$V2[grep("mean\\(\\)|std\\(\\)", FeaturesName$V2)]
SelectedFeatures <- c(as.character(Mean_StdDev), "Subject", "Activity")
SelectedData <- subset(AllData, select = SelectedFeatures)


##Q3: Uses descriptive activity names to name the activities in the data set 
ActivityLabel <- read.table("UCI HAR Dataset/activity_labels.txt")
head(SelectedData$Activity,30)

SelectedData$Activity <- factor(SelectedData$Activity, levels = ActivityLabel[,1], labels = ActivityLabel[,2])


##Q4: Appropriately labels the data set with descriptive variable names.
names(SelectedData)<-gsub("Acc", "Accelerometer", names(SelectedData))
names(SelectedData)<-gsub("Gyro", "Gyroscope", names(SelectedData))
names(SelectedData)<-gsub("^t", "Time", names(SelectedData))
names(SelectedData)<-gsub("Mag", "Magnitude", names(SelectedData))
names(SelectedData)<-gsub("^f", "Frequency", names(SelectedData))


##Q5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Data2 <- SelectedData %>% 
        group_by(Subject, Activity) %>%
        summarise_each(funs(mean))
write.table(Data2, file = "tidydata.txt", row.name = FALSE)