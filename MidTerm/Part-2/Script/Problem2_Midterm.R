setwd("/Users/suhaspirankar/Desktop/DataScience/Midterm/Problem2/ad-dataset");
getwd()

#Read content from the date file
mydata=read.table("ad.data",sep=',')

View(mydata)
# make the column numeric
  mydata$V1=as.numeric(mydata$V1)
  mydata$V2=as.numeric(mydata$V2)
  mydata$V3=as.numeric(mydata$V3)
  
# Detecting, filtering outliers and replacing with mean of column
  for(j in 1:3){
    for (i in 1:nrow(mydata)){
      if ((mydata[i,j] < (mean(mydata[[j]])-(1.5)*sd(mydata[[j]]))|
           (mydata[i,j] > (mean(mydata[[j]])+1.5*sd(mydata[[j]]))))) 
      {mydata[i,j]<-mean(mydata[[j]])}
    }
  }
  
#convert  numeric to NA
  mydata$V1[mydata$V1==1]<-NA;
  mydata$V2[mydata$V2==1]<-NA;
  mydata$V3[mydata$V3==1]<-NA;
  
# convert direct missing characters to NA
  mydata[,4]=as.numeric(as.character(mydata[,4]));
  
# Replace NA with Mean
mydata$V1[is.na(mydata$V1)] <- mean(mydata$V1, na.rm = TRUE)
mydata$V2[is.na(mydata$V2)] <- mean(mydata$V2, na.rm = TRUE)
mydata$V3[is.na(mydata$V3)] <- mean(mydata$V3, na.rm = TRUE)
mydata$V4[is.na(mydata$V4)] <- mean(mydata$V4, na.rm = TRUE)

# round the result and make it as interger
mydata$V1=as.integer(round(mydata$V1,digits=1))
mydata$V2=as.integer(round(mydata$V2,digits=1))

mydata$V3=as.integer(round(mydata$V3,digits=1))
mydata$V4=as.integer(round(mydata$V4,digits=1))
 
# factor each column as we need to build a regression
for (i in 4:ncol(mydata)) {
  data[,i]=factor(data[,i]);
}


# Create a new column and if it is ad enter 1 or enter 0
mydata$AdClass=ifelse(mydata$V1559=='ad.',1,0);


# Split the data into train and test

smp_size = floor(0.7 * nrow(mydata))
set.seed(123)
train_ind = sample(seq_len(nrow(mydata)), size = smp_size)
train = mydata[train_ind, ]
test = mydata[-train_ind, ]


# Implement Logistic Regression and build a model using the train data set

Logistic_result=glm(formula=AdClass~V2+V3+V10+V32+V68,data = train,family =binomial)
summary(Logistic_result)

# Predict values so we get the probability
glm.probs=predict(Logistic_result ,type ="response");
summary(glm.probs)

# Generate the values using probability
glm_prediction=ifelse(glm.probs>0.1,"Ad","NoAd");
summary(glm_prediction)

glm_errorrate=sum(test$Predict!=glm_prediction)/length(test$AdClass);
summary(glm_errorrate)

#Predict using Model
glm.probs_newdata=predict(Logistic_result,newdata = test,type ="response");

glm_prediction_newdata=ifelse(glm.probs_newdata>0.1,"Ad.","No Ad.");

PredictOutput_glm=test;
PredictOutput_glm$prediction=glm_prediction_newdata
write.csv(PredictOutput_glm,"final_Output_logistic.csv",na="",row.names = FALSE);
write.csv(test,"test.csv",na="",row.names = FALSE);


#install.packages("caret")
library(lattice)
library(ggplot2)
library(caret)

#Set the cutoff value =0.5
pred <- rep(0,length(glm.probs_newdata))
pred[glm.probs_newdata>=0.5] <- 1
confusionMatrix(test$AdClass,pred )

#ROC curve

install.packages("ROCR")
library("gplots")
library(ROCR)

prediction <- prediction(glm.probs_newdata, test$AdClass)
performance <- performance(prediction, measure = "tpr", x.measure = "fpr")
plot(performance, main="ROC curve", xlab="1-Specificity", ylab="Sensitivity")


#Lift curve
perf = performance(prediction,"lift","rpp")
plot(perf, main="lift curve", colorize=T)


# Beginning of Neural Network

install.packages("neuralnet")
library(MASS);
library(grid);
library(neuralnet);

#Create a neural model
net_result=neuralnet(AdClass~V2+V3+V10+V32+V68,train,hidden = c(5,2,1),threshold = 0.5);

#Plot a neural Model
plot(net_result)

#Compute values using model
net_prediction=compute(net_result,test[,c(2,3,10,32,68)])



#Begenning Tree

install.packages("tree");
library(tree);

#Create a Model
tree_result=tree(AdClass~V2+V3+V10+V32+V68,data = train);

#Plot the model
plot(tree_result)

#check the summary
summary(tree_result)

tree_prediction=predict(tree_result,newdata = test);
tree_MAPE=mean(abs(tree_prediction-test$AdClass)/test$AdClass);
tree_RMS=sqrt(mean((tree_prediction-test$AdClass)^2));
tree_MAE=mean(abs(tree_prediction-test$AdClass));
summary(tree_MAE)
summary(tree_RMS)
summary(tree_MAPE)




# Generate the values using probability
tree_predict=ifelse(tree_prediction>0.1,1,0);


#Predict using Model
tree.probs_newdata=predict(tree_result,test);

tree_prediction_newdata=ifelse(tree_prediction>0.1,1,0);



#install.packages("caret")
library(lattice)
library(ggplot2)
library(caret)

#Set the cutoff value =0.5
pred_tree <- rep(0,length(tree_prediction_newdata))
pred_tree[tree_prediction_newdata>=0.9] <- 1
confusionMatrix(test$AdClass,pred_tree )

#ROC curve

install.packages("ROCR")
library("gplots")
library(ROCR)

prediction1 <- prediction(tree_prediction_newdata, test)
performance1 <- performance(prediction1, measure = "tpr", x.measure = "fpr")
plot(performance1, main="ROC curve", xlab="1-Specificity", ylab="Sensitivity")


#Lift curve
perf = performance(prediction1,"lift","rpp")
plot(perf, main="lift curve", colorize=T)


