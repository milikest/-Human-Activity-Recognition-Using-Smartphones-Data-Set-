library(tidyr)
library(dplyr)

constructor <- function(i){
  #' Description
  #' 
  #' constructor takes data's (dataframe) row number as arg(i) and splits values by " " and convert them to numeric value
  #' 
  #' Usage
  #' 
  #' constructor(3)
  #' 
  #' Arguments
  #' 
  #' i    Row number of dataframe
  #' 
  #' Value 
  #' 
  #' Returns a list of numeric values
  #' 
  #' Examples
  #' 
  #' constructor(3)
  #' 
  #' [1] 0.279653060 -0.019467156 -0.113461690 -0.995379560 -0.967187010
  #' [6] -0.978943960 -0.996519940 -0.963668370 -0.977468590 -0.938691550
  
  unlist(lapply(lapply(strsplit(data[i,], " "), function(z){ z[!is.na(z) & z != ""]}), as.numeric))
  }


# MERGING DATASETS--------------------------------------------------------------------------------------------------
# To merge all train and test sets we will read train sets and test sets individually and merge them.
# We will use constructor function to get new numeric data set

# XTRAIN---------------------------
# First we create a data frame called data containig the training data of X and another data frame called feature_names which contains features
# Then we use constructor function to read data frame row by row and convert it to numeric values from char and merge with previous rows.
# To do so we first create an empty data frame
# Finally we assign features to final data set as its colnames

data = read.delim('.../UCI HAR Dataset/train/X_train.txt', header = FALSE)
feature_names <- read.delim('.../UCI HAR Dataset/features.txt', header = FALSE)

df_xtrain = data.frame()
for(i in 1:dim(data)[1]){
  df_new = data.frame(matrix(constructor(i), nrow = 1, ncol = 561))
  df_xtrain = rbind.data.frame(df_xtrain, df_new)
} 

colnames(df_xtrain)= unlist(list(feature_names))

# XTEST----------------------------
# We use same approach with XTRAIN

data = read.delim('.../UCI HAR Dataset/test/X_test.txt', header=FALSE)

df_xtest = data.frame()
for(i in 1:dim(data)[1]){
  df_new = data.frame(matrix(constructor(i), nrow = 1, ncol = 561))
  df_xtest = rbind.data.frame(df_xtest,df_new)
} 

colnames(df_xtest)= unlist(list(feature_names))

# YTRAIN---------------------------
# In Y data sets we create a data frame containing our data. And read activity_labels file and deploy it in a data frame called activities
# We use first strsplit and then sapply to extract activities from data frame and deploy it in names variable
# Finally we replace the numeric values with char values which is contained in names variable

df_ytrain = read.delim('.../UCI HAR Dataset/train/y_train.txt', header=FALSE)
activities = read.delim('.../UCI HAR Dataset/activity_labels.txt', header=FALSE) 

names <- (strsplit(list(activities['V1'])[[1]][,], split="\\ "))

names <- sapply(names, "[[", 2)


for (i in(1:6)){
  df_ytrain$V1 <- replace(df_ytrain$V1, df_ytrain$V1 ==i , names[i])
}

# YTEST----------------------------
# We use same approach with YTRAIN

df_ytest = read.delim('.../UCI HAR Dataset/test/y_test.txt', header=FALSE)
activities = read.delim('.../UCI HAR Dataset/activity_labels.txt', header=FALSE) 

names <- (strsplit(list(activities['V1'])[[1]][,], split="\\ "))

names <- sapply(names, "[[", 2)
for (i in(1:6)){
  df_ytest$V1 <- replace(df_ytest$V1, df_ytest$V1 ==i , names[i])
}

# DF_TOTAL-------------------------
# When we explore dimensions of our df_xtrain and df_ytrain data frames, we see they have same number of rows, and also df_xtest and df_ytest have same number of rows
# But in the other hand df_xtrain and df_xtest data frames has same number of columns and also df_ytrain and df_ytest have same number of columns.
# So we can have two different approach to merge all of them.
# We preferred to use rbind.data.frame method to merge depending on columns first, so we merged df_ytrain and df_ytest first and assigned it to df_1
# And then we merged the df_xtrain and df_xtest by using rbind.data.frame
# We merge df_1 and df_2 depending on the columns by using cbind.data.frame and deploy it in df_total  
# We read subject information from subject of training data set and subject of test data set and store them in df_subject_traing and df_subject_test
# We rename the column of last subjest data frames as Subject 
# df_subject_traing and df_subject_test has same number of columns so we can use cbind.data.frame method to merge them to assign df_subject_total
# We finally add our subject data frame to our df_total

dim(df_xtrain)
dim(df_xtest)
dim(df_ytrain)
dim(df_ytest)

colnames(df_ytrain)="Activity"
colnames(df_ytest) ="Activity"
df_1 <- rbind.data.frame(df_ytrain, df_ytest)
df_2 <- rbind.data.frame(df_xtrain, df_xtest)

df_total <- cbind.data.frame(df_2,df_1)

# MERGING DATASETS WITH SUBJECTS---

df_subject_train = read.delim('.../UCI HAR Dataset/train/subject_train.txt', header=FALSE)
colnames(df_subject_train)= "Subject"

df_subject_test = read.delim('.../UCI HAR Dataset/test/subject_test.txt', header=FALSE)
colnames(df_subject_test)= "Subject"

dim(df_subject_train)
dim(df_subject_test)
df_subject_total = rbind.data.frame(df_subject_train, df_subject_test)
df_total <- cbind.data.frame(df_total, df_subject_total)  

# MEAN AND STANDARD DEVIATION--------------------------------------------------------------------------------------
# WE used select function from dplyr to get mean and std features.

df_mean <- df_total %>% dplyr::select(contains("mean",ignore.case = TRUE))
df_std <- df_total %>% dplyr::select(contains("std", ignore.case = TRUE))

# AVERAGE OF EACH ACTIVITY AND EACH SUBJECT------------------------------------------------------------------------
# GROUPING-------------------------
# We created a function called mean_of_subject_on_activity.
# This function takes subject and activity as input
# And first creates a subset of df_total depending on subject
# Then it subsets subject_group depending on activity
# Finally it creates a list of mean values of an activity from a subject.

mean_of_subject_on_activity <- function(subject, activity){
  subject_group = subset(df_total, Subject==subject)
  activity_group = subset(subject_group, Activity == activity)
  lapply(activity_group, mean)
}





  