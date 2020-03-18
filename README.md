# GettingCleaningData - Assignment
Data science specialization Getting Cleaning Assignment

# Getting raw data

```{r}
pwd <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(pwd, "DataSet.zip"))
unzip(zipfile = "DataSet.zip")
```

# features and activity data
features <- read.table("./UCI HAR Dataset/features.txt", 
                       col.names = c("features_id", "features_name"))
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", 
                         col.names = c("activity_id", "activity_name"))

# train data "X_train.txt", Activity data "y_train.txt", Subject data "subject_train.txt"
# Appropriately labels the data set with descriptive variable names (STEP4)
# cbind train table with subjectid, activity
```{r}
train <- read.table("./UCI HAR Dataset/train/X_train.txt") 
colnames(train) = features$features_name 
trainActivity <- read.table("./UCI HAR Dataset/train/y_train.txt", 
                            col.names = "activity")
trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt", 
                           col.names = "subjectid")
train <- cbind(trainSubject, trainActivity, train)
```

# Test data "X_test.txt", activity data "y_test.txt", subject data "subject_test.txt"
# Appropriately labels the data set with descriptive variable names (STEP4)
# rbind test table with subjectid, activity
test <- read.table("./UCI HAR Dataset/test/X_test.txt") 
colnames(test) = features$features_name 
testActivity <- read.table("./UCI HAR Dataset/test/y_test.txt", 
                            col.names = "activity")
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt", 
                           col.names = "subjectid")
test <- cbind(testSubject, testActivity, test)

# Merges "train" and "test" data to create one dataset (STEP1)
```{r}
combined <- rbind(train, test)
```

# Extracts only the measurements on the mean and standard deviation for each measurement (STEP2)
```{r}
columnsNames <- colnames(combined)
columnsRequired <- grep("subjectid|activity|std\\(\\)|mean\\(\\)", columnsNames)
combined <- combined[, columnsRequired]
```
# Uses descriptive activity names to name the activities in the data set (STEP3)
```{r}
combined$activity <- factor(combined$activity, labels = activities[["activity_name"]])
```

# From the combined data set, creates independent tidy data set with 
# the average of each variable for each activity and each subject (STEP5)
```{r}
combined <- melt(combined, id = c("subjectid", "activity"))
combined <- dcast(combined, subjectid + activity ~ variable, mean)

write.table(combined, file = "tidydataset.txt", row.names = FALSE)
```
