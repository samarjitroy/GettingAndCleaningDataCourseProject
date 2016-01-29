# This Script (run_analysis.R) will do the followings on the data available at 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.
# 
#	1. Merges the training and the test sets to create one data set.
#	2. Extracts only the measurements on the mean and standard deviation for each measurement.
#	3. Uses descriptive activity names to name the activities in the data set
#	4. Appropriately labels the data set with descriptive variable names.
#	5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#
#
#
library(curl)
library(data.table)

p <- function(...) {
  d <- format(Sys.time(), "[%a %b %d %H:%M:%S %Y ]")
  cat(d, ...)
  flush.console()
}

done <- function() {
  cat("completed.\n")
}

cleanData <- function(dir){
	p("Getting and Cleaning Data Project.\n")
      p("Author: Samarjit Roy.\n")
      p("\n")
	# get Data from Source
      getDataFileUnzip()

  	# There are three sets of data files (subject, features, activity) available 
  	# for two type data(test & training) load test data  

  	# load Data for Test case
  	p("Load Data for Test case.....")
  	testDir <- file.path(dir, "test")
  	subject_test = read.table(file.path(testDir , "subject_test.txt"))
  	features_test = read.table(file.path(testDir , "X_test.txt"))
  	activity_test = read.table(file.path(testDir , "Y_test.txt"))
      done()
  
  	# load training data
  	p("Load Data for Training case.....")
  	trainDir <- file.path(dir, "train")
  	subject_training = read.table(file.path(trainDir , "subject_train.txt"))
  	features_training = read.table(file.path(trainDir , "X_train.txt"))
  	activity_training = read.table(file.path(trainDir , "Y_train.txt"))
      done()
  
  	# load data description information
  	p("Load Data description information.....")
  	features <- read.table(file.path(dir , "features.txt"), col.names=c("featureId", "featureDesc"))
  	activities <- read.table(file.path(dir , "activity_labels.txt"), col.names=c("activityId", "activityDesc"))
  	activities$activityDesc<- gsub("_", "", as.character(activities$activityDesc))
      done()

  	# Making Include filter Vector for Mean & STD
  	p("Making Include filter Vector for Mean & STD.....")
  	includedFeatures <- grep("-mean\\(\\)|-std\\(\\)", features$featureDesc)
      done()
  
  	# Merge Test & Training Features Data, filter only Mean & STD and Set Column Name
  	p("Merge Test & Training Features Data, filter only Mean & STD and Set Column Name.....")
  	featuresAll <- rbind(features_test, features_training)
  	featuresMeanStd <- featuresAll[, includedFeatures]
  	featureDesc <- features$featureDesc[includedFeatures]
  	names(featuresMeanStd) <- gsub("\\(|\\)", "", featureDesc)
      done()

	# Merge Test & Training Subject Data and Set Column Name
  	p("Merge Test & Training Subject Data and Set Column Name.....")
  	subject <- rbind(subject_test, subject_training)
  	names(subject) <- "subjectId"
      done()

  	# Merge Test & Training activity Data, Set Column Name
  	p("Merge Test & Training activity Data, Set Column Name.....")
  	activityAll <- rbind(activity_test, activity_training)
  	names(activityAll) = "activityId"
      done()

  	# Merge Activity Data and Activity Desciption Information. Then extract Only Desc Column
  	p("Merge Activity Data and Activity Desciption Information. Then extract Only Desc Column ..")
  	activity <- merge(activityAll, activities, by="activityId")
  	activityDesc <- activity$activityDesc
      done()
  
  	# Final Merge Subject, Activity and Features Mean & STD to one Tidy Dataset
  	p("Final Merge Subject, Activity and Features Mean & STD to one Tidy Dataset...")
  	tidyData <- cbind(subject, activityDesc,featuresMeanStd)
  	write.table(tidyData, "data/mergedTidyData.txt",row.names = F, quote = F)
  	#View(tidyData)
      done()

  	# create a dataset 
  	tidyDataTable <- data.table(tidyData)

  	# create another dataset with the average of each variable for each activity and each subject
  	#.SD refers to the Subset of the data.table for each group (excluding the grouping columns)
  	p("create another dataset with the average of each variable for each activity and each subject.")
  	averageData<- tidyDataTable [, lapply(.SD, mean), by=c("subjectId", "activityDesc")]
  	#View(averageData)
  	write.table(averageData, "data/averageTidyData.txt",row.names = F, quote = F)
      done()

      p("Created Tidy Data File: mergedTidyData.txt and Average By activity and subject File: averageTidyData.txt in current directory.\n")
}

getDataFileUnzip <- function(){
	# if current directory does not have data subdir, create one
      p("if current directory does not have data subdir, create one...")
	mainDir <- getwd()
	if (!file.exists("data")){
		dir.create(file.path(mainDir, "data"))
	}
	done()

      # download zip file from the source
	p("download zip file from the source...")
	dataURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
	downloadFileName <- "data/getdata-projectfiles-UCI HAR Dataset.zip"
	if (!file.exists(downloadFileName))
	{
		download.file(dataURL, dest=downloadFileName, method="libcurl",quiet = TRUE)
	}
	done()

      # if zip file exists, unzip with overwrite
      p("if zip file exists, unzip with overwrite..")
	if (file.exists(downloadFileName))
	{
		unzip(downloadFileName, exdir = "data", overwrite = TRUE)
     	} 
	done()
}

cleanData("data/UCI HAR Dataset")

