library(knitr)
library(rmarkdown)
library(dplyr)
library(plotly)
#read data
rawStorm <- read.csv("repdata_data_StormData.csv.bz2",encoding = "UTF-8")
str(rawStorm )

#### read only entype fatalities injuries as our dataset 
data<-rawStorm [,c("EVTYPE","FATALITIES",
                   "INJURIES", "PROPDMG",
                  "CROPDMG")]
str(data)
data<-data[1:368799,]
### change data type from chr to numeric
data$FATALITIES<-as.numeric(data$FATALITIES)
data$INJURIES<-as.numeric(data$INJURIES)
data<-mutate(data,health=INJURIES+FATALITIES)
#change data type from factor to numeric
#group by our data by evtype
data %>% group_by(EVTYPE)%>%summarise_all(funs(sum))
head(data[order(data$INJURIES)])
injuries_data<-data[,c(1,3)]
#######
sorted <- group_by(data,EVTYPE)
sumvalues <- summarize(sorted,SumFatal=sum(FATALITIES,na.rm=TRUE),SumInJu=sum(INJURIES,na.rm=TRUE))

nam <- head(sumvalues[order(sumvalues$SumFatal,decreasing=TRUE),]$EVTYPE,10) #top five fatality events
nam2 <- head(sumvalues[order(sumvalues$SumInJu,decreasing=TRUE),]$EVTYPE,10) #top five injury events
