# This script does the following. 
# - Merges the training and the test sets to create one data set.
# - Extracts only the measurements on the mean and standard deviation for each measurement. 
# - Uses descriptive activity names to name the activities in the data set
# - Appropriately labels the data set with descriptive activity names. 
# - Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
#

# ======= Preparation steps =======

# Load features names: 561
# 561 obs. of  2 variables: feature.code to feature.name mapping
featureNames = read.table("UCI HAR Dataset/features.txt", 
                          col.names=c("feature.code", "feature.name")); 

# Columns indices for measures of mean or std: 79 
meanOrStdMeasureIndices <- grep("mean|std",featureNames$feature.name)
length(meanOrStdMeasureIndices)
featureNames$feature.name[meanOrStdMeasureIndices]

# Load activity labels
# 1 WALKING
# 2 WALKING_UPSTAIRS
# 3 WALKING_DOWNSTAIRS
# 4 SITTING
# 5 STANDING
# 6 LAYING
activityLabels = read.table("UCI HAR Dataset/activity_labels.txt", 
                          col.names=c("activity.code", "activity")); 

# ======= Load TRAINING dataset =======

# 7352 observations; for each observation:
# - subject number, from 1 to 30
# - label of the activity, from 1 to 6
# - 561 measures, 1 for each feature listed in features.txt

# load subject associated with each observation
# 7352 obs. of  1 variable
trainingSubjects = read.table("UCI HAR Dataset/train/subject_train.txt",
                            col.names=c("subject"))

# load activity labels for training: y_train
# 7352 obs. of  1 variable
trainingActivities = read.table("UCI HAR Dataset/train/y_train.txt",
                          , col.names=c("activity.code")); 

# load training signals
# 7352 obs. of  561 variables: each observation contains a measure for each feature
trainingSignals = read.table("UCI HAR Dataset/train/X_train.txt",
                             , col.names=as.character(featureNames$feature.name))

# Select columns representing mean or standard deviation
# 7352 obs. of  79 variables
trainingSignalsForMeanOrStd <- trainingSignals[,meanOrStdMeasureIndices]

# combine Training data frames by columns
hActivityRecognitionDataForTraining <- cbind (trainingSubjects, 
                                              trainingActivities, 
                                              trainingSignalsForMeanOrStd)

# ======= Load TEST dataset =======

# load subject associated with each observation
# 2947 obs. of  1 variable
testSubjects = read.table("UCI HAR Dataset/test/subject_test.txt",
                             col.names=c("subject"))

# load labels for training: y_train
# 2947 obs. of  1 variable
testActivities = read.table("UCI HAR Dataset/test/y_test.txt",
                                , col.names=c("activity.code")); 

# load test signals
# 2947 obs. of  561 variables: each observation contains a measure for each feature
testSignals = read.table("UCI HAR Dataset/test/X_test.txt",
                             , col.names=as.character(featureNames$feature.name))

# Select columns representing mean or standard deviation
# 7352 obs. of  79 variables
testSignalsForMeanOrStd <- testSignals[,meanOrStdMeasureIndices]

# combine Test data frames by columns
hActivityRecognitionDataForTest <- cbind (testSubjects, 
                                          testActivities, 
                                          testSignalsForMeanOrStd)

# ======= Merge TRAINING and TEST dataset =======

# training :  7352 rows x 1+1+79 columns
# test     :  2947 rows x 1+1+79 columns
# total     : 10299

# merge by rows
hActivityRecognitionData1 <- rbind(hActivityRecognitionDataForTraining,
                                           hActivityRecognitionDataForTest)
# ======= Use descriptive names =======

# Merge on activity code with activity labels data frame, then drop the code column

hActivityRecognitionData2 <- merge(activityLabels, hActivityRecognitionData1, 
                                   by.x="activity.code", by.y="activity.code")

# drop activity code column
hActivityRecognitionData3 <- hActivityRecognitionData2[,
    !(names(hActivityRecognitionData2) %in% c("activity.code"))]

# change feature measurement columns names to remove ambiguity
# this relies on subsitutions to expand e.g. 'Acc' as 'accelerometer'
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

# ======= Save combined dataset =======

write.csv(hActivityRecognitionData3, 
          file = "hActivityRecognitionData.txt", row.names=FALSE)

# ======= Create and Save new tidy dataset =======
# This dataset contains as columns the average of 
# each variable for each activity and each subject

# install.packages("reshape2") # only if needed

library(reshape2)

# Melt the data set, taking “activity” and “subject” as id variables, 
# and the 79 feature measurement columns as measured variables.
# Note: need to skip the first 2 columns "activity" and "subject"

# 813621 obs. of  4 variables:
# $ activity: Factor w/ 6 levels "LAYING","SITTING",..: 4 4 4 4 4 4 4 4 4 4 ...
# $ subject : int  28 28 28 28 28 28 28 28 28 28 ...
# $ variable: Factor w/ 79 levels "time.body.accelerometer.mean.X",..: 1 1 1 1 1 1 1 1 1 1 ...
# $ value   : num  0.308 0.168 0.343 0.31 0.17 ...
meltData <- melt(hActivityRecognitionData3, id=c("activity", "subject"), 
                 measure.vars=thenewcolnames[3:length(thenewcolnames)])


# Cast this data set with formula 'subject + activity.label ~ variable', 
# so that subject varies slowest. Use mean as aggregate function.

# 180 obs. of  81 variables: subject, activity, 79 feature measurement average
castData <- dcast(meltData, subject + activity ~ variable, mean)
# subject    activity	time.body.accelerometer.mean.X	time.body.accelerometer.mean.Y	etc
# 1	        LAYING	    0.2215982	                    -0.040513953	                etc
# 1	        SITTING	    0.2612376	                    -0.001308288                    etc

# Save the new data set
write.csv(castData, file = "newAverageRecognitionData.csv", row.names=FALSE)

# Additional instructions to test teh result can be loaded:
#theResult = read.csv("newAverageRecognitionData.csv"); 
#View(theResult)

# Appendix: Inertial Signals (not in scope)

# 7352 obs. of  128 variables:
# trainingIntertialSignalsbody_acc_x <- 
#    read.table("UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt")
#str(trainingIntertialSignalsbody_acc_x)
#trainingIntertialSignalsbody_acc_y <- 
#    read.table("UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt")
#str(trainingIntertialSignalsbody_acc_y)
#trainingIntertialSignalsbody_gyro_z_train <- 
#    read.table("UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt")
#str(trainingIntertialSignalsbody_gyro_z_train)

# 2947 obs. of  128 variables
#testIntertialSignalsbody_acc_x <- 
#    read.table("UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt")
#str(testIntertialSignalsbody_acc_x)
