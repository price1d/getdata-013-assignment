# Load additional library needed
library(dplyr)

# Initialise variables used in script
# numRowsToLoad - set to -1 to load all rows or positive integer to load small set of rows when testing
numRowsToLoad <- -1
# path - location of data set to load
path <- "~/R/UCI/UCI HAR Dataset/"

# Load Train & Test data sets
dataTrainX <- read.table(paste(path,"train/X_train.txt",sep=""), sep="", nrows = numRowsToLoad)
dataTrainY <- read.table(paste(path,"train/Y_train.txt",sep=""), sep="", nrows = numRowsToLoad)
dataTrainSubject <- read.table(paste(path,"train/subject_train.txt",sep=""), sep="", nrows = numRowsToLoad)
dataTestX <- read.table(paste(path,"test/X_test.txt",sep=""), sep="", nrows = numRowsToLoad)
dataTestY <- read.table(paste(path,"test/Y_test.txt",sep=""), sep="", nrows = numRowsToLoad)
dataTestSubject <- read.table(paste(path,"test/subject_test.txt",sep=""), sep="", nrows = numRowsToLoad)

# Combine all data sets into single set by combining on columns and then on rows
dataComplete <- rbind(cbind (dataTrainX,dataTrainY,dataTrainSubject),cbind (dataTestX,dataTestY,dataTestSubject))

# Load labels data for features and activities
dataLabels <- read.table(paste(path,"features.txt",sep=""), sep="")
activityLabels <- read.table(paste(path,"activity_labels.txt",sep=""), sep="")

# Apply labels to complete data set & activity labels data set
names(activityLabels) <- c("ActivityID","ActivityDescription")
names(dataComplete) <- dataLabels[,2]
names(dataComplete) [562] <- "ActivityID"
names(dataComplete) [563] <- "SubjectID"

# Merge activity labels data set and complete data set - activity ID is common column
mergedData <- merge(dataComplete,activityLabels)

# Reduce merged data set to only have mean, std deviation features, plus activity description
# and subject ID
mergedData <- mergedData[grepl("mean|std|ActivityDescription|SubjectID",names(mergedData))]

# Summarise data, grouping by activity description and subject ID, apply mean function
summaryData <- mergedData %>% group_by(ActivityDescription,SubjectID) %>% summarise_each(funs(mean))

# Output summary data to disk
write.table(summaryData,"summaryData.txt",row.name=FALSE)