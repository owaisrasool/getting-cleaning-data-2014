# 1. MERGE THE TRAINING AND TEST SETS TO CREATE ONE DATA SET.

# Download and Unzip the Files to your directory

url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(url,destfile="/Users/OwaisRasool/Documents/Coursera/getdata-projectfiles-UCI-HAR-Dataset.zip",method="curl")

unzip("/Users/OwaisRasool/Documents/Coursera/getdata-projectfiles-UCI-HAR-Dataset.zip",exdir="/Users/OwaisRasool/Documents/Coursera/")

# Read in all the files with appropriate column names, renaming them as you go along. Then combine test and training data to create one final 'Data'.

activityType<-read.table("UCI HAR Dataset/activity_labels.txt",header=FALSE,col.names=c("activityId", "activityType"))
features<-read.table("UCI HAR Dataset/features.txt",header=FALSE)
SubjectTrain<-read.table("UCI HAR Dataset/train/subject_train.txt",header=FALSE,col.names=c("subjectId"))
yTrain<-read.table("UCI HAR Dataset/train/y_train.txt",header=FALSE,col.names=c("activityId"))
xTrain<-read.table("UCI HAR Dataset/train/X_train.txt",header=FALSE,col.names=features[,2])
SubjectTest<-read.table("UCI HAR Dataset/test/subject_test.txt",header=FALSE,col.names=c("subjectId"))
xTest<-read.table("UCI HAR Dataset/test/X_test.txt",header=FALSE,col.names=features[,2])
yTest<-read.table("UCI HAR Dataset/test/y_test.txt",header=FALSE,col.names=c("activityId"))

#Combine Training and Test Data

Training<- cbind(yTrain,SubjectTrain,xTrain)
Test<- cbibnd(yTest,SubjectTest,xTest)
Data<- rbind(Training,Test)

# 2. EXTRACT ONLY THE MEASUREMENTS ON MEAN AND STANDARD DEVIATION FOR EACH MEASUREMENT

ColumnNames=colnames(Data)
Data2=Data[(grepl("activity..",ColumnNames) | grepl("subject..",ColumnNames) | grepl("-mean..",ColumnNames) & !grepl("-meanFreq..",ColumnNames) & !grepl("mean..-",ColumnNames) | grepl("-std..",ColumnNames) & !grepl("-std()..-",ColumnNames))==TRUE]

# 3. USE DESCRIPTIVE ACTIVITY NAMES TO NAME THE ACTIVITIES IN THE DATA

Data3=merge(Data2,activityType,by='activityId',all.x=TRUE)

# 4. APPROPRIATELY LABEL THE DATA SET WITH DESCRIPTIVE ACTIVITY NAMES

ColumnNames=colnames(Data3)

#Rename Column Vector

for (i in 1:length(ColumnNames)) 
  {
    ColumnNames[i] = gsub("\\()","",ColumnNames[i])
    ColumnNames[i] = gsub("-std$","StandardDev",ColumnNames[i])
    ColumnNames[i] = gsub("-mean","Mean",ColumnNames[i])
    ColumnNames[i] = gsub("^(t)","time",ColumnNames[i])
    ColumnNames[i] = gsub("^(f)","freq",ColumnNames[i])
    ColumnNames[i] = gsub("([Gg]ravity)","Gravity",ColumnNames[i])
    ColumnNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",ColumnNames[i])
    ColumnNames[i] = gsub("[Gg]yro","Gyroscope",ColumnNames[i])
    ColumnNames[i] = gsub("AccMag","AccMagnitude",ColumnNames[i])
    ColumnNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",ColumnNames[i])
    ColumnNames[i] = gsub("JerkMag","JerkMagnitude",ColumnNames[i])
    ColumnNames[i] = gsub("GyroMag","GyroMagnitude",ColumnNames[i])
  };

#Rename Data with the new cleaned up column names

colnames(Data3)=ColumnNames

#5. CREATE SECOND INDEPENDENT TIDY DATA SET WITH AVERAGE FOR EACH VARIABLE AND SUBJECT

Data4 = Data3[,c(1:563)]
Tidy = aggregate(Data4[,c(3:563)],by=list(activityId=Data4$activityId,subjectId=Data4$subjectId, mean))
Tidy = merge(Tidy,activityType,by='activityId',all.x=TRUE);
write.table(Tidy, 'tidy.txt',row.names=TRUE,sep='\t');
