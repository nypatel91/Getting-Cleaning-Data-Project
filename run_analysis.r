#setwd("UCI HAR Dataset")

#1. Read in data
#Read in X-dataset
tmp1 <- read.table("train/X_train.txt")
tmp2 <- read.table("test/X_test.txt")
X <- rbind(tmp1,tmp2)

#Read in Y-dataset
tmp1 <- read.table("train/y_train.txt")
tmp2 <- read.table("test/y_test.txt")
Y <- rbind(tmp1,tmp2)

#Read in activity labels
tmp1 <- read.table("train/subject_train.txt")
tmp2 <- read.table("test/subject_test.txt")
Z <- rbind(tmp1,tmp2)


#2. Find interested columns for the X
features <- read.table("features.txt")
select <- grep("mean\\(\\)|std\\(\\)", features[,2])
features_select <- features[select,2]
features_select = gsub('mean', 'Mean', features_select)
features_select = gsub('std', 'Std', features_select)
features_select = gsub('[()-]', '', features_select)
X <- X[,select]
alldata <- cbind(X,Y,Z)

#3. Introduce col. names and labels
colnames(alldata) <- c(features_select,"Activity","Subject")
activity_labels = read.table("activity_labels.txt")
alldata$Activity = factor(alldata$Activity,levels = c(1:6),
                          labels = activity_labels[,2])
#4. Tidy data
library(reshape2)
alldata.melt <- melt(alldata, id = c("Subject","Activity"))
alldata.cast <- dcast(alldata.melt,Activity + Subject ~ variable,mean)

#5 Write the data
write.table(alldata.cast, "tidy.txt", row.names = FALSE, quote = FALSE)

