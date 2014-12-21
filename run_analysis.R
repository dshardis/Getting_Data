## Import libraries and data
library(dplyr)
library(tidyr)
library(sqldf)
activity <- read.csv("UCI_HAR_Dataset/activity_labels.txt", header = FALSE, sep = " ")
feature <- read.csv("UCI_HAR_Dataset/features.txt", header = FALSE, sep = " ")
feature_list <- as.list(grep("mean|std", feature[,2]))
subject_test <- read.csv("UCI_HAR_Dataset/test/subject_test.txt", header = FALSE, col.names = "Subject")
X_test <- read.csv("UCI_HAR_Dataset/test/X_test.txt", header = FALSE, strip.white = TRUE, sep = "", col.names = feature[,2])
y_test <- read.csv("UCI_HAR_Dataset/test/y_test.txt", header = FALSE, col.names = "Act")
test_data <- cbind(subject_test, y_test)
test_data <- cbind(test_data, X_test)
subject_train <- read.csv("UCI_HAR_Dataset/train/subject_train.txt", header = FALSE, col.names = "Subject")
X_train <- read.csv("UCI_HAR_Dataset/train/X_train.txt", header = FALSE, strip.white = TRUE, sep = "", col.names = feature[,2])
y_train <- read.csv("UCI_HAR_Dataset/train/y_train.txt", header = FALSE, col.names = "Act")

## Binds all columns together
train_data <- cbind(subject_train, y_train)
train_data <- cbind(train_data, X_train)

## Merges training and test data sets
dataset <- rbind(test_data, train_data)
dataset <- merge(dataset, activity, by.x = "Act", by.y = "V1", all.x = TRUE, sort = TRUE)
dataset <- rename(dataset, Activity = V2)

## Selects appropriate data and aggregates
dataset <- select(dataset, contains("Subject"), contains("Activity"), contains("mean"), contains("std"))
results <- sqldf("SELECT * FROM dataset GROUP by Subject, Activity")

## Writes to a file
write.table(results, file = "tidy_data.txt", row.name = FALSE)
