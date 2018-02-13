# download and unzip the data
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,"data.zip")
unzip("data.zip")

# read all data
data_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
data_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
labels_test<-read.table("./UCI HAR Dataset/test/Y_test.txt")
labels_train<-read.table("./UCI HAR Dataset/train/Y_train.txt")
features<-read.table("./UCI HAR Dataset/features.txt")
activities<-read.table("./UCI HAR Dataset/activity_labels.txt")
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")

# combine test and train data
data_all<-rbind(data_test,data_train)
labels_all<-rbind(labels_test,labels_train)
subject_all<-rbind(subject_test,subject_train)

# turn labels into activity names
activities_all<-merge(activities,labels_all,by.x="V1",by.y="V1")
activities_all<-activities_all[[2]]

# get indices for means and stds only
indices<-grep("(mean\\(\\))|(std\\(\\))",features[[2]])

# extract data and names for means and stds only
data_all<-data_all[,indices]
features<-features[[2]][indices]

# tidy up names and name data columns
features<-tolower(features)
features<-gsub("-","",features)
features<-gsub("\\(","",features)
features<-gsub("\\)","",features)
names(data_all)<-features


# From the data set in step 4, creates a second, independent tidy data set
#  with the average of each variable for each activity and each subject

# final second data set - mean of "data_all" by subject and activity.
data_final<-aggregate(data_all,by=cbind(subject_all,activities_all),mean)
names(data_final)[[1]]<-"subjects"
names(data_final)[[2]]<-"activities"

# save final dataset
write.table(data_final,"data_subject.txt",row.name=FALSE)