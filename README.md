# RTView - R Analytics

Learn how R can be used to interactively explore relationships in data from your RTView repositories, and provide views that complement those available in RTView Enterprise Monitor.
 
The following examples use a REST interface to pull cached metrics from your RTView dataservers. Query formats are documented in the RTView User Guide, and are simple HTTP GET requests that can be executed in any web browser. RTView caches provide current real-time values for metrics at a minimum, and may be configured to manage historic (time-series) data. As an example, the following REST query fetches TIBCO EMS metrics from a demo dataserver in the AWS cloud:

http://rtvdemos-163.sl.com/simdata_rtvquery//cache/EmsQueueTotalsByServer/current?fmt=json&cols=time_stamp;URL;pendingMessageCount;inboundMessageRate;outboundMessageRate


## System Requirements

* RTView		- source for metrics, either your own installed dataservers or demos in the cloud
* R				- R language interpreter and compute engine
* R Studio		- highly recommended IDE for testing and developing your own R applications

## Useful Links

* Download R: http://www.r-project.org/
* Download R Studio: http://www.rstudio.com/
* Download RTView: http://sl.com/evaluation-request/
* Download Java: http://www.oracle.com/technetwork/java/javase/downloads/index.html

SL Blog Article: [Analytics on RTView Data Using R](http://sl.com/1700-2/)


### RTView Current Data

In this example, we’ll query RTView using the REST interface for current data in the HostStats cache. The resulting dataframe has 4 rows and 30 columns. 

**File name:** [currentDataBWMon.R] (samples/currentDataBWMon.R)

### RTView History

REST queries for history will necessarily be more complex, as we have to include parameters to specify an index for a specific object (e.g., host, EMS queue, database, etc.) and a time range. Hence, we’ll package all the steps in a re-usable R function. The following getHistory function can be pasted into your choice of text editor, and then stored as a file (“getHistory.R”) in your current R working directory. Use the source function as follows to bring the file into your R execution environment.

**File: getHistory.R**

### Histogram

RTView Enterprise Monitor provides heat maps for visualizing status of various metrics for a large number of resources. This visualization technique subsets valuable screen real estate and can become quite dense as the number of resources “N” increases. Histograms don’t have this limitation, so we can concisely show load for thousands of hosts. First, we’ll pull in current data for a RTView dataserver, then show memory used percentage in a histogram.

**File: histogramBWMon.R**

### Calculating Bollinger Bands

This example helps us to compute and display upper and lower bounds for a given metric. The classic example is “Bollinger Band” plots, where the upper and lower bounds are plotted as the moving average for the metric plus or minus a standard deviation. A related question is, given such a plot, is it possible to generate alerts when the real-time trend crosses a boundary, which is generally interpreted as over-bought or over-sold in the context of stock trades. The answer to both questions is “Yes!” Although the calculations can be done by RTView, we will show them in R. 

As a use case for this exercise, the goal will be to calculate an upper and lower bound for total pending messages queued by a TIBCO EMS server over the next 24 hours using Bollinger’s method. 

**File: bollingerBands.R**


