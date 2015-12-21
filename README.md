# Getting-and-Cleaning-Data-Coursera-Course-Project
 This is the repo for the course project for the 'Getting and Cleaning Data' Coursera course. The script, run_analysis.R does the following things:
 1. Load the libraries you need (reshape2, plyr, dplyr)
 2. Download the file if it doesn't already exist in your working directory, and unzip the file and set the right working directory.
 3. Reads all the Test and Train files from the data set.
 4. Merges the sets to create one dataframe for each set (activity, subject, features)
 5. Renames the variables and merges all dataframe in a bigger one.
 6. Extraxts only the measurements on the mean and standard deviation.
 7. Uses descriptive activity names to name the activities in data set
 8. Labels the data set with descriptive variable names
 9. Creates a tidy data set with the average of each variable for each activity and each subject.

The final result is shown in tidydata.txt file.
