for question1
xtest/xtrain to read test and train sets
Newdata1 is the outcome of rowbind about test and train sets
testlab/trainlab to read the activity labels in test and train
Newlab is the outcome of rowbind about test and train activity labels
testsub/trainsub to read the test and train subjects
NewSub is the out come of rowbind about test and train subjects
update the Newdata1 by add the activity labels and subject through Newlab and NewSub

for question2
features to read the features.txt
Newfeatures to filter the data by featuresnames contain"mean"or"std"
Newdata2 is the subset of data which only connect with Newfeatures

for question3
Newdata3 is add the activity names based on Newdata2

for question4
Newdata3 is updated through named by the featuresnames on the columns

for question5
MeltNewdata3 is to creat the new table to instore the data by activity labels and subjects
averagedata is to calculate the average of the variables based on each activity label and each subject 

