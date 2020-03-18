pwd <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(pwd, "DataSet.zip"))
unzip(zipfile = "DataSet.zip")

# features and activity data
features <- read.table("./UCI HAR Dataset/features.txt", 
                       col.names = c("features_id", "features_name"))
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", 
                         col.names = c("activity_id", "activity_name"))

# train data
#features data  "X_train.txt" 
# Appropriately labels the data set with descriptive variable names (STEP4)
train <- read.table("./UCI HAR Dataset/train/X_train.txt") 
colnames(train) = features$features_name 
#activity data  "y_train.txt"
trainActivity <- read.table("./UCI HAR Dataset/train/y_train.txt", 
                            col.names = "activity")
# subject data   "subject_train.txt"
trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt", 
                           col.names = "subjectid")
# train table with subjectid, activity, features data
train <- cbind(trainSubject, trainActivity, train)

# Test data
#features data  "X_test.txt"
test <- read.table("./UCI HAR Dataset/test/X_test.txt") 
colnames(test) = features$features_name 
# activity data  "y_test.txt"
testActivity <- read.table("./UCI HAR Dataset/test/y_test.txt", 
                            col.names = "activity")
# subject data   "subject_test.txt"
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt", 
                           col.names = "subjectid")
# test table with subjectid, activity, features data
test <- cbind(testSubject, testActivity, test)

# Merges the training and the test sets to create one data set (STEP1)
combined <- rbind(train, test)

# Extracts only the measurements on the mean and standard deviation for each measurement (STEP2)
columnsNames <- colnames(combined)
columnsRequired <- grep("subjectid|activity|std\\(\\)|mean\\(\\)", columnsNames)
combined <- combined[, columnsRequired]

# Uses descriptive activity names to name the activities in the data set (STEP3)
combined$activity <- factor(combined$activity, labels = activities[["activity_name"]])

# From the data set in step 4, creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject (STEP5)
combined <- melt(combined, id = c("subjectid", "activity"))
combined <- dcast(combined, subjectid + activity ~ variable, mean)

write.table(combined, file = "tidydataset.txt", row.names = FALSE)
