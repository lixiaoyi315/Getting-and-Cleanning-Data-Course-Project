#question1 Merges the training and the test sets to create one data set.
xtest<-read.table("./test/X_test.txt")
xtrain<-read.table("./train/X_train.txt")
Newdata1<-rbind(xtest,xtrain)
testlab<-read.table("./test/y_test.txt")
trainlab<-read.table("./train/y_train.txt")
Newlab<-rbind(testlab,trainlab)
testsub<-read.table("./test/subject_test.txt")
trainsub<-read.table("./train/subject_train.txt")
Newsub<-rbind(testsub,trainsub)
Newdata1$label<-as.character(Newlab)
Newdata1$subject<-as.character(Newsub)

#question2 Extracts only the measurements on the mean and standard deviation for each measurement.
library(dplyr)
features<-read.table("./features.txt")
Newfeatures<-filter(features,grepl('(mean()|std())',V2,ignore.case=F))
vars <- c(Newfeatures$V1)
Newdata2<-select(Newdata1,vars)
Newdata2$labID<-Newlab$V1
Newdata2$subjectID<-Newsub$V1

#question3 Uses descriptive activity names to name the activities in the data set
activity_labels<-read.table("activity_labels.txt")
activitylabName<-factor(Newdata2$labID,levels = activity_labels$V1,labels = activity_labels$V2)
Newdata3<-mutate(Newdata2,labName=activitylabName)

#question4 Appropriately labels the data set with descriptive variable names.
library(data.table)
oldnames<-paste0(c("V"),Newfeatures$V1)
newnames<-as.character(Newfeatures$V2)
setnames(Newdata3,old = oldnames,new = newnames)
names(Newdata3)

#question5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
library(reshape2)
MeltNewdata3<-melt(Newdata3,id=c("labID","subjectID"),measure.vars=newnames)
averagedata<-dcast(MeltNewdata3,labID+subjectID~variable,mean)
write.table(averagedata,"./UCI-activity-subject-average.csv")
