#Question 1

#####################
#Logistic Regression
#####################


#install.packages("XLConnect") #Install the library for Excel Read
library(XLConnect) 
library(reshape) # Call the library for melt function

#setwd("H:/MS Stuff/NorthEastern Unversity/Curriclum/Summer 2016/Advance Data Sciences/MidTerm/")  # Set the working directory
filePath = "H:/MS Stuff/NorthEastern Unversity/Curriclum/Summer 2016/Advance Data Sciences/MidTerm" # Set the file path
xlsfile <- file.path(filePath,'xls','default of credit card clients.xls')
wk = loadWorkbook("default of credit card clients.xls") 
df = readWorksheet(wk, sheet="Data",startRow = 2)
head(df)

#Inclusion of new field parameters Total Bill Amount and Total Payment done over the period of 6 months
rows_count=(nrow(df))
for (k in 1:rows_count) {
  df$TotalBillAmount[k] <- sum(df$BILL_AMT1[k] + df$BILL_AMT2[k] +df$BILL_AMT3[k]+df$BILL_AMT4[k]+df$BILL_AMT5[k]+df$BILL_AMT6[k])  
  df$TotalPayAmount[k] <- sum(df$PAY_AMT1[k] + df$PAY_AMT2[k] +df$PAY_AMT3[k]+df$PAY_AMT4[k]+df$PAY_AMT5[k]+df$PAY_AMT6[k])  
}

#Inclusion of new parameter which counts the number of frequency with the the indivdual makes payment.This is derived through the pay status for each month 
df$count_2 <- apply(df[7:12],1,function(x) length(which(x==-2)))
df$count_1 <- apply(df[7:12],1,function(x) length(which(x==-1)))
df$count0 <- apply(df[7:12],1,function(x) length(which(x==0)))
df$count1 <- apply(df[7:12],1,function(x) length(which(x==1)))
df$count2 <- apply(df[7:12],1,function(x) length(which(x==2)))
df$count3 <- apply(df[7:12],1,function(x) length(which(x==3)))
df$count4 <- apply(df[7:12],1,function(x) length(which(x==4)))
df$count5 <- apply(df[7:12],1,function(x) length(which(x==5)))
df$count6 <- apply(df[7:12],1,function(x) length(which(x==6)))
df$count7 <- apply(df[7:12],1,function(x) length(which(x==7)))
df$count8 <- apply(df[7:12],1,function(x) length(which(x==8)))
df$count9 <- apply(df[7:12],1,function(x) length(which(x==9)))


#Factoring the default scenario in terms of Yes and No
df$default.payment.next.month <- factor(df$default.payment.next.month,
                           levels=c(0,1),
                           labels=c("No","Yes"))

table(df$default.payment.next.month)

###########################################################
#Sampling of the data to create Train and Test data sets
###########################################################
#75% of the sample size
smp_size <- floor(0.75 * nrow(df))

#Set the seed to make your partition reproductible
set.seed(123)
train_ind <- sample(seq_len(nrow(df)), size = smp_size)

#Split the data into training and testing
train <- df[train_ind, ]
test <- df[-train_ind, ]

#Fit a logistic regression model 
logistic_result <- glm(default.payment.next.month ~ LIMIT_BAL + SEX + EDUCATION + MARRIAGE + AGE + count_2 +count_1+count0+count1+count2+count3+count4+count5+count6+count7+count8+count9+
                         TotalBillAmount+TotalPayAmount ,
                       data=train , family=binomial(link="logit"))
summary(logistic_result)

#Prediction applied using the Train data set model on Test data.
test.probs <- predict(logistic_result, test, type='response')
pred <- rep("No",length(test.probs))

#Set the cutoff value =0.5
pred[test.probs>=0.5] <- "Yes"

#Classification matrix
#install.packages("e1071")
library(caret)
confusionMatrix(test$default.payment.next.month, pred)

#ROC curve
#install.packages("ROCR")
library(ROCR)
prediction <- prediction(test.probs, test$default.payment.next.month)
performance <- performance(prediction, measure = "tpr", x.measure = "fpr")
plot(performance, main="ROC curve", xlab="1-Specificity", ylab="Sensitivity")
abline(a=0,b=1)

#Lift curve
test$probs=test.probs
test$prob=sort(test$probs,decreasing = T)
lift <- lift(default.payment.next.month ~ prob, data = test)
lift
xyplot(lift,plot = "gain")


####################
#Neural Network
####################

library(MASS);
library(grid);
library(neuralnet);

###########################################################
#Sampling of the data to create Train and Test data sets
###########################################################

#75% of the sample size
smp_size <- floor(0.75 * nrow(df))

#Set the seed to make your partition reproductible
set.seed(100)
train_ind <- sample(seq_len(nrow(df)), size = smp_size)

#Split the data into training and testing
train <- df[train_ind, ]
test <- df[-train_ind, ]

head(test)

#factor the preditive variable to 0 and 1 from "No" and "Yes"
train$default.payment.next.month <- factor(train$default.payment.next.month,
                                           levels=c("No","Yes"),
                                           labels=c(0,1))
train$default.payment.next.month <- as.numeric(train$default.payment.next.month)
train$default.payment.next.month <- as.numeric(train$default.payment.next.month-1)

test$default.payment.next.month <- factor(test$default.payment.next.month,
                                          levels=c("No","Yes"),
                                          labels=c(0,1))
test$default.payment.next.month <- as.numeric(test$default.payment.next.month)
test$default.payment.next.month <- as.numeric(test$default.payment.next.month - 1)

#Applied the Neural Network with 3 layers and 5 3 and 2 weighing factor at each level
neural_result =  neuralnet(default.payment.next.month ~ LIMIT_BAL + SEX + EDUCATION + MARRIAGE + AGE +  count_2 +count_1+count0+count1+count2+count3+count4+count5+count6+count7+count8+count9 + TotalBillAmount+TotalPayAmount,
                           data=train ,hidden=c(5,3,2),threshold = 0.5)
plot(neural_result)
summary(neural_result)

net_prediction = compute(neural_result,test[,c(2,3,4,5,6,26,27,28,29,30,31,32,33,34,35,36,37,38,39)]);
check_result <- write.csv(net_prediction,file = "test.csv")
plot(neural_result)

#####################
#Classification Tree
#####################

###########################################################
#Sampling of the data to create Train and Test data sets
###########################################################

#75% of the sample size
smp_size <- floor(0.75 * nrow(df))

#Set the seed to make your partition reproductible
set.seed(101)
train_ind <- sample(seq_len(nrow(df)), size = smp_size)

#Split the data into training and testing
train <- df[train_ind, ]
test <- df[-train_ind, ]

train$default.payment.next.month <- factor(train$default.payment.next.month,
                                           levels=c("No","Yes"),
                                           labels=c(0,1))
train$default.payment.next.month <- as.numeric(train$default.payment.next.month)
train$default.payment.next.month <- as.numeric(train$default.payment.next.month-1)

test$default.payment.next.month <- factor(test$default.payment.next.month,
                                          levels=c("No","Yes"),
                                          labels=c(0,1))
test$default.payment.next.month <- as.numeric(test$default.payment.next.month)
test$default.payment.next.month <- as.numeric(test$default.payment.next.month - 1)


library(tree);
tree_result=tree(default.payment.next.month~LIMIT_BAL + SEX + EDUCATION + MARRIAGE + AGE +  count_2 +count_1+count0+count1+count2+count3+count4+count5+count6+count7+count8+count9 + TotalBillAmount+TotalPayAmount,data = train);
tree_prediction=predict(tree_result,newdata = test);
tree_MAPE=mean(abs(tree_prediction-test$default.payment.next.month)/test$default.payment.next.month);
tree_RMS=sqrt(mean((tree_prediction-test$default.payment.next.month)^2));
tree_MAE=mean(abs(tree_prediction-test$default.payment.next.month));
summary(tree_result)
plot(tree_result)

