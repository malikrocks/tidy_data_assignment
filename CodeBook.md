# UCI Human Activity Recognition Tidy Dataset with Mean and Standard Deviation for each Subject and Activty

## The Data

This script works on the data from UC Irvine's Human Activity Recognition Using Smartphones Data Set. The data represent data 
collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones  

Source data can be found at the below link"

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

##The Variables

The data contains the following columns

- Subject - An identifier of the subject who carried out the experiment.
- Activity - The descriptive name of the activity performed.

The rest of the columns are from the original dataset with the following description.

    The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.

    Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).

    Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).

    These signals were used to estimate variables of the feature vector for each pattern:

    The set of variables that were estimated from these signals are: mean(): Mean value std(): Standard deviation

- tBodyAcc-mean()-X
- tBodyAcc-mean()-Y
- tBodyAcc-mean()-Z
- tBodyAcc-std()-X
- tBodyAcc-std()-Y
- tBodyAcc-std()-Z
- tGravityAcc-mean()-X
- tGravityAcc-mean()-Y
- tGravityAcc-mean()-Z
- tGravityAcc-std()-X
- tGravityAcc-std()-Y
- tGravityAcc-std()-Z
- tBodyAccJerk-mean()-X
- tBodyAccJerk-mean()-Y
- tBodyAccJerk-mean()-Z
- tBodyAccJerk-std()-X
- tBodyAccJerk-std()-Y
- tBodyAccJerk-std()-Z
- tBodyGyro-mean()-X
- tBodyGyro-mean()-Y
- tBodyGyro-mean()-Z
- tBodyGyro-std()-X
- tBodyGyro-std()-Y
- tBodyGyro-std()-Z
- tBodyGyroJerk-mean()-X
- tBodyGyroJerk-mean()-Y
- tBodyGyroJerk-mean()-Z
- tBodyGyroJerk-std()-X
- tBodyGyroJerk-std()-Y
- tBodyGyroJerk-std()-Z
- tBodyAccMag-mean()
- tBodyAccMag-std()
- tGravityAccMag-mean()
- tGravityAccMag-std()
- tBodyAccJerkMag-mean()
- tBodyAccJerkMag-std()
- tBodyGyroMag-mean()
- tBodyGyroMag-std()
- tBodyGyroJerkMag-mean()
- tBodyGyroJerkMag-std()
- fBodyAcc-mean()-X
- fBodyAcc-mean()-Y
- fBodyAcc-mean()-Z
- fBodyAcc-std()-X
- fBodyAcc-std()-Y
- fBodyAcc-std()-Z
- fBodyAccJerk-mean()-X
- fBodyAccJerk-mean()-Y
- fBodyAccJerk-mean()-Z
- fBodyAccJerk-std()-X
- fBodyAccJerk-std()-Y
- fBodyAccJerk-std()-Z
- fBodyGyro-mean()-X
- fBodyGyro-mean()-Y
- fBodyGyro-mean()-Z
- fBodyGyro-std()-X
- fBodyGyro-std()-Y
- fBodyGyro-std()-Z
- fBodyAccMag-mean()
- fBodyAccMag-std()
- fBodyBodyAccJerkMag-mean()
- fBodyBodyAccJerkMag-std()
- fBodyBodyGyroMag-mean()
- fBodyBodyGyroMag-std()
- fBodyBodyGyroJerkMag-mean()
- fBodyBodyGyroJerkMag-std()

## The Script

This repository contains a script called run_analysis.R

To run the script, the data files should be in the working directory. 

Two packages are required to run the script:

    dplyr
    reshape2

## Data processing steps

First step is to load the required packages.

    library(reshape2)
    library(dplyr)


Read the data files from the working directory.

    features        <- read.table("features.txt")
    activity_labels <- read.table("activity_labels.txt")
    X_train         <- read.table("train/X_train.txt")
    Y_train         <- read.table("train/y_train.txt")
    train_subject   <- read.table("train/subject_train.txt")
    test_subject    <- read.table("test/subject_test.txt")
    X_test          <- read.table("test/X_test.txt")
    Y_test          <- read.table("test/y_test.txt")

Activity names should be descriptive which can be applied from the activity_labels files
to the Y_ files

    train_activity <- data.frame(Activity = activity_labels$V2[Y_train$V1])
    test_activity  <- data.frame(Activity = activity_labels$V2[Y_test$V1]))

Next step is to label the data set with descriptive variable names.

Activities column is labeled as "Activity" and the data column from the subject_ files is labeled as "Subject".

The data columns from the X_ files are labeled with the descriptions from the features file.

    colnames(train_subject) <- c("Subject")
    colnames(test_subject) <- c("Subject")
    colnames(X_train)       <- features$V2
    colnames(X_test)       <- features$V2

Join the columns for training and test dataset using bind_cols.

    train <- bind_cols(train_subject, train_activity, X_train)
    test  <- bind_cols(test_subject, test_activity, X_test)

Merge the training and the test sets to create one data set using rbind.

    combine_data  <- rbind(train, test)

Next step is to extract the measurements on the mean and standard deviation for each measurement.

Here the script takes the "Subject" and "Activity" columns as well as columns with names containing "mean()" or "std()"

excluding columns with "Mean" in their names which are angle of means but are not means themselves.


    cols <- c(1,2, grep("(mean|std)\\(\\)", colnames(combine_data)))
    tidyData <- combine_data[cols]

The tidy dataset is written to a file.

    write.table(tidyData, file="tidydata.txt", row.name=FALSE) 

Finally, create a second, independent tidy data set with the average of each variable for each activity and each subject.

Data is melted and recast as a set of the means of the columns per subject per activity with reshaper2.

This data is written to its own independent file.

    melt_Data <- melt(tidyData,id = c("Subject","Activity"))
    avg_Data <- dcast(melt_Data, Subject + Activity ~ variable, mean)
    write.table(avg_Data, file="activity_averages.txt", row.name=FALSE) 
