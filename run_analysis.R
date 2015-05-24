# This R script is to fulfill the course project at Getting and Cleaning Data
# It accomplishes the following requirements.
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with 
#    the average of each variable for each activity and each subject.

# load the used library
library(dplyr); library(tidyr); library(reshape2)

# 0. Download files if it has not been done before
download.source <- function() {
    # check the existence of the data source home repository under the current working directory
    if(!file.exists("data")) {
        message("Creating the data repository under the present working directory")
        dir.create("data")
    }
    # check the existence of the target data source
    if(!file.exists("data/UCI HAR Dataset")) {
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        destfile <- "./data/data.zip"
        message("Downloading the data source")
        download.file(fileURL, destfile=destfile, method="auto")
        unzip(destfile, exdir="data")
    }
}

# 1. Merges the training and the test sets to create one data set.
merge.data <- function() {
    # read X_train
    training.x <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
    # read y_train
    training.y <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
    # read X_test
    test.x <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
    # read y_train
    test.y <- read.table("./data/UCI HAR Dataset/test/y_test.txt")    
    # read training subjects
    training.subjects <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
    # read test subjects
    test.subjects <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
    # read feature names
    features <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors=FALSE)
    
    
    # the process of data merge
    m.x <- rbind(training.x, test.x)
    m.y <- rbind(training.y, test.y)
    m.subjects <- rbind(training.subjects, test.subjects)
    
    # form the merged dataset
    data <- cbind(m.subjects, m.y, m.x)
    # add column names to the merged data
    # m.subjects are given the column name "subject"
    # m.y are given the column name "activity"
    names(data) <- c("subject", "activity", features[,2]) 
    
    # return the merged dataset
    data    
}

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## parameter: the data frame created by merge.data()
extract.data <- function(data) {
    # extract measurements on the mean
    a.mean <- data[, grepl("mean()", names(data), fixed=TRUE)==TRUE]
    # extract measurements on the standard deviation
    a.std <- data[, grepl("std()", names(data), fixed=TRUE)==TRUE]
    # columan bind a.mean and a.std
    a <- cbind(a.mean, a.std)
    
    a
}


# 3. Uses descriptive activity names to name the activities in the data set
## parameter: the data frame created by merge.data()
rename.activities <- function(data) {
    
    lnames <- read.table("./data/UCI HAR Dataset/activity_labels.txt", stringsAsFactors=FALSE)
     
    for(i in 1:6) {
        data$activity[data$activity == i] = lnames[i, "V2"]
    }
    
    data    
}

# 4. Appropriately labels the data set with descriptive variable names. 
# this step plays as the main routine that outputs the clean dataset as request without being tidy
clean.dataset <- function() {
    message("Merge Data, assign the descriptive variable names and descriptive activity names")
    data <- merge.data()
    data <- rename.activities(data)
    
    message("Extracts only the measurements on the mean and standard deviation for each measurement")
    d2 <- extract.data(data)
    
    #rename the variable names by the following rules
    ### prefix t is replaced by time
    ### Acc is replaced by Accelerometer
    ### Gyro is replaced by Gyroscope
    ### prefix f is replaced by frequency
    ### Mag is replaced by Magnitude
    ### BodyBody is replaced by Body
    names(d2)<-gsub("^t", "time", names(d2))
    names(d2)<-gsub("^f", "frequency", names(d2))
    names(d2)<-gsub("Acc", "Accelerometer", names(d2))
    names(d2)<-gsub("Gyro", "Gyroscope", names(d2))
    names(d2)<-gsub("Mag", "Magnitude", names(d2))
    names(d2)<-gsub("BodyBody", "Body", names(d2))
    
    message("Attach the result dataset with subject and activity columns")
    d2 <- cbind(data[,1:2], d2)
    
    d2
}

# 5. From the data set in step 4, creates a second, independent tidy data set with 
#    the average of each variable for each activity and each subject.
## parameter: the data frame created by clean.dataset()
tidy.dataset <- function(data) {
    # calculate average by subject and activity and order the result
    data2 <- aggregate(. ~subject + activity, data, mean)
    data2 <- data2[order(data2$subject, data2$activity),]
    
    # melt the wide table into long table
    md <- melt(data2, id.vars = c("subject","activity"))
    md$variable <- as.character(md$variable)
    # seperate the overloaded variable into multiple columns so that the result fulfills "tidy"
    # extra="merge" so that it takes "NA" when no axis specified in certain tests
    md <- separate(md, variable, c("feature", "estimation_method", "axis"), sep="-", extra="merge")

    write.table(md, file ="tidy_data.txt", row.name=FALSE)
    
    md
}