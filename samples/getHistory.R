##
##  Retrieve a time series from an RTView data server
##
#
# Set the working directory so that relative file path in following "source" is found
#setwd("C:/Users/GitHub/Repositories/RTView-R-Analytics/")

# include the "getCacheHistory" function
source("sl_utils.R")

# define a few variables used to query for the RTView history data
columns <- "time_stamp;pendingMessageCount;inboundMessageRate;outboundMessageRate"  # set analysis column
dataserver <- "rtvdemos-163.sl.com"
emsQueueName <- "tcp://VMIRIS1023:7222"

# get EMS queue data; request 7 days of data starting 9 days ago
week <- getCacheHistory(dataserver,"EmsQueueTotalsByServer", "simdata_rtvquery", fval=emsQueueName, dayOffset=9,ndays=7,cols=columns)

# simplify the column names for the plot
colnames(week) <- c("pending","inbound","outbound")

# plot the raw data to see if we got what we expected
# Note that the time scale is in days since Jan 1, 1970.
plot(week,main="EMS Server Metrics for 7 days")
