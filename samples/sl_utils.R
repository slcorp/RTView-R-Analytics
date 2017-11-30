##############################################################################
#   Example R code for "Analytics with RTView Data using R"
##############################################################################

#  getCurrent queries the RTView REST interface for current data from the given cache.
#
#getCurrent("localhost:8068","VmwVirtualMachines",package="hostbase_rtvquery")

getCacheCurrent <- function(rtvServer, cache, package="emsample_rtvquery", fmt="text", cols="") {
	url <- sprintf("http://%s/%s/cache/%s/current?fmt=%s",rtvServer,package,cache,fmt)
	if( cols != "" )  url <- sprintf("%s&cols=%s",url,cols)
	print(url)
	read.delim(url)     # execute REST query; returns an R dataframe
}


#  getCacheHistory queries the RTView REST interface for history data.
#
#       By default, this function pulls 24 hours of pendingMessageCount
#       data for a given day from the EmsQueueTotalsByServer cache, which  
#       is indexed by URL of the Tibco EMS server; as seen in the function 
#       declaration, the query filter parms (fcol, fval) and cache can be 
#       overridden to retrieve data from other caches.
#
#   Examples:
#       # retrieve history data for the EMS server indexed in the cache by 
#       # URL "tcp://192.168.1.116:7222" on the sixth data prior to "today"
#       h6 <- getHistory("192.168.1.101","EmsQueueTotalsByServer", "emsmon_rtvquery2", "tcp://192.168.1.116:7222",dayOffset=6)
#
getCacheHistory <- function(rtvServer, cache="EmsQueueTotalsByServer", 
						package="emsample_rtvquery", fval, fcol="URL", 
						dayOffset=0, ndays=1, tz_offset=8,
						cols="time_stamp",
						fmt="text", tr=86400) {
    # set up the base URL for the REST query
    base_url <- sprintf("http://%s/%s/cache/%s/history?fmt=%s&cols=%s",rtvServer,package,cache,fmt,cols)
	# create a column filter to retrieve rows for a specified index value
    emsFilter <- sprintf("fcol=%s&fval=%s",fcol,fval)
    
    # calculate begin time in seconds since 1970
    if(dayOffset == 0 && tr != 86400) {
        # caller wants near real-time data
        #te <- as.integer(unclass(Sys.time())) - tz_offset*3600
        timeFilter <- sprintf("tr=%s",tr)
        #timeFilter <- sprintf("tr=%s&te=%s000",tr,te)
        print("set tr only")
        this.frequency <- .1
    } else {
        tb <- (unclass(Sys.Date()) - dayOffset)*86400 + tz_offset*3600
        trr <- tr * ndays
        timeFilter <- sprintf("tr=%s&tb=%s000",trr,tb)
        this.frequency <- 96
    }

    url <- URLencode(paste(base_url,emsFilter,timeFilter,"sqlex=true",sep="&"))
    print(paste(">>>fetching URL: ",url))        # debug
    ret <- read.delim(url, sep="\t")     # execute REST query; returns an R dataframe
    #print(str(ret))
    ret$time_stamp <- as.POSIXct(ret$time_stamp,"%b %d, %Y %I:%M:%S %p",tz="")
    #delta_t <- (as.numeric(ret$time_stamp[2])-as.numeric(ret$time_stamp[1]))
    delta_t <- difftime(ret$time_stamp[2],ret$time_stamp[1],units="secs")
    print(paste("deltat = ", delta_t))
    #print(ret$time_stamp[1])
    #print(ret$time_stamp[length(ret$time_stamp)])
    # calculate end time as an integral number of delta_t time periods
    endtime <- as.numeric(ret$time_stamp[1]) + delta_t * length(ret$time_stamp)
    #ts(ret[,-1], start=as.Date(ret$time_stamp[1]), end=as.Date(ret$time_stamp[length(ret$time_stamp)]), frequency=this.frequency, deltat=delta_t)
    ts(ret[,-1], start=as.numeric(ret$time_stamp[1]), end=endtime, frequency=this.frequency, deltat=delta_t)
    #ts(ret[,-1], start=as.Date(ret$time_stamp[1]), end=endtime, frequency=this.frequency, deltat=delta_t)
    #ts(ret[,-1], start=as.Date(ret$time_stamp[1]), frequency=this.frequency, deltat=delta_t)
}


# get mean and confidence interval
GetCI <- function(x, level=0.95) {
    if(level <= 0 || level >= 1) {
        stop("***The level must be between zero and one!")
    }
    m <- mean(x)
    n <- length(x)
    SE <- sd(x) / sqrt(n)
    upper <- 1-(1-level)/2
    ci <- m + c(-1,1)*qt(upper,n-1)*SE
    return(list(mean=m, se=SE, ci=ci))
}
