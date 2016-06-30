#input='.../Hubway/hubway_2011_07_through_2013_11'
input='H:/MS Stuff/NorthEastern Unversity/Curriclum/Summer 2016/Advance Data Sciences/Power BI/hubway_2011_07_through_2013_11/'
setwd(input)

stations=read.csv('hubway_stations.csv')
trips=read.csv('hubway_trips.csv')

# clean data - there are negative values for the duration which are removed 
trips_2=trips[which(trips$duration>=0),]

#Removing the outlier of the data
# remove clock resets (if trip was less than 6 minutes and start/ended at same station)
p1=as.vector(quantile(trips_2$duration,c(.01)))
trips_3=trips_2[which(trips_2$duration>=p1 & trips_2$strt_statn!=trips_2$end_statn),]
# remove outrageously high trips. anything above 99% percentile:
p9=as.vector(quantile(trips_3$duration,c(.99)))
trips_4=trips_3[which(trips_3$duration<=p9),]

write.csv(trips_4,"hubway_trips_cleaned.csv",na="",row.names = TRUE);
