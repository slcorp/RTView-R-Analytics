# Set your working directory
setwd("C:/Users/GitHub/Repositories/RTView-R-Analytics/")

# Read data from your BWMon dataserver
bw <- read.delim("http://myhost:myport/bwmon_rtvquery/cache/HostStats/current?fmt=text")
dim(bw)

# List column names in HostStats cache
names(bw)

#Plot histogram
hist(bw$MemUsedPerCent,breaks=20)
