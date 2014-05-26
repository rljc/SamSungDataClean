# Tidy Data Set description

This code book describes the variables, the data, and transformations  performed to clean up the data originally collected.

## Data Dictionary

Each column of the tidy data set contained in [newAverageRecognitionData.csv](https://github.com/rljc/SamSungDataClean/blob/master/newAverageRecognitionData.csv) is described below.

- **activity**: activity performed by the subject. The 6 admissible values are:
WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING

- **subject**: identity of the subject performing the activity. The 30 admissible values are integers ranging from 1 to 30.

- 79 feature measurement columns: each column is calculated as the **average** of a Samsung smartphone data feature measurement, for each activity and each subject. Example of column name is **time.gravity.accelerometer.std.X**

These 79 columns are split into the following categories:

- Triaxial acceleration from the accelerometer (total acceleration).
- Triaxial estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 

Each of these 79 columns names designates a measure for each feature defined and retained during the transformations applied: only mean and standard deviation information has been retained.

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

The following transformations were applied to the data set available from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip, and implemented in the R script [run_analysis.R](https://github.com/rljc/SamSungDataClean/blob/master/run_analysis.R).

Note: to run this R script it is assumed that getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip is downloaded and unzipped into the directory which is set as working directory in R or Rstudio, so that extracted files are available from a subdirectory named 'UCI HAR Dataset'.

### Merge of the original training and test data sets

Load files for Training and Test as data frames and combine by rows.

- Training: load 7352 observations from files "train/subject_train.txt"", "train/y_train.txt", "train/X_train.txt", respectively into columns "subject", "activity.code", and the 79 columns 
containing a measure for each feature that is a mean or standard deviation (out of initial 561).
- Test: load 2947 observations from files "test/subject_test.txt"", "test/y_test.txt", "test/X_test.txt", respectively into columns "subject", "activity.code", and the 79 columns 
containing a measure for each feature that is a mean or standard deviation (out of initial 561).


At this point the 2 datasets are available as data frames:
- training :  7352 rows x 1+1+79 columns
- test     :  2947 rows x 1+1+79 columns

Merge is performed by combination of rows, as each data set describes different observations on the same variables.

### Extraction of  measurements on the mean and standard deviation for each measurement. 

The initial number of feature measurement columns is 561, which is cut down to 79 by filtering in only the columns of which name contains 'mean' or 'std' string, as reauired.

Note: we apply this prior to merging Training and Test data sets, in order to optimize performance.

### Usage of descriptive names in the data set

The initial activity information is captured as activity.code ranging from 1 to 6, which are tranformed into their textual equivalent WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING, by merging with the data frame loaded from activity definitions stored in activity_labels.txt. activity.code column is dropped after this merge.

Feature measurement columns use short names that may be ambigous, so a few replacement are applied to the column names to clarify and have more descriptive names, e.g. replacing 'Acc' by 'accelerometer'.

### Save combined data set

The combined Training+Test dataset is saved as "humanActivityRecognitionData.txt" file.

### Creation of an independent tidy data set with the average of each variable for each activity and each subject

The following 2 operations are performed.

1. Melt the data set, taking "activity" and "subject" as id variables, and the 79 feature measurement columns as  measured variables.
2. Cast this data set with formula 'subject + label ~ variable', so that subject varies slowest. Use mean as aggregate function.

New data set is saved as [newAverageRecognitionData.csv](https://github.com/rljc/SamSungDataClean/blob/master/newAverageRecognitionData.csv) file

## Note (out of scope)

The inertial signals measures contained in files within test/Inertial Signals and training/Inertial Signals sub directories are not included in the transformation. These files have dimensions of 7352 obs. of 128 variables for training, and 2947 obs. of  128 variables for test. This information captures the 128 readings by window corresponding to the sampling in fixed-width sliding windows of 2.56 sec and 50% overlap. Including them in the data set would create duplicate information and violate the "one observation per row" principle of tidy data, as this information was already processed and included in the 561 measurements.
