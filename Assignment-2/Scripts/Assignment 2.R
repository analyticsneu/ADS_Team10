#part 1
rawdata=read.csv("NewData.csv");
#install.packages("weatherData");
library(weatherData);
rows_number=nrow(rawdata)/3;
account=rep(rawdata$Account[1],24*rows_number);
date=rep("1",24*rows_number);
kwh=rep(1,24*rows_number);
HOUR=rep(1,24*rows_number);
for(i in 1:rows_number)
{for(j in 1:24)
  {date[(i-1)*24+j]=as.character(rawdata$Date[3*i]);
   kwh[(i-1)*24+j]=sum(rawdata[(i-1)*3+1,(5+(j-1)*12):(16+(j-1)*12)]);
   HOUR[(i-1)*24+j]=j-1;
  }
}
output=data.frame(Account=account,Date=date,kWh=kwh);
output$month=as.numeric(format(as.Date(output$Date,"%m/%d/%Y"),"%m"));
output$day=as.numeric(format(as.Date(output$Date,"%m/%d/%Y"),"%d"));
output$year=as.numeric(format(as.Date(output$Date,"%m/%d/%Y"),"%Y"));
output$hour=HOUR;
output$Day.of.Week=as.POSIXlt(as.Date(output$Date,"%m/%d/%Y"))$wday;
output$weekday=as.numeric(!(output$Day.of.Week==0|output$Day.of.Week==6));
output$Peakhour=as.numeric(output$hour>=7 & output$hour<=18);
output$temperature=rep(1,24*rows_number);
for(i in 1:rows_number){
  temperature=getDetailedWeather("KBOS",as.Date(output$Date[i*24],"%m/%d/%Y"));
  temperature$hour=as.numeric(format(strptime(temperature[,1], "%Y-%m-%d %H:%M:%S"),"%H"))+1;
  for(j in 1:24)
  {if(length(temperature[temperature$hour==j,2])==0){
    output$temperature[(i-1)*24+j]=NA;}
   else{
    output$temperature[(i-1)*24+j]=temperature[temperature$hour==j,2];}
  }
}
#question 1.a

prepareddataset=na.omit(output[,-c(1,2,6)]);
variables_number=ncol(prepareddataset)-1;
Qualitativevaraibles_number=variables_number-1;
prepareddataset$month=factor(prepareddataset$month);
prepareddataset$day=factor(prepareddataset$day);
prepareddataset$hour=factor(prepareddataset$hour);
prepareddataset$Day.of.Week=factor(prepareddataset$Day.of.Week);
prepareddataset$weekday=factor(prepareddataset$weekday);
prepareddataset$Peakhour=factor(prepareddataset$Peakhour);
prepareddataset_with_zero=prepareddataset;
prepareddataset=prepareddataset[prepareddataset$kWh!=0,];
p=rep(0,Qualitativevaraibles_number);
rse=rep(0,2^Qualitativevaraibles_number);
adrsq=rep(0,2^Qualitativevaraibles_number);
rmse=rep(0,2^Qualitativevaraibles_number);
mae=rep(0,2^Qualitativevaraibles_number);
mape=rep(0,2^Qualitativevaraibles_number);
index=0;
for(a in 0:1){
  for(b in 0:1){
    for(c in 0:1){
      for(d in 0:1){
        for(e in 0:1){
          for(f in 0:1){
            index=index+1;
            data.subset=na.omit(prepareddataset[,as.logical(c(1,a,b,c,d,e,f,1))]);
            lm_result=summary(lm(kWh~.,data = data.subset));
            rse[index]=lm_result$sigma;
            adrsq[index]=lm_result$adj.r.squared;
            rmse[index]=sqrt(mean(lm_result$residuals^2));
            mae[index]=mean(abs(lm_result$residuals));
            mape[index]=mean(abs(lm_result$residuals)/data.subset$kWh);
          }
        }
      }
    }
  }
}
bestmodel=which.min(mape)-1;
for (i in 1:6) {
  p[7-i]=bestmodel%%2;
  bestmodel=floor(bestmodel/2);
}
data.subset=na.omit(prepareddataset[,as.logical(c(1,p,1))]);
lm_out=lm(kWh~.,data = data.subset);
lm_result=summary(lm_out);
prediction_non_zero=predict(lm_out,newdata = prepareddataset);
prediction_with_zero=predict(lm_out,newdata = prepareddataset_with_zero);
Non_zero_MAPE=mean(abs(prediction_non_zero-prepareddataset$kWh)/prepareddataset$kWh);
Non_zero_RMS=sqrt(mean((prediction_non_zero-prepareddataset$kWh)^2));
Non_zero_MAE=mean(abs(prediction_non_zero-prepareddataset$kWh));
With_zero_MAPE=mean(abs(prediction_with_zero-prepareddataset_with_zero$kWh)/prepareddataset_with_zero$kWh);
With_zero_RMS=sqrt(mean((prediction_with_zero-prepareddataset_with_zero$kWh)^2));
With_zero_MAE=mean(abs(prediction_with_zero-prepareddataset_with_zero$kWh));
output_1_a=data.frame(x=c('Non zero MAPE','Non zero RMS','Non zero MAE','With zero MAPE','With zero RMS','With zero MAE'),y=c(Non_zero_MAPE,Non_zero_RMS,Non_zero_MAE,With_zero_MAPE,With_zero_RMS,With_zero_MAE));
write.table(output_1_a,"output_1_a.csv",row.names = FALSE,col.names = FALSE,sep=",");

#question 1.b

prepareddataset_b=na.omit(output[,-c(1,2,6)]);
variables_number=ncol(prepareddataset_b)-1;
Qualitativevaraibles_number=variables_number-1;
prepareddataset_b$month=factor(prepareddataset_b$month);
prepareddataset_b$day=factor(prepareddataset_b$day);
prepareddataset_b$hour=factor(prepareddataset_b$hour);
prepareddataset_b$Day.of.Week=factor(prepareddataset_b$Day.of.Week);
prepareddataset_b$weekday=factor(prepareddataset_b$weekday);
prepareddataset_b$Peakhour=factor(prepareddataset_b$Peakhour);
prepareddataset_b_train=prepareddataset_b[prepareddataset_b$kWh!=0,];
prepareddataset_b_predict=prepareddataset_b[prepareddataset_b$kWh==0,];
p=rep(0,Qualitativevaraibles_number);
rse=rep(0,2^Qualitativevaraibles_number);
adrsq=rep(0,2^Qualitativevaraibles_number);
rmse=rep(0,2^Qualitativevaraibles_number);
mae=rep(0,2^Qualitativevaraibles_number);
mape=rep(0,2^Qualitativevaraibles_number);
index=0;
for(a in 0:1){
  for(b in 0:1){
    for(c in 0:1){
      for(d in 0:1){
        for(e in 0:1){
          for(f in 0:1){
            index=index+1;
            if(a+b+c+d+e+f!=0){data.subset=na.omit(prepareddataset_b_train[,as.logical(c(1,a,b,c,d,e,f,0))]);
            lm_result=summary(lm(kWh~.,data = data.subset));
            rse[index]=lm_result$sigma;
            adrsq[index]=lm_result$adj.r.squared;
            rmse[index]=sqrt(mean(lm_result$residuals^2));
            mae[index]=mean(abs(lm_result$residuals));
            mape[index]=mean(abs(lm_result$residuals)/data.subset$kWh);}
            else {
              rse[index]=NA;
              adrsq[index]=NA;
              rmse[index]=NA;
              mae[index]=NA;
              mape[index]=NA;
            }
          }
        }
      }
    }
  }
}
bestmodel=which.min(mape)-1;
for (i in 1:6) {
  p[7-i]=bestmodel%%2;
  bestmodel=floor(bestmodel/2);
}
data.subset=na.omit(prepareddataset_b_train[,as.logical(c(1,p,0))]);
lm_out=lm(kWh~.,data = data.subset);
lm_result=summary(lm_out);
prediction=predict(lm_out,newdata = prepareddataset_b_predict);
prepareddataset_b_predict$kWh=prediction;
prepareddataset_b_filled=rbind(prepareddataset_b_train,prepareddataset_b_predict);
variables_number=ncol(prepareddataset_b_filled)-1;
Qualitativevaraibles_number=variables_number-1;
p=rep(0,Qualitativevaraibles_number);
rse=rep(0,2^Qualitativevaraibles_number);
adrsq=rep(0,2^Qualitativevaraibles_number);
rmse=rep(0,2^Qualitativevaraibles_number);
mae=rep(0,2^Qualitativevaraibles_number);
mape=rep(0,2^Qualitativevaraibles_number);
index=0;
for(a in 0:1){
  for(b in 0:1){
    for(c in 0:1){
      for(d in 0:1){
        for(e in 0:1){
          for(f in 0:1){
            index=index+1;
            data.subset=na.omit(prepareddataset_b_filled[,as.logical(c(1,a,b,c,d,e,f,1))]);
            lm_result=summary(lm(kWh~.,data = data.subset));
            rse[index]=lm_result$sigma;
            adrsq[index]=lm_result$adj.r.squared;
            rmse[index]=sqrt(mean(lm_result$residuals^2));
            mae[index]=mean(abs(lm_result$residuals));
            mape[index]=mean(abs(lm_result$residuals)/data.subset$kWh);
          }
        }
      }
    }
  }
}
bestmodel=which.min(mape)-1;
for (i in 1:6) {
  p[7-i]=bestmodel%%2;
  bestmodel=floor(bestmodel/2);
}
data.subset=na.omit(prepareddataset_b_filled[,as.logical(c(1,p,1))]);
lm_out=lm(kWh~.,data = data.subset);
lm_result=summary(lm_out);
prediction_filled=predict(lm_out,newdata = prepareddataset_b_filled);
prediction_original=predict(lm_out,newdata = prepareddataset_b);
filled_MAPE=mean(abs(prediction_filled-prepareddataset_b_filled$kWh)/abs(prepareddataset_b_filled$kWh));
filled_RMS=sqrt(mean((prediction_filled-prepareddataset_b_filled$kWh)^2));
filled_MAE=mean(abs(prediction_filled-prepareddataset_b_filled$kWh));
original_MAPE=mean(abs(prediction_original-prepareddataset_b$kWh)/prepareddataset_b$kWh);
original_RMS=sqrt(mean((prediction_original-prepareddataset_b$kWh)^2));
original_MAE=mean(abs(prediction_original-prepareddataset_b$kWh));
output_1_b=data.frame(x=c('Filled MAPE','Filled RMS','Filled MAE','Original MAPE','Original RMS','Original MAE'),y=c(filled_MAPE,filled_RMS,filled_MAE,original_MAPE,original_RMS,original_MAE));
write.table(output_1_b,"output_1_b.csv",row.names = FALSE,col.names = FALSE,sep=",");

#question 1.c

#install.packages("zoo");
library("zoo");
prepareddataset_c=na.omit(output[,-c(1,2,6)]);
variables_number=ncol(prepareddataset_c)-1;
Qualitativevaraibles_number=variables_number-1;
prepareddataset_c$month=factor(prepareddataset_c$month);
prepareddataset_c$day=factor(prepareddataset_c$day);
prepareddataset_c$hour=factor(prepareddataset_c$hour);
prepareddataset_c$Day.of.Week=factor(prepareddataset_c$Day.of.Week);
prepareddataset_c$weekday=factor(prepareddataset_c$weekday);
prepareddataset_c$Peakhour=factor(prepareddataset_c$Peakhour);
prepareddataset_c_NAfixed=prepareddataset_c;
prepareddataset_c_NAfixed$kWh=ifelse(prepareddataset_c_NAfixed$kWh==0,NA,prepareddataset_c_NAfixed$kWh);
prepareddataset_c_NAfixed$kWh=na.fill(prepareddataset_c_NAfixed$kWh,"extend");
p=rep(0,Qualitativevaraibles_number);
rse=rep(0,2^Qualitativevaraibles_number);
adrsq=rep(0,2^Qualitativevaraibles_number);
rmse=rep(0,2^Qualitativevaraibles_number);
mae=rep(0,2^Qualitativevaraibles_number);
mape=rep(0,2^Qualitativevaraibles_number);
index=0;
for(a in 0:1){
  for(b in 0:1){
    for(c in 0:1){
      for(d in 0:1){
        for(e in 0:1){
          for(f in 0:1){
            index=index+1;
            data.subset=na.omit(prepareddataset_c_NAfixed[,as.logical(c(1,a,b,c,d,e,f,1))]);
            lm_result=summary(lm(kWh~.,data = data.subset));
            rse[index]=lm_result$sigma;
            adrsq[index]=lm_result$adj.r.squared;
            rmse[index]=sqrt(mean(lm_result$residuals^2));
            mae[index]=mean(abs(lm_result$residuals));
            mape[index]=mean(abs(lm_result$residuals)/data.subset$kWh);
          }
        }
      }
    }
  }
}
bestmodel=which.min(mape)-1;
for (i in 1:6) {
  p[7-i]=bestmodel%%2;
  bestmodel=floor(bestmodel/2);
}
data.subset=na.omit(prepareddataset_c_NAfixed[,as.logical(c(1,p,1))]);
lm_out=lm(kWh~.,data = data.subset);
lm_result=summary(lm_out);
prediction_NAfilled=predict(lm_out,newdata = prepareddataset_c_NAfixed);
prediction_NAnotfilled=predict(lm_out,newdata = prepareddataset_c);
NAfilled_MAPE=mean(abs(prediction_NAfilled-prepareddataset_c_NAfixed$kWh)/prepareddataset_c_NAfixed$kWh);
NAfilled_RMS=sqrt(mean((prediction_NAfilled-prepareddataset_c_NAfixed$kWh)^2));
NAfilled_MAE=mean(abs(prediction_NAfilled-prepareddataset_c_NAfixed$kWh));
NAnotfilled_MAPE=mean(abs(prediction_NAnotfilled-prepareddataset_c$kWh)/prepareddataset_c$kWh);
NAnotfilled_RMS=sqrt(mean((prediction_NAnotfilled-prepareddataset_c$kWh)^2));
NAnotfilled_MAE=mean(abs(prediction_NAnotfilled-prepareddataset_c$kWh));
output_1_c=data.frame(x=c('Filled MAPE','Filled RMS','Filled MAE','Original MAPE','Original RMS','Original MAE'),y=c(NAfilled_MAPE,NAfilled_RMS,NAfilled_MAE,NAnotfilled_MAPE,NAnotfilled_RMS,NAnotfilled_MAE));
write.table(output_1_c,"output_1_c.csv",row.names = FALSE,col.names = FALSE,sep=",");

#question 2

#Among all of the datasets above, the third is picked.
Pickeddataset=prepareddataset_c_NAfixed;
write.csv(Pickeddataset,"Hourly_filled_data.csv",row.names = FALSE);
#install.packages("tree");
#install.packages("neuralnet");
library(tree);
tree_result=tree(kWh~.,data = Pickeddataset);
tree_prediction=predict(tree_result,newdata = Pickeddataset);
tree_MAPE=mean(abs(tree_prediction-Pickeddataset$kWh)/Pickeddataset$kWh);
tree_RMS=sqrt(mean((tree_prediction-Pickeddataset$kWh)^2));
tree_MAE=mean(abs(tree_prediction-Pickeddataset$kWh));
net_MAPE=NA;
net_RMS=NA;
net_MAE=NA;
library(MASS);
library(grid);
library(neuralnet);
#net_result=neuralnet(kWh~temperature,Pickeddataset,hidden = c(10),threshold = 1);
#net_prediction=compute(net_result,Pickeddataset$temperature);
#net_MAPE=mean(abs(net_prediction-Pickeddataset$kWh)/Pickeddataset$kWh);
#net_RMS=sqrt(mean((net_prediction-Pickeddataset$kWh)^2));
#net_MAE=mean(abs(net_prediction-Pickeddataset$kWh));
output_2=data.frame(x=c('Tree MAPE','Tree RMS','Tree MAE','Net MAPE','Net RMS','Net MAE'),y=c(tree_MAPE,tree_RMS,tree_MAE,net_MAPE,net_RMS,net_MAE));
write.table(output_2,"output_2.csv",row.names = FALSE,col.names = FALSE,sep=",");

#question 3
forecast=read.csv("forecastNewData2.csv");
forecastinput=data.frame(Date=forecast$Day);
forecastinput$month=as.numeric(format(as.Date(forecastinput$Date,"%m/%d/%Y"),"%m"));
forecastinput$day=as.numeric(format(as.Date(forecastinput$Date,"%m/%d/%Y"),"%d"));
forecastinput$year=as.numeric(format(as.Date(forecastinput$Date,"%m/%d/%Y"),"%Y"));
forecastinput$hour=forecast$Hour;
forecastinput$Day.of.Week=as.POSIXlt(as.Date(forecastinput$Date,"%m/%d/%Y"))$wday;
forecastinput$weekday=as.numeric(!(forecastinput$Day.of.Week==0|forecastinput$Day.of.Week==6));
forecastinput$Peakhour=as.numeric(forecastinput$hour>=6 & forecastinput$hour<=18);
forecastinput$temperature=forecast$Temp;
write.csv(forecastinput,"forecastInput.csv",na="",row.names = FALSE);
forecastoriginalinput=forecastinput;
forecastinput=forecastinput[,-c(1,4)];
forecastinput$month=factor(forecastinput$month-1);
forecastinput$day=factor(forecastinput$day);
forecastinput$hour=factor(forecastinput$hour);
forecastinput$Day.of.Week=factor(forecastinput$Day.of.Week);
forecastinput$weekday=factor(forecastinput$weekday);
forecastinput$Peakhour=factor(forecastinput$Peakhour);
tree_prediction_on_newdata=predict(tree_result,newdata=forecastinput);
forecastoutput=forecastoriginalinput;
forecastoutput$prediction=tree_prediction_on_newdata;
write.csv(forecastoutput,"forecastoutput2.csv",na="",row.names = FALSE);

#part 2

Pickeddataset$kWh_Class=ifelse(Pickeddataset$kWh>mean(Pickeddataset$kWh),"Above_Normal","Optimal");
Pickeddataset$kWh_Class=factor(Pickeddataset$kWh_Class);
Pickeddataset=Pickeddataset[,-1];
Logistic_result=glm(kWh_Class~.,data = Pickeddataset,family =binomial);
Tree_result=tree(kWh_Class~.,data = Pickeddataset);
glm.probs=predict(Logistic_result ,type ="response");
glm_prediction=ifelse(glm.probs>0.5,"Optimal","Above_Normal");
glm_errorrate=sum(Pickeddataset$kWh_Class!=glm_prediction)/length(Pickeddataset$kWh_Class);
Tree_probs=predict(Tree_result,newdata = Pickeddataset);
Tree_prediction=ifelse(Tree_probs[,2]>0.5,"Optimal","Above_Normal");
Tree_errorrate=sum(Pickeddataset$kWh_Class!=Tree_prediction)/length(Pickeddataset$kWh_Class);
write.table(data.frame(x=c("Logistic Errorrate","Tree Errorrate"),y=c(glm_errorrate,Tree_errorrate)),"ClassificationPerformancemetrics.csv",row.names = FALSE,col.names = FALSE,sep=",");
glm.probs_newdata=predict(Logistic_result,newdata = forecastinput,type ="response");
glm_prediction_newdata=ifelse(glm.probs_newdata>0.5,"Optimal","Above_Normal");
forecastoutput_glm=forecastoriginalinput;
forecastoutput_glm$prediction=glm_prediction_newdata;
write.csv(forecastoutput_glm,"forecastoutput2_logistic.csv",na="",row.names = FALSE);
Tree_probs_newdata=predict(Tree_result,newdata = forecastinput);
Tree_prediction_newdata=ifelse(Tree_probs_newdata[,2]>0.5,"Optimal","Above_Normal");
forecastoutput_tree=forecastoriginalinput;
forecastoutput_tree$prediction=Tree_prediction_newdata;
write.csv(forecastoutput_tree,"forecastoutput2_tree.csv",na="",row.names = FALSE);
