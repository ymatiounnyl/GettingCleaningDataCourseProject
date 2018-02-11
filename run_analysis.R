# download, unzip and load the data
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,"data.zip")
unzip("data.zip")
data_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
data_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
features<-read.table("./UCI HAR Dataset/features.txt")

# combine test and train data
data_all<-rbind(data_test,data_train)

# get indices for means and stds only
indices<-grep("(mean\\(\\))|(std\\(\\))",features[[2]])

# extract data and names for means and stds only
data_all<-data_all[,indices]
features<-features[[2]][indices]

# tidy up names
features<-tolower(features)
features<-gsub("-","",features)
features<-gsub("\\(","",features)
features<-gsub("\\)","",features)

# name data columns and save "data_all"
names(data_all)<-features
write.table(data_all,"data_all.txt",row.name=FALSE)


# From the data set in step 4, creates a second, independent tidy data set
#  with the average of each variable for each activity and each subject

# read subject IDs
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")

# combine test and train subjects
subject_all<-rbind(subject_test,subject_train)

# final second data set - mean of "data_all" 1 by subject.
data_subject<-aggregate(data_all,subject_all,mean)
names(data_subject)[[1]]<-"subject"

# save final dataset
write.table(data_subject,"data_subject.txt",row.name=FALSE)