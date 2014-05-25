# You should create one R script called run_analysis.R that does the following. 
# - Merges the training and the test sets to create one data set.
# - Extracts only the measurements on the mean and standard deviation for each measurement. 
# - Uses descriptive activity names to name the activities in the data set
# - Appropriately labels the data set with descriptive activity names. 
# - Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
#
# load training set or test set

# features
featureNames = read.table("UCI HAR Dataset/features.txt", 
                          col.names=c("feature.code", "feature.name")); 
# 561 obs. of  2 variables: feature.code to feature.name mapping
str(featureNames)
View(featureNames)
featureNames$feature.name

# activity labels
activityLabels = read.table("UCI HAR Dataset/activity_labels.txt", 
                          col.names=c("activity.code", "activity")); 

# columns indices for measures of mean or std: 79 measures
meanOrStdMeasureIndices <- grep("mean|std",featureNames$feature.name)
length(meanOrStdMeasureIndices)
featureNames$feature.name[meanOrStdMeasureIndices]

# 7352 observations; for each observation:
# - subject number, from 1 to 30
# - label of the activity, from 1 to 6
# - 561 measures, 1 for each feature listed in features.txt

# subject associated with each observation: subject_train
trainingSubjects = read.table("UCI HAR Dataset/train/subject_train.txt",
                            col.names=c("subject"))
# 7352 obs. of  1 variable
str(trainingSubjects)
levels(factor(trainingSubjects$Subject)) # 1 to 30, except test subjects (see below)

# load labels for training: y_train
trainingActivities = read.table("UCI HAR Dataset/train/y_train.txt",
                          , col.names=c("activity.code")); 
# 7352 obs. of  1 variable
str(trainingActivities)
levels(factor(trainingActivities$Label)) # 1 to 6
# 1 WALKING
# 2 WALKING_UPSTAIRS
# 3 WALKING_DOWNSTAIRS
# 4 SITTING
# 5 STANDING
# 6 LAYING

# training signals
trainingSignals = read.table("UCI HAR Dataset/train/X_train.txt",
                             , col.names=as.character(featureNames$feature.name))
# 7352 obs. of  561 variables: each observation contains a measure for each feature
str(trainingSignals)
View(trainingSignals)
colnames(trainingSignals)[1]

# select columns representing mean or standard deviation
trainingSignalsForMeanOrStd <- trainingSignals[,meanOrStdMeasureIndices]
str(trainingSignalsForMeanOrStd)
# 7352 obs. of  79 variables

paste(colnames(trainingSignals),featureNames$feature.name)

paste(colnames(trainingSignals),featureNames$feature.name)[colnames(trainingSignals) == gsub("[-(,)]",".",featureNames$feature.name)]
paste(colnames(trainingSignals),featureNames$feature.name)[!colnames(trainingSignals) == gsub("[-(,)]",".",featureNames$feature.name)]

paste(colnames(trainingSignals),gsub("[-(,)]",".",featureNames$feature.name))[!colnames(trainingSignals) == gsub("[-(,)]",".",featureNames$feature.name)]

featureNames$feature.name[colnames(trainingSignals) == gsub("[-(,)]",".",featureNames$feature.name)]


# same for test

# subject associated with each observation: subject_test
testSubjects = read.table("UCI HAR Dataset/test/subject_test.txt",
                             col.names=c("subject"))
# 2947 obs. of  1 variable
str(testSubjects)
levels(factor(testSubjects$subject)) # "2"  "4"  "9"  "10" "12" "13" "18" "20" "24"

# load labels for training: y_train
testActivities = read.table("UCI HAR Dataset/test/y_test.txt",
                                , col.names=c("activity.code")); 
# 2947 obs. of  1 variable
str(testActivities)
levels(factor(testActivities$Label)) # 1 to 6
# 1 WALKING
# 2 WALKING_UPSTAIRS
# 3 WALKING_DOWNSTAIRS
# 4 SITTING
# 5 STANDING
# 6 LAYING

# test signals
testSignals = read.table("UCI HAR Dataset/test/X_test.txt",
                             , col.names=as.character(featureNames$feature.name))
# 2947 obs. of  561 variables: each observation contains a measure for each feature
dim(testSignals)
str(testSignals)
View(testSignals)
colnames(testSignals)

testSignalsForMeanOrStd <- testSignals[,meanOrStdMeasureIndices]
str(testSignalsForMeanOrStd)

##########
# training :  7352 rows x 1+1+79 columns
# test     :  2947 rows x 1+1+79 columns
# total     : 10299

phase <- rep("Training",7352)
length(phase)
hActivityRecognitionDataForTraining <- cbind (phase,
                                   trainingSubjects, 
                                   trainingActivities, 
                                   trainingSignalsForMeanOrStd)
View(hActivityRecognitionDataForTraining)
dim(hActivityRecognitionDataForTraining)
# [1] 7352  82

phase <- rep("Test",2947)
length(Phase)
hActivityRecognitionDataForTest <- cbind (phase,
                                   testSubjects, 
                                   testActivities, 
                                   testSignalsForMeanOrStd)
View(hActivityRecognitionDataForTest)
dim(hActivityRecognitionDataForTest)
# [1] 2947  82


hActivityRecognitionData1 <- rbind(hActivityRecognitionDataForTraining,
                                           hActivityRecognitionDataForTest)

str(hActivityRecognitionData1)
dim(hActivityRecognitionData1)
# [1] 10299   82
View(hActivityRecognitionData1)

hActivityRecognitionData2 <- merge(activityLabels, hActivityRecognitionData1, by.x="activity.code", by.y="activity.code")
str(hActivityRecognitionData2)
View(hActivityRecognitionData2)

# drop activity code column
hActivityRecognitionData3 <- hActivityRecognitionData2[,!(names(hActivityRecognitionData2) %in% c("activity.code"))]
str(hActivityRecognitionData3)
View(hActivityRecognitionData3)
View(hActivityRecognitionData3[9456,])

thecolnames <- colnames(hActivityRecognitionData3)

thenewcolnames <- gsub("bodyBody","body",
gsub("\\.\\.$","",
gsub("\\.\\.\\.",".",
gsub("Acc",".accelerometer",
gsub("Gyro",".gyroscope",
gsub("Jerk",".jerk",
gsub("Mag",".magnitude",
gsub("Freq",".frequency",
gsub("tB","time.b",
gsub("tG","time.g",
gsub("fB","frequency.b",
gsub("fG","frequency.g",
     thecolnames))))))))))))

colnames(hActivityRecognitionData3) <- thenewcolnames

View(hActivityRecognitionData3)

write.csv(hActivityRecognitionData3, file = "hActivityRecognitionData.txt", row.names=FALSE)

theResult = read.table("hActivityRecognitionData.txt", header=TRUE, sep=","); 
theResult = read.csv("hActivityRecognitionData.txt"); 
View(theResult)

# hhh


trainingIntertialSignalsbody_acc_x <- 
    read.table("UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt")
str(trainingIntertialSignalsbody_acc_x)

trainingIntertialSignalsbody_acc_y <- 
    read.table("UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt")
str(trainingIntertialSignalsbody_acc_y)

View(trainingIntertialSignalsbody_acc_y)
trainingIntertialSignalsbody_acc_y[1,]

trainingIntertialSignalsbody_gyro_z_train <- 
    read.table("UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt")
str(trainingIntertialSignalsbody_gyro_z_train)


               header = FALSE, sep = " ", fill=TRUE); 
# 7351 rows
str(trainingIntertialSignalsbody_acc_x)




length(thenewcolnames)

thenewcolnames[4:length(thenewcolnames)]

# install.packages("reshape2")
library(reshape2)
meltData <- melt(hActivityRecognitionData3, id=c("activity.label", "subject"), 
                 measure.vars=thenewcolnames[4:length(thenewcolnames)])
View(meltData)

castData <- dcast(meltData, subject + activity.label ~ variable, mean)
View(castData)

write.csv(castData, file = "newAverageRecognitionData.csv", row.names=FALSE)

theResult = read.table("newAverageRecognitionData.txt", header=TRUE, sep=","); 
theResult = read.csv("newAverageRecognitionData.txt"); 
View(theResult)
