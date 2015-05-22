
# 1. Merge Datasets
rm(list=ls())

trdirectory <- "/Data Science/Getting and Cleaning Data/UCI HAR Dataset/train/"
tedirectory <- "/Data Science/Getting and Cleaning Data/UCI HAR Dataset/test/"

X.test <- read.table(paste(getwd(),tedirectory,"X_test.txt", sep=""))
y.test <- read.table(paste(getwd(),tedirectory,"y_test.txt", sep=""))
subject.test <- read.table(paste(getwd(),tedirectory,"subject_test.txt", sep=""))

X.train <- read.table(paste(getwd(),trdirectory,"X_train.txt", sep=""))
y.train <- read.table(paste(getwd(),trdirectory,"y_train.txt", sep=""))
subject.train <- read.table(paste(getwd(),trdirectory,"subject_train.txt", sep=""))

test <- cbind(y.test,subject.test,X.test)
train <- cbind(y.train,subject.train,X.train)

data <- rbind(test,train)


# 4. Label variables

features <- read.table(paste(getwd(),"/Data Science/Getting and Cleaning Data/UCI HAR Dataset/features.txt",sep=""))
colnames(data) <- c("Activity","Subject",as.character(features[[2]]))                         
                         
# 3. Label activities
library(plyr)

activities <- read.table(paste(getwd(),"/Data Science/Getting and Cleaning Data/UCI HAR Dataset/activity_labels.txt",sep=""))
activities[[2]] <- as.character(activities[[2]])
data$Activity <- as.character(data$Activity)

data$Activity <- revalue(data$Activity, c("1"=activities[[2]][[1]],"2"=activities[[2]][[2]],
        "3"=activities[[2]][[3]],"4"=activities[[2]][[4]],"5"=activities[[2]][[5]],
        "6"=activities[[2]][[6]]))

# 2. Extract only mean and sd of observations

means.stds <- grep("mean|std", names(data), value=T)
variables <- c("Activity", "Subject", means.stds)

data.mean.sd <- data[,variables]


# 5. Calculate variable means for each combination of Activity and Subject

library(dplyr)

datagrouped <- group_by(data.mean.sd, Activity, Subject)

summary <- summarise_each(datagrouped, funs(mean))

write.table(summary, file = "./Data Science/Getting and Cleaning Data//tidy_summary.txt")






