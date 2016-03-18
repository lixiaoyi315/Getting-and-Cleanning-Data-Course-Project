install.packages("data.table")

library(data.table)


# 1. Merges the training and the test sets to create one data set.
# Read in subject training/test data:
setwd("d:/test/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/")
subjectTest  <- fread("./test/subject_test.txt" )
head(subjectTest)
subjectTrain <- fread("./train/subject_train.txt")
head(subjectTrain)

# Read activity training/test data:
Xtest<-read.table("./test/X_test.txt")
XTest<-data.table(Xtest)
Xtrain<-read.table("./train/X_train.txt")
XTrain<-data.table(Xtrain)
Ytest<- read.table("./test/Y_test.txt")
YTest<-data.table(Ytest)
Ytrain<- read.table("./train/y_train.txt")
YTrain<-data.table(Ytrain)
# Merge training and test datasets
X <- rbind(XTest, XTrain,fill=T)
Y <- rbind(YTest, YTrain,fill=T)
subjectAll<-rbind(subjectTest,subjectTrain,fill=T)

# Set column names:
setnames(X, "V1", "subject")
setnames(Y, "V1", "activityNum")
XY <- cbind(X, Y)
head(XY)
NewtidyData <- cbind(XY, subjectAll)
head(NewtidyData)
setkey(NewtidyData, subject, activityNum)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
features <- fread("./features.txt")
head(features)
setnames(features, names(features), c("featureNum", "featureName"))
features <- features[grepl("mean\\(\\)|std\\(\\)", featureName)]
features$featureCode <- features[, paste0("V", featureNum)]
head(features)
features$featureCode
select <- c(key(NewtidyData), features$featureCode)
NewtidyData <- NewtidyData[, select, with=FALSE]
head(NewtidyData)

#3. Uses descriptive activity names to name the activities in the data set
activity_label <- fread("./activity_labels.txt")
setnames(activity_label, names(activity_label), c("activityNum", "activityName"))
NewtidyData <- merge(NewtidyData, activity_label, by="activityNum", all.x=TRUE)

# 4. Appropriately labels the data set with descriptive variable names. 
setkey(NewtidyData, subject, activityNum, activityName)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
NewtidyData$activity <- factor(NewtidyData$activityName)
NewtidyData$feature <- factor(NewtidyData$featureName)

grep_feature <- function (regex) {
  grepl(regex, NewtidyData$feature)
}

## Features with 1 category
NewtidyData$featJerk <- factor(grep_feature("Jerk"), labels=c(NA, "Jerk"))
NewtidyData$featMagnitude <- factor(grep_feature("Mag"), labels=c(NA, "Magnitude"))

## Features with 2 categories
n <- 2
y <- matrix(seq(1, n), nrow=n)
x <- matrix(c(grep_feature("^t"), grep_feature("^f")), ncol=nrow(y))
NewtidyData$featDomain <- factor(x %*% y, labels=c("Time", "Freq"))

x <- matrix(c(grep_feature("Acc"), grep_feature("Gyro")), ncol=nrow(y))
NewtidyData$featInstrument <- factor(x %*% y, labels=c("Accelerometer", "Gyroscope"))

x <- matrix(c(grep_feature("BodyAcc"), grep_feature("GravityAcc")), ncol=nrow(y))
NewtidyData$featAcceleration <- factor(x %*% y, labels=c(NA, "Body", "Gravity"))

x <- matrix(c(grep_feature("mean()"), grep_feature("std()")), ncol=nrow(y))
NewtidyData$featVariable <- factor(x %*% y, labels=c("Mean", "SD"))

## Features with 3 categories
n <- 3
y <- matrix(seq(1, n), nrow=n)
x <- matrix(c(grep_feature("-X"), grep_feature("-Y"), grep_feature("-Z")), ncol=nrow(y))
NewtidyData$featAxis <- factor(x %*% y, labels=c(NA, "X", "Y", "Z"))

NewtidyData<- NewtidyData[, list(count = .N, average = mean(value)), by=key(NewtidyData)]

write.table(NewtidyData, "tidydataset.txt")
