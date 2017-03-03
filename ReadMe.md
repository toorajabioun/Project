##How The Code Works:

###step 1- loading the data:
the data files should be in the "UCI HAR Dataset" folder in the working directory

```r
# loading train and test tables:
X_train<-read.table("UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("UCI HAR Dataset/train/y_train.txt")
X_test<-read.table("UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("UCI HAR Dataset/test/y_test.txt")
```

###step 2- merging train and test data sets: 

```r
#merging train and test:
X<-rbind(X_train,X_test)
head(X[,1:5])
```

```
##          V1          V2         V3         V4         V5
## 1 0.2885845 -0.02029417 -0.1329051 -0.9952786 -0.9831106
## 2 0.2784188 -0.01641057 -0.1235202 -0.9982453 -0.9753002
## 3 0.2796531 -0.01946716 -0.1134617 -0.9953796 -0.9671870
## 4 0.2791739 -0.02620065 -0.1232826 -0.9960915 -0.9834027
## 5 0.2766288 -0.01656965 -0.1153619 -0.9981386 -0.9808173
## 6 0.2771988 -0.01009785 -0.1051373 -0.9973350 -0.9904868
```

```r
y<-rbind(y_train,y_test)
head(y)
```

```
##   V1
## 1  5
## 2  5
## 3  5
## 4  5
## 5  5
## 6  5
```

###step 3- assigning meaningful to the columns:
the feature names can be found in the features.txt file. the next line finds all the features which have either mean or std in their names. the next line is the index of these columns. the next line separates these columns from X. and finally, the fourth line assigns the meaningful names to the columns.

```r
#extracting any colomn related to mean and std:
features<-read.table("UCI HAR Dataset/features.txt")
names<-grep("mean|std",features[,2],value=TRUE)
head(names)
```

```
## [1] "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z"
## [4] "tBodyAcc-std()-X"  "tBodyAcc-std()-Y"  "tBodyAcc-std()-Z"
```

```r
inds<-grep("mean|std",features[,2],value=FALSE)
X<-X[,inds]
colnames(X)=names
head(X[,1:5])
```

```
##   tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X
## 1         0.2885845       -0.02029417        -0.1329051       -0.9952786
## 2         0.2784188       -0.01641057        -0.1235202       -0.9982453
## 3         0.2796531       -0.01946716        -0.1134617       -0.9953796
## 4         0.2791739       -0.02620065        -0.1232826       -0.9960915
## 5         0.2766288       -0.01656965        -0.1153619       -0.9981386
## 6         0.2771988       -0.01009785        -0.1051373       -0.9973350
##   tBodyAcc-std()-Y
## 1       -0.9831106
## 2       -0.9753002
## 3       -0.9671870
## 4       -0.9834027
## 5       -0.9808173
## 6       -0.9904868
```

###step 4- Assigning meaningful names to the output (activities)
similar to step 3, we assign the labels meaningful names found in the activity_labels.txt file

```r
#assigning meaningful names to columns and activities:
activities<-read.table("UCI HAR Dataset/activity_labels.txt")
head(activities)
```

```
##   V1                 V2
## 1  1            WALKING
## 2  2   WALKING_UPSTAIRS
## 3  3 WALKING_DOWNSTAIRS
## 4  4            SITTING
## 5  5           STANDING
## 6  6             LAYING
```

```r
colnames(y)[1]="activity"
y$activity<-factor(y$activity,labels=activities[,2])
head(y)
```

```
##   activity
## 1 STANDING
## 2 STANDING
## 3 STANDING
## 4 STANDING
## 5 STANDING
## 6 STANDING
```

###step 5- loading the subject IDs:
here, first we load the subject ids for train and test datasets. then, we merge them together. and finally convert it to a factor.

```r
#loading subjects:
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
#merging them:
subject<-rbind(subject_train,subject_test)
colnames(subject)="subjectID"
subject$subjectID<-factor(subject$subjectID)
head(subject)
```

```
##   subjectID
## 1         1
## 2         1
## 3         1
## 4         1
## 5         1
## 6         1
```

###step 6- forming the tidy data set:
first, we create a new column by combining subjects and activities:

```r
sUbject_activity<-paste(subject$subjectID,y$activity)
sUbject_activity<-factor(sUbject_activity)
head(sUbject_activity)
```

```
## [1] 1 STANDING 1 STANDING 1 STANDING 1 STANDING 1 STANDING 1 STANDING
## 180 Levels: 1 LAYING 1 SITTING 1 STANDING ... 9 WALKING_UPSTAIRS
```
second, taking the mean of each column for each category(subject-activity), and placing them in a new data frame:

```r
newDF=c()
for (i in 1:length(X)){
  z<-data.frame(tapply(X[,i],sUbject_activity,mean))
  if (i==1){newDF=z} else{newDF<-cbind(newDF,z)
  }
}
colnames(newDF)<-names
head(newDF[,1:5])
```

```
##                      tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z
## 1 LAYING                     0.2215982      -0.040513953        -0.1132036
## 1 SITTING                    0.2612376      -0.001308288        -0.1045442
## 1 STANDING                   0.2789176      -0.016137590        -0.1106018
## 1 WALKING                    0.2773308      -0.017383819        -0.1111481
## 1 WALKING_DOWNSTAIRS         0.2891883      -0.009918505        -0.1075662
## 1 WALKING_UPSTAIRS           0.2554617      -0.023953149        -0.0973020
##                      tBodyAcc-std()-X tBodyAcc-std()-Y
## 1 LAYING                  -0.92805647     -0.836827406
## 1 SITTING                 -0.97722901     -0.922618642
## 1 STANDING                -0.99575990     -0.973190056
## 1 WALKING                 -0.28374026      0.114461337
## 1 WALKING_DOWNSTAIRS       0.03003534     -0.031935943
## 1 WALKING_UPSTAIRS        -0.35470803     -0.002320265
```
third, writing the result to a text file:

```r
write.table(newDF,file="NewDataSet.txt")
```
