## Tidy Data Set and Tranformations description

In this directory you will find:
- [newAverageRecognitionData.csv](https://github.com/rljc/SamSungDataClean/blob/master/newAverageRecognitionData.csv): content of a tidy data set, containing data collected and cleaned from original soures listed below, then transformed as depicted below.
- [CodeBook.md](https://github.com/rljc/SamSungDataClean/blob/master/CodeBook.md): a code book that describes the variables, the data, and transformations  performed to clean up the data originally collected.
- [run_analysis.R](https://github.com/rljc/SamSungDataClean/blob/master/run_analysis.R): R script performing the following:

1. Merge of the original training and test data sets.
2. Extraction of the measurements on the mean and standard deviation for each measurement.
3. Usage of descriptive labels and names for the activities in the data set
4. Creation a second, independent tidy data set with the average of each variable for each activity and each subject (the csv file above).

## Original sources

The data originally collected support Human Activity Recognition Using Smartphones.
For more information on the original data set see http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones or contact activityrecognition@smartlab.ws.

The data used for this course are available from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.
