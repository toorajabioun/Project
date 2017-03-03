download data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
the info about this data can be found here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

##Description of the variables in the code:

Variable | type | size | description
---------|------|-------|-----
X|data frame|10299x79|includes all the total of 10299 observations each has 79 variables of interest  
y|factor|10299x1|determins the type of activity for each object
activities|character|6x2|lists all types of activities
features|character|561x2|lists the names of all features of the data (column names of X)
names|character|1x79|names of the columns that we are interested in. i.e. contains mean or std
inds|int|1x79|containd the indices of "names" in "features"
subject|int|10299x1|indicates the id of the person who did the experiment
sUbject_activity|factor|10299x1|combination of "y" and "subject". indicates the activity for each subject
newDF|data frame|180x79|contains the new tidy data set(averages for each "subject_activity" category)
