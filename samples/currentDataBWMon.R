# Set the working directory
#setwd("C:/Users/GitHub/Repositories/RTView-R-Analytics/")

# Read RTView cache data
hosts <- read.delim("http://rtvdemos-163.sl.com/simdata_rtvquery/cache/HostStats/current?fmt=text")
str(hosts)

#List column names from HostStats
#names(hosts)
