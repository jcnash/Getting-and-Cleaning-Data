---
title: "README"
output: html_document
---
# Getting and Cleaning Data Final Project**

* This is my Getting and Cleaning Data Final Project. The R script, run_analysis.R, does the following:

* Reads the relevant data from the unzipped file
* Assigns column names to the training data
* Merges the training data
* Assigns column names to the test data
* Merges the test data
* Combines the training and test data
* Organise the column names to lead to the selection of mean and standard deviation columns
* Creates a logical vector to pull out the required columns for mean and standard devation
* Creates a final data set including on the required columns
* Merges the 'combinedData' set with the 'activityType' table to include descriptive activity names
* Updates the column names to include the new column names
* Clean up the variable names
* Reassigns the new column names to the combined data set
* Creates a new table 'combinedDataNoActivities' without the activity types
* Summarise the above table to only include just the mean of each variable for each activity and each subject
* Merge the tidyData set with the activityTypes to include the descriptive names
* Export the tidyData set as 'tidyData.txt'