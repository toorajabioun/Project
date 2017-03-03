# loading train and test tables:
X_train<-read.table("UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("UCI HAR Dataset/train/y_train.txt")
X_test<-read.table("UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("UCI HAR Dataset/test/y_test.txt")

#merging train and test:
X<-rbind(X_train,X_test)
y<-rbind(y_train,y_test)

#assigning meaningful names to columns and activities:
activities<-read.table("UCI HAR Dataset/activity_labels.txt")
colnames(y)[1]="activity"
y$activity<-factor(y$activity,labels=activities[,2])
features<-read.table("UCI HAR Dataset/features.txt")

#extracting any colomn related to mean and std:
names<-grep("mean|std",features[,2],value=TRUE)
inds<-grep("mean|std",features[,2],value=FALSE)
X<-X[,inds]
colnames(X)=names

#loading subjects:
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
#merging them:
subject<-rbind(subject_train,subject_test)
colnames(subject)="subjectID"
subject$subjectID<-factor(subject$subjectID)

#forming the mean data set:
sUbject_activity<-paste(subject$subjectID,y$activity)
sUbject_activity<-factor(sUbject_activity)
newDF=c()
for (i in 1:length(X)){
  z<-data.frame(tapply(X[,i],sUbject_activity,mean))
  if (i==1){newDF=z} else{newDF<-cbind(newDF,z)
  }
}
colnames(newDF)<-names
write.table(newDF,file="NewDataSet.txt")
