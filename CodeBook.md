## UCI Human Activity Recognition Tidy Dataset with Mean and Standard Deviation for each Subject and Activty

#The Data

This script works on the data from UC Irvine's Human Activity Recognition Using Smartphones Data Set. The data represent data 
collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones  

Source data can be found at the below link"

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#The Script

This repository contains a script called run_analysis.R

To run the script, the data files should be in the working directory. 

Two packages are required to run the script:

    dplyr
    reshape2

#Data processing steps

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

Appropriately label the data set with descriptive variable names.

In the step above the column for activities was labeled as "Activity".

The data column from the subject_ files is labeled as "Subject".

The data columns from the X_ files are labeled with the descriptions from the features file.

colnames(subject_train) <- c("Subject")
colnames(subject_test) <- c("Subject")
colnames(X_train)       <- features$V2
colnames(X_test)       <- features$V2

Join the columns from each set.

train <- bind_cols(subject_train, activity_train, X_train)
test  <- bind_cols(subject_test, activity_test, X_test)

Merge the training and the test sets to create one data set.

The sets are combined with rbind.

data  <- rbind(train, test)

Extract only the measurements on the mean and standard deviation for each measurement.

Here the script takes the "Subject" and "Activity" columns as well as columns with names containing "mean()" or "std()".

The original data has some other columns with "Mean" in their names which are angle of means but are not means themselves. These columns are not included in our final data.

This step also writes the tidy data to a file.

cols <- c(1,2, grep("(mean|std)\\(\\)", colnames(data)))
tidyData <- data[cols]
write.table(tidyData, file="tidydata.txt", row.name=FALSE) 

Create a second, independent tidy data set with the average of each variable for each activity and each subject.

Data is melted and recast as a set of the means of the columns per subject per activity with reshaper2.

This data is written to its own independent file.

meltData <- melt(tidyData,id = c("Subject","Activity"))
avgData <- dcast(meltData, Subject + Activity ~ variable, mean)
write.table(avgData, file="averages.txt", row.name=FALSE) 
