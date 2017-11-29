##
##  Plot a histogram, % Utilization versus number of hosts
##
#
# Set your working directory
#setwd("C:/Users/GitHub/Repositories/RTView-R-Analytics/")

# Read data from your dataserver
histData <- read.delim("rtvdemos-163.sl.com/simdata_rtvquery/cache/HostStats/current?fmt=text")
str(histData)

#Plot histogram
hist(histData$usedPerCentCpu,breaks=20,col="lightblue",main="Histogram of Host Utilization",xlab="% Usage",ylab="# Hosts")
#hist(histData$MemUsedPerCent,breaks=20,col="lightgreen",main="Histogram of Host Utilization",xlab="% Usage",ylab="# Hosts")
