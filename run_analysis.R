# Load required packages:  reshape2, dplyr
library(reshape2)
library(dplyr)

# Read files. Data must be present in working directory.
features        <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")

#Read Training dataset
X_train         <- read.table("train/X_train.txt")
Y_train         <- read.table("train/y_train.txt")
train_subject   <- read.table("train/subject_train.txt")

#Read Test dataset
test_subject    <- read.table("test/subject_test.txt")
X_test          <- read.table("test/X_test.txt")
Y_test          <- read.table("test/y_test.txt")



# Assign descriptive activity names to the activities in the data set
train_activity <- data.frame(Activity = activity_labels$V2[Y_train$V1])
test_activity  <- data.frame(Activity = activity_labels$V2[Y_test$V1])

# Appropriately labels the data set with descriptive variable names. 
colnames(train_subject) <- c("Subject")
colnames(test_subject) <- c("Subject")
colnames(X_train)       <- features$V2
colnames(X_test)       <- features$V2

train <- bind_cols(train_subject, train_activity, X_train)
test  <- bind_cols(test_subject, test_activity, X_test)

# Merge the training and the test sets to create one data set.
combine_data  <- rbind(train, test)

# Extract only the measurements on the mean and standard deviation for each measurement. 
# - get columns with names containing "mean()" or "std()"
cols <- c(1,2, grep("(mean|std)\\(\\)", colnames(combine_data)))
tidyData <- combine_data[cols]
write.table(tidyData, file="tidydata.txt", row.name=FALSE) 

# Create a second, independent tidy data set with the average of each variable for each activity and each subject.
melt_Data <- melt(tidyData,id = c("Subject","Activity"))
avg_Data <- dcast(melt_Data, Subject + Activity ~ variable, mean)
write.table(avg_Data, file="activity_averages.txt", row.name=FALSE) 