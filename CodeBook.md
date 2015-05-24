# Code Book

This is the code book that describes the variables, the data, and any transformations or work that I performed to clean up the data.

## The data source
  * The Original Source is at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
  * The data source for the project is at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## The result tidy dataset
The result tidy dataset contains six variables.
* subject: the experiment subjects
* activity: six activites experimented, including 
    + WALKING
    + WALKING_UPSTAIRS
    + WALKING_DOWNSTAIRS
    + SITTING
    + STANDING
    + LAYING
* feature: the features measured in experiments. In total, 17 features are included in the result tidy dataset, and they are
    + [1] "timeBodyAccelerometer"                  
    + [2] "timeGravityAccelerometer"               
    + [3] "timeBodyAccelerometerJerk"              
    + [4] "timeBodyGyroscope"                      
    + [5] "timeBodyGyroscopeJerk"                  
    + [6] "timeBodyAccelerometerMagnitude"         
    + [7] "timeGravityAccelerometerMagnitude"      
    + [8] "timeBodyAccelerometerJerkMagnitude"     
    + [9] "timeBodyGyroscopeMagnitude"             
    + [10] "timeBodyGyroscopeJerkMagnitude"         
    + [11] "frequencyBodyAccelerometer"             
    + [12] "frequencyBodyAccelerometerJerk"         
    + [13] "frequencyBodyGyroscope"                 
    + [14] "frequencyBodyAccelerometerMagnitude"    
    + [15] "frequencyBodyAccelerometerJerkMagnitude"
    + [16] "frequencyBodyGyroscopeMagnitude"        
    + [17] "frequencyBodyGyroscopeJerkMagnitude"  
* estimation_method: the methods used for estimate the feature results. As instructed by the project specification, only two methods are considered in the final result -- mean() and std()
* axis: the three dimensional directions (X, Y, Z) measured in experiments, the value of this variable might be "NA" for some measurements
* value: the final average value of the measurement specified

The resulted tidy dataset is indeed tidy because it fulfills that 
* each measured variable is in one column, and
* each different observation of that variable is in a different row.

The resulted tidy dataset was ordered primarily on "subject" and secondarily on "activity" alphabetically.

## The description of the dataset transformation process
To perform the transformation, we need to load three libraries as specified at the top of run_analysis.R.
* dplyr
* tidyr
* reshape2

There are toally six functions defined in run_analysis.R.
* download.source() This function downloads the project input raw datasets and places them into a subfolder named "data" of the present working directory. If you have already had the files in such a folder, you do not need to execute it again.
* merge.data() This function merges the training and the test sets to create one dateset. You do NOT have to execute this function by yourself unless you want to see the result step-by-step. The execution of this function is included in the function clean.dataset().
* extract.data(data) This function takes a parameter, which must be the result of merge.data(), and outputs the extracted result of measurements on mean and standard deviation for each measuremens only. You do NOT have to execute this function by yourself unless you want to see the result step-by-step. The execution of this function is included in the function clean.dataset().
* rename.activities(data) This function takes a parameter, which must be the result of merge.data(), and substitutes the activity ids with the descriptive names of the respective activities. You do NOT have to execute this function by yourself unless you want to see the result step-by-step. The execution of this function is included in the function clean.dataset().
* clean.dataset() This function merges datasets, extracts desired columns, and renames activity ids with their descriptive names, and add descriptive names to all the variable names. Executing this function produces the clean (but not tidy) dataset of the project result.
* tidy.dataset(data) This function takes a paramenter, which must be the result of clean.dataset(), and outputs a tidy dataset that describes the same set of data. Executing this function produces the tidy dataset based on the clean dataset.
