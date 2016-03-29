setwd("C:/Users/GitHub/Repositories/RTView-R-Analytics/")
#########################
#
#  movingAvg calculates a moving average for the input vector x
#           using a window of size "n" (default 5).
#
movingAvg <- function(x,n=5){filter(x,rep(1/n,n), sides=1)}

#########################
#
#  modelData executes a simple model to predict the behavior of a
#       given metric over the next 24 hours.
#
#       Given two time series of samples for a given metric on two days,
#       this function averages the two series, smoothes the result with a
#       moving average (default window is 8 samples). The Standard Deviation
#       is then added and subtracted to the moving average to create the 
#       upper and lower bounds for a Bollinger Band. The results are plotted
#       and optionally saved as a pdf file.
#
modelData <- function(day1, day2, ma_window=8, savePDF=T, modelFile="model.pdf") {
  if(savePDF) pdf(modelFile)  # optionally open a file to store the pdf
  # average the two days of data, smooth the result with a moving average,
  # and then remove any "NA's" introduced by the moving average.
  mavgDay <- na.omit(movingAvg((day1+day2)/2))
  par(mfrow=c(2,1)) # plot two charts; first chart is raw input + smoothed trend
  plot(day1,xlab="Time",ylab="pending messages",main="Days -6 and -13,  Moving Avg")
  points(day2,col=2,pch=2)    # overlay data for second day
  lines(mavgDay,col=3)        # overlay the smoothed moving average
  
  # create Bollinger bounds by biasing the smoothed average up and down
  # by one standard deviation.
  sdDay <- sd(mavgDay)
  upperBound <- mavgDay + sdDay
  lowerBound <- mavgDay - sdDay
  
  # plot the Bollinger Band
  plot(upperBound, ylab="pending messages", main="Bollinger Band", ylim=c(min(lowerBound),max(upperBound)))
  lines(lowerBound,col=3)
  if(savePDF) dev.off()   # close the pdf file.
  
  cbind(upperBound,lowerBound)   # return the Bollinger bounds
}

