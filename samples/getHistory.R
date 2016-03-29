#  getHistory queries the RTView REST interface for history data.
#
#       By default, this function pulls 24 hours of pendingMessageCount
#       data for a given day from the EmsQueueTotalsByServer cache, which  
#       is indexed by URL of the Tibco EMS server. As seen in the function 
#       declaration, the query parms (columns, cache, fcol, and time range tr)
#       can be overridden to retrieve data from other caches.
#
#   Example:
#       # retrieve history data for the EMS server indexed in the cache by 
#       # URL "tcp://192.168.1.116:7222" on the sixth data prior to "today"
#       h6 <- getHistory("192.168.1.101","tcp://192.168.1.116:7222",6)
#
getHistory <- function(rtvServer, fval, dayOffset, tz_offset=8,
                       columns="time_stamp;pendingMessageCount",
                       cache="emsmon_rtvquery2/cache/EmsQueueTotalsByServer/history",
                       fmt="text", fcol="URL", tr=86400) {
  # set up the base URL for the REST query
  base_url <- sprintf("http://%s/%s?fmt=%s&cols=%s&sqlex=true",rtvServer,cache,fmt,columns)
  
  # create a column filter to retrieve rows for a specified index value
  emsFilter <- sprintf("fcol=%s&fval=%s",fcol,fval)
  
  # calculate begin time in seconds since 1970
  tb <- (unclass(Sys.Date()) - dayOffset)*86400 + tz_offset*3600
  timeFilter <- sprintf("tr=%s&tb=%s000",tr,tb)
  
  url <- paste(base_url,emsFilter,timeFilter,sep="&")
  #print(url)		# debug
  read.delim(url)     # execute REST query; returns an R dataframe
}
