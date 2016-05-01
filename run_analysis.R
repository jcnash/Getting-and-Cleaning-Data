##One of the most exciting areas in all of data science right now is wearable computing - 
##see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing 
##to develop the most advanced algorithms to attract new users. The data linked to from 
##the course website represent data collected from the accelerometers from the Samsung 
##Galaxy S smartphone. A full description is available at the site where the data was obtained:
        
##        http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

##Here are the data for the project:
        
##        https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

##You should create one R script called run_analysis.R that does the following.

##      1. Merges the training and the test sets to create one data set.
##      2. Extracts only the measurements on the mean and standard deviation for each measurement.
##      3. Uses descriptive activity names to name the activities in the data set
##      4. Appropriately labels the data set with descriptive variable names.
##      5. From the data set in step 4, creates a second, independent tidy data set with the average 
##         of each variable for each activity and each subject.

###############################################################

##      1. Merges the training and the test sets to create one data set.

# Read relevant data from the unzipped file
xTrain = read.table('./UCI HAR Dataset May/train/x_train.txt',header=FALSE);
yTrain = read.table('./UCI HAR Dataset May/train/y_train.txt',header=FALSE);
features = read.table('./UCI HAR Dataset May/features.txt',header=FALSE);
activityType = read.table('./UCI HAR Dataset May/activity_labels.txt',header=FALSE);
subjectTrain = read.table('./UCI HAR Dataset May/train/subject_train.txt',header=FALSE);

# Assign column names to the training data
colnames(xTrain) = features[,2];
colnames(yTrain) = "activityId";
colnames(activityType) = c('activityId','activityType');
colnames(subjectTrain) = "subjectId";

# Merge the training data
trainingData = cbind(xTrain, subjectTrain, yTrain)

# Read in the test data
xTest = read.table('./UCI HAR Dataset May/test/x_test.txt',header=FALSE);
yTest = read.table('./UCI HAR Dataset May/test/y_test.txt',header=FALSE);
subjectTest = read.table('./UCI HAR Dataset May/test/subject_test.txt',header=FALSE);

# Assign column names to the test data
colnames(xTest) = features [,2];
colnames(yTest) = "activityId";
colnames(subjectTest) = "subjectId";

# Merge the test data
testData = cbind(xTest,subjectTest,yTest);

# Combine the training and test data
combinedData = rbind(trainingData,testData);

# Organise the column names to lead to the selection of mean and standard deviation columns
colNames <- colnames(combinedData)

##      2. Extracts only the measurements on the mean and standard deviation for each measurement.

# Create a logical vector to pull out the required columns for mean and standard devation
logicalVector = (grepl("activity..",colNames) | grepl("subject..",colNames) | 
        grepl("-mean..",colNames) & !grepl("-meanFreq..",colNames) & !grepl("mean..-",colNames) |
        grepl("-std..",colNames) & !grepl("-std()..-",colNames));


# Create a final data set including on the required columns
combinedData = combinedData[logicalVector==TRUE];

##      3. Uses descriptive activity names to name the activities in the data set

# Merge the combinedData set with the activityType table to include descriptive activity names
combinedData = merge(combinedData,activityType,by='activityId',all.x=TRUE);

# Update the colNames vector to include the new column names
colNames = colnames(combinedData);

##      4. Appropriately labels the data set with descriptive variable names.

# Clean up the variable names
for(i in 1:length(colNames))
{
        colNames[i]= gsub("\\()","",colNames[i])
        colNames[i]= gsub("-std$","StandardDeviation",colNames[i])
        colNames[i]= gsub("-mean","Mean",colNames[i])
        colNames[i]= gsub("^(t)","Time",colNames[i])
        colNames[i]= gsub("^(f)","Frequency",colNames[i])
        colNames[i]= gsub("([Gg]ravity)","Gravity",colNames[i])
        colNames[i]= gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
        colNames[i]= gsub("[Gg]yro","Gyro",colNames[i])
        colNames[i]= gsub("AccMag","AccMagnitude",colNames[i])
        colNames[i]= gsub("([Bb]odyAccJerkMag)","BodyAccJerkMagnitude",colNames[i])
        colNames[i]= gsub("JerkMag","JerkMagnitude",colNames[i])
        colNames[i]= gsub("GyroMag","GyroMagnitude",colNames[i])
};

# Reassign the new column names to the combined data set
colnames(combinedData) = colNames;

##      5. From the data set in step 4, creates a second, independent tidy data set with the average 
##         of each variable for each activity and each subject.

# Create a new table combinedDataNoActivities without the activity types
combinedDataNoActivities = combinedData[,names(combinedData) != 'activityType'];

# Summarise the above table to only include just the mean of each variable for each activity and each subject
tidyData = aggregate(combinedDataNoActivities[,names(combinedDataNoActivities) != c('activityId','subjectId')],by=list(activityId = combinedDataNoActivities$activityId,subjectId = combinedDataNoActivities$subjectId),mean);

# Merge the tidyData set with the activityTypes to include the descriptive names
tidyData = merge(tidyData,activityType,by='activityId',all.x=TRUE);

# Export the tidyData set
write.table(tidyData,'./tidydata.txt',row.names=FALSE,sep='\t');
