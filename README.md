# -Human-Activity-Recognition-Using-Smartphones-Data-Set-
------------------------------------------------------------------------------------------------------------------------------
In this script we collected the data from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

In this data set 30 volunteers are asked to perform six different activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz were captured.

Publication of this data set is: Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.

Data source contains training, test, features, subject data sets, readme and some other files. 

In data source training, test sets and features, subjects are seperated in different files.  

In a nutshell we merged all data into one big data frame and created grouping function for mean values of a subject on an activity. 

-------------------------------------------------------------------------------------------------------------------------------


MERGING DATASETS--------------------------------------------------------------------------------------------------

To merge all train and test sets we will read train sets and test sets individually and merge them.
We will use constructor function to get new numeric data set

XTRAIN---------------------------

First we create a data frame called data containig the training data of X and another data frame called feature_names which contains features
Then we use constructor function to read data frame row by row and convert it to numeric values from char and merge with previous rows.
To do so we first create an empty data frame
Finally we assign features to final data set as its colnames

XTEST----------------------------

We use same approach with XTRAIN

YTRAIN---------------------------

In Y data sets we create a data frame containing our data. And read activity_labels file and deploy it in a data frame called activities
We use first strsplit and then sapply to extract activities from data frame and deploy it in names variable
Finally we replace the numeric values with char values which is contained in names variable

YTEST----------------------------

We use same approach with YTRAIN

DF_TOTAL-------------------------

When we explore dimensions of our df_xtrain and df_ytrain data frames, we see they have same number of rows, and also df_xtest and df_ytest have same number of rows
But in the other hand df_xtrain and df_xtest data frames has same number of columns and also df_ytrain and df_ytest have same number of columns.
So we can have two different approach to merge all of them.
We preferred to use rbind.data.frame method to merge depending on columns first, so we merged df_ytrain and df_ytest first and assigned it to df_1
And then we merged the df_xtrain and df_xtest by using rbind.data.frame
We merge df_1 and df_2 depending on the columns by using cbind.data.frame and deploy it in df_total  
We read subject information from subject of training data set and subject of test data set and store them in df_subject_traing and df_subject_test
We rename the column of last subjest data frames as Subject 
df_subject_traing and df_subject_test has same number of columns so we can use cbind.data.frame method to merge them to assign df_subject_total
We finally add our subject data frame to our df_total

MEAN AND STANDARD DEVIATION--------------------------------------------------------------------------------------

We used select function from dplyr to get mean and std features.

AVERAGE OF EACH ACTIVITY AND EACH SUBJECT------------------------------------------------------------------------

GROUPING-------------------------

We created a function called mean_of_subject_on_activity.
This function takes subject and activity as input
And first creates a subset of df_total depending on subject
Then it subsets subject_group depending on activity
Finally it creates a list of mean values of an activity from a subject.
