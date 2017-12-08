##
##  Forecast high and low alert thresholds
##
# Set the working directory
setwd("C:/Users/Charles/git/RTView-R-Analytics/samples")

# include the "getCacheHistory" function
source("sl_utils.R")

library(forecast)

#########################
#
#  movingAvg calculates a moving average for the input vector x
#           using a window of size "n" (default 5).
#
movingAvg <- function(x,n=5){filter(x,rep(1/n,n), sides=1)}

#########################
#
#  forecastAlertThresholds executes a simple model to predict the behavior of a
#       given metric over the next 24 hours.
#
#       Given two time series of samples for a given metric on two days,
#       this function averages the two series, and smoothes the result with a
#       moving average (default window is 8 samples). The Standard Deviation
#       is then added and subtracted to the moving average to create the 
#       upper and lower bounds for a Bollinger Band. 
#
forecastAlertThresholds <- function(day1, day2, ma_window=8) {
    # align the time ranges so that we can average both series
    day_2 <- ts(day2,start=start(day1),end=end(day1),frequency = frequency(day1))
    mavgDay <- na.omit(movingAvg((day1+day_2)/2, n=ma_window))

    # ndiffs tells us how many differences we need to take in order to remove
    # the trend component from our data
    detrended_mavg <- diff(mavgDay,differences=ndiffs(mavgDay))

    # create upper & lower bounds by biasing the smoothed average up and down
    # relative to the standard deviation of the stationarized smoothed data.
    sdDay <- sd(detrended_mavg)
    #print(sdDay)
    upperBound <- mavgDay + 2*sdDay
    lowerBound <- pmax(mavgDay - 2*sdDay,0)     # dont allow series to go negative

    cbind(upperBound,lowerBound,mavgDay)   # return the predictions
}

##################################################################################
# variables for the thresholding forecast.

# query this dataserver for # queued messages in a certain queue
dataserver <- "rtvdemos-163.sl.com"
cacheName <- "EmsQueueTotalsByServer"
filterColumn <- "URL"
filterValue <- "tcp://VMIRIS1023:7222"
columns <- "time_stamp;pendingMessageCount"  # set analysis column
#
#################
#
# To forecast the next day's trend, get same day for the last two weeks.
dayMinus6 <- getCacheHistory(dataserver,cacheName, "simdata2_rtvquery", fcol=filterColumn,fval=filterValue,dayOffset=6,ndays=1,cols=columns)
dayMinus13 <- getCacheHistory(dataserver,cacheName, "simdata2_rtvquery", fcol=filterColumn,fval=filterValue,dayOffset=13,ndays=1,cols=columns)

# forecast the alert thresholds for the next day
thresholds <- forecastAlertThresholds(dayMinus6, dayMinus13)

# plot the forecasted thresholds
thresholds <- ts(thresholds,start=start(thresholds)+7,end=end(thresholds)+7,frequency=frequency(thresholds))
plot(thresholds[,1], ylab="pending messages", main="Dynamic Thresholds for Next Day", ylim=c(min(thresholds[,2]),max(thresholds[,1])))
lines(thresholds[,2])
lines(thresholds[,3],col=3,lty=3)