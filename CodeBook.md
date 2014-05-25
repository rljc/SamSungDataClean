# Tidy Data Set description

This code book describes the variables, the data, and transformations  performed to clean up the data originally collected.

## Data Dictionary

Each column of the tidy data set contained in [newAverageRecognitionData.csv](https://github.com/rljc/SamSungDataClean/blob/master/newAverageRecognitionData.csv) is described below.

- **activity**: activity performed by the subject. The 6 admissible values are:
WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING

- **subject**: identity of the subject performing the activity. The 30 admissible values are integers ranging from 1 to 30.

- 79 feature measurement columns: each column is calculated as average of a Samsung smartphone data feature measurement, for each activity and each subject. Example of column name is **time.gravity.accelerometer.std.X**

These 79 columns are split into the following categories:

- Triaxial acceleration from the accelerometer (total acceleration).
- Triaxial estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 

Each of these 79 columns contains a measure for each feature defined and retained during the transformations applied. During these transformations only 

The elements used to name the columns need to be interpreted in this way:
- *time*: signals captured at a constant rate of 50 Hz, then filtered.
- *frequency*: result of a Fast Fourier Transform (FFT) applied to some of the signals.
- *body*: acceleration signals separated into body acceleration by filtering.
- *gravity*: acceleration signals separated into gravity acceleration by filtering.
- *accelerometer*: originating from the smartphone accelerometer 3-axial raw signals (X,Y,Z).
- *gyroscope*: originating from the smartphone gyroscope 3-axial raw signals (X,Y,Z).
- *jerk*: result of derivation of body linear acceleration and angular velocity.
- *magnitude*: Euclidean norm applied to the three-dimensional signals.
- *mean*: Mean value estimated from raw signals.
- *std*: Standard deviation estimated from raw signals.
- *XYZ*: denote 3-axial signals in the X, Y and Z directions.

## Transformations

The following transformations were applied to the data set available from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip, and implemented in *run_analysis.R*.

Note: it is assumed that getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip is downloaded and unzipped into the directory which is set as working directory in R or Rstudio, so that extracted files are available from a subdirectory named 'UCI HAR Dataset'.

### Merge of the original training and test data sets

Load files for Training and Test as data frames and combine by rows.

- Training: load 7352 observations from files "train/subject_train.txt"", "train/y_train.txt", "train/X_train.txt", respectively into columns "subject", "activity.code", and the 79 columns 
containing a measure for each feature that is a mean or standard deviation (out of initial 561).
- Test: load 2947 observations from files "test/subject_test.txt"", "test/y_test.txt", "test/X_test.txt", respectively into columns "subject", "activity.code", and the 79 columns 
containing a measure for each feature that is a mean or standard deviation (out of initial 561).


At this point the 2 datasets are available as data frames:
- training :  7352 rows x 1+1+79 columns
- test     :  2947 rows x 1+1+79 columns

They are combined by rows, after adding to each a column codifying the phase (Traing or Test).

### Extract only the measurements on the mean and standard deviation for each measurement. 

The initial number of feature measurement columns is 561, which is cut down to 79 by filtering in only the columns of which name containes 'mean' or 'std' string.

Note: we apply this prior to merging Training and Test data sets, in order to optimize performance.

### Use descriptive activity names to name the activities in the data set

The initial activity information is captured as codes ranging from 1 to 6, which are tranformed into their textual equivalent WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING, by merging with data frame loaded from activity definitions stored in activity_labels.txt. Activity code columns is dropped after this merge.

Feature measurement columns use short names that may be ambigous, so a few replacement are applied to the column names to clarify and have more descriptive names.
colnames(hActivityRecognitionData3) <- thenewcolnames

### Save combined data set

Combined Training+Test dataset is saved as "humanActivityRecognitionData.txt" file.

### Creates a second, independent tidy data set with the average of each variable for each activity and each subject

1. Melt the data set, taking "activity.label" and "subject" as id variables, and the 79 feature measurement columns as  measured variables.
2. Cast this data set with formula 'subject + activity.label ~ variable', so that subject varies slowest. Use mean as aggregate function.

New data set is saved as "newAverageRecognitionData.txt" file

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






2. Extractionf of the measurements on the mean and standard deviation for each measurement.
3. Usage of descriptive labels and names for the activities in the data set
4. Creation a second, independent tidy data set with the average of each variable for each activity and each subject (the txt file above).
