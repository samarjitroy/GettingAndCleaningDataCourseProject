# Getting and Cleaning Data Course Project Assignment

## run_analysis.R

The cleanup script (run_analysis.R) does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## Running the script

To run the script, source `run_analysis.R`. After running, you will see the following output as the script works:

```
[Thu Jan 28 20:14:05 2016 ] Getting and Cleaning Data Project.
[Thu Jan 28 20:14:05 2016 ] Author: Samarjit Roy.
[Thu Jan 28 20:14:05 2016 ] 
[Thu Jan 28 20:14:05 2016 ] if current directory does not have data subdir, create one...completed.
[Thu Jan 28 20:14:05 2016 ] download zip file from the source...completed.
[Thu Jan 28 20:14:05 2016 ] if zip file exists, unzip with overwrite..completed.
[Thu Jan 28 20:14:08 2016 ] Load Data for Test case.....completed.
[Thu Jan 28 20:14:11 2016 ] Load Data for Training case.....completed.
[Thu Jan 28 20:14:24 2016 ] Load Data description information.....completed.
[Thu Jan 28 20:14:24 2016 ] Making Include filter Vector for Mean & STD.....completed.
[Thu Jan 28 20:14:24 2016 ] Merge Test & Training Features Data, filter only Mean & STD and Set Column Name.....completed.
[Thu Jan 28 20:14:24 2016 ] Merge Test & Training Subject Data and Set Column Name.....completed.
[Thu Jan 28 20:14:24 2016 ] Merge Test & Training activity Data, Set Column Name.....completed.
[Thu Jan 28 20:14:24 2016 ] Merge Activity Data and Activity Desciption Information. Then extract Only Desc Column ..completed.
[Thu Jan 28 20:14:24 2016 ] Final Merge Subject, Activity and Features Mean & STD to one Tidy Dataset...completed.
[Thu Jan 28 20:14:26 2016 ] create another dataset with the average of each variable for each activity and each subject.completed.
[Thu Jan 28 20:14:26 2016 ] Created Tidy Data File: mergedTidyData.txt and Average By activity and subject File: averageTidyData.txt in current directory.

```

## Process
1. Download source Data:
	* Check if data directory exists in current directory
	* if not there, create one data directory
	* Download data file(getdata-projectfiles-UCI HAR Dataset.zip) to data directory
2. Un-zip data file:
    * Check if zip file exists in ./data 
	* Extract data (UCI HAR Dataset) from Zip file
3. Load Datasets:
	* Load Data for Test case
	* Load Data for Training case
	* Load Data description information
4. Extracts only the measurements on the mean and standard deviation for each measurement:
	* Making Include filter Vector for Mean & STD
	* Merge Test & Training Features Data, filter only Mean & STD and Set Column Name:
		* Row bind Test and Training Data
		* Apply filter to get Mean & STD
5. Merge Test & Training Subject Data and Set Column Name
6. Merge Test & Training activity Data, Set Column Name
7. Merge Activity Data and Activity Desciption Information. Then extract Only Desc Column for all rows.
8. Final Merge Subject, Activity and Features Mean & STD to one Tidy Dataset
	* Column Bind all three set of Data
	* Write table to mergedTidyData.txt without row numbers and quote
9. From the tidy data set, creates a second, independent tidy data set with the average of each variable for each activity and each subject:
	* create average data set by acitivity and subject
	* write table to averageTidyData.txt without row numbers and quote
	
## Cleaned Data

The resulting tidy dataset is in this repository at: `data/mergedTidyData.txt`. 
A second, independent tidy data set with the average of each variable for each activity and each subject is also in this repository at: `data/averageTidyData.txt`

## Notes

X_* - feature values (one row of 561 features for a single activity)
Y_* - activity identifiers (for each row in X_*)
subject_* - subject identifiers for rows in X_*
