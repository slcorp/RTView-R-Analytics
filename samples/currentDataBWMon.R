# Set the working directory
setwd("C:/Users/GitHub/Repositories/RTView-R-Analytics/")

# Read RTView cache data
hosts <- read.delim("http://myhost:myport/bwmon_rtvquery/cache/HostStats/current?fmt=text")
dim(hosts)

#List column names from HostStats
names(hosts)
