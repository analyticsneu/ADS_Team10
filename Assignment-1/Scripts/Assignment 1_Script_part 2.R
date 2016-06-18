#question 1: data cleaning

rawdata=read.csv("NewData.csv");           #part 2 file name change
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
write.csv(output,"dataclean.csv",na="",row.names = FALSE);

#question 2: multi-variable regression

#install.packages("leaps");
library(leaps);
prepareddataset=na.omit(output[,-c(1,2,6)]);                 #part 2 changes
prepareddataset=prepareddataset[prepareddataset$kWh!=0,];
variables_number=ncol(prepareddataset)-1;
Qualitativevaraibles_number=variables_number-1;
prepareddataset$month=factor(prepareddataset$month);
prepareddataset$day=factor(prepareddataset$day);
prepareddataset$hour=factor(prepareddataset$hour);
prepareddataset$Day.of.Week=factor(prepareddataset$Day.of.Week);
prepareddataset$weekday=factor(prepareddataset$weekday);
prepareddataset$Peakhour=factor(prepareddataset$Peakhour);
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
coefs=data.frame(estimation=lm_result$coefficients[,1]);
row.names(coefs)[1]="constant";
output_coefficients=data.frame(x=c("Account.No",row.names(coefs)),y=c(output[1,1],coefs$estimation));
output_performance=data.frame(x=c("Account.No","MAE","MAPE","RMSE"),y=c(output[1,1],mean(abs(lm_result$residuals)),mean(abs(lm_result$residuals)/data.subset$kWh),sqrt(mean(lm_result$residuals^2))));
write.table(output_coefficients,"final_regressionoutputs.csv",na="",row.names = FALSE,col.names = FALSE,sep=",");
write.table(output_performance,"final_performancemetrics.csv",na="",row.names = FALSE,col.names = FALSE,sep=",");

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
write.csv(forecastinput,"final_forecastinput.csv",na="",row.names = FALSE);
forecastinput=forecastinput[,-c(1,4)];
forecastinput$month=factor(forecastinput$month-1);             #changes for part2
forecastinput$day=factor(forecastinput$day);
forecastinput$hour=factor(forecastinput$hour);
forecastinput$Day.of.Week=factor(forecastinput$Day.of.Week);
forecastinput$weekday=factor(forecastinput$weekday);
forecastinput$Peakhour=factor(forecastinput$Peakhour);
data.test=na.omit(forecastinput[,as.logical(c(p,1))]);
prediction=predict(lm_out,newdata = data.test);
forecastoutput=forecastinput;
forecastoutput$prediction_kWh=prediction;
write.csv(forecastoutput,"final_forecastoutput.csv",na="",row.names = FALSE);
