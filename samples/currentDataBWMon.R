# Set the working directory
#setwd("C:/Users/GitHub/Repositories/RTView-R-Analytics/")

# Read RTView cache data
hosts <- read.delim("http://rtvdemos-163.sl.com/simdata_rtvquery/cache/HostStats/current?fmt=text")
str(hosts)

#List column names from HostStats
#names(hosts)

# show the current host CPU utilization in a bar chart.
# first, set a wide left margin so that the host names are not truncated.
par(mai=c(1,2,1,1))
barplot(hosts$userPerCentCpu,names=hosts$hostname,horiz=TRUE,main="Host %CPU",las=1)


# try the following to more easily view your host data:
edit(hosts)
