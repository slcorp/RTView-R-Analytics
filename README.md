# RTView - R Analytics

Learn how R can be used to interactively explore relationships in data from your RTView repositories, and provide views that complement those available in RTView Enterprise Monitor.
 
The following examples use a REST interface to pull cached metrics from your RTView dataservers. Query formats are documented in the RTView User Guide, and are simple HTTP GET requests that can be executed in any web browser. RTView caches provide current real-time values for metrics at a minimum, and may be configured to manage historic (time-series) data. As an example, the following REST query fetches current TIBCO EMS metrics from a demo dataserver in the AWS cloud:

http://rtvdemos-163.sl.com/simdata_rtvquery//cache/EmsQueueTotalsByServer/current?fmt=json&cols=time_stamp;URL;pendingMessageCount;inboundMessageRate;outboundMessageRate

For files with a ".R" suffix, load the file into R Studio, select the block of code to be executed, and click the "Run" button. Files ending in ".Rmd" are R markdown files, and are executed by clicking the "Knit" button.

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

In this example, we’ll query RTView using the REST interface for current data in the HostStats cache. The resulting dataframe has 4 rows and 30 columns. A bar chart is provided as an example of using the data.

[currentDataBWMon.R] (http:./samples/currentDataBWMon.R)

### RTView History

REST queries for history are more complex than the previous request for current data, since we must specify a time range and an index (e.g., host, EMS queue, database, etc.) to get a time series for one or more metrics for a specific monitored object. Hence, this example packages all the steps in a re-usable file that you can source into your projects. The following example retrieves and plots one week of history for a Tibco EMS queue.

**File: getHistory.R**

### Histogram

RTView Enterprise Monitor provides heat maps for visualizing status of various metrics for a large number of resources. The colored rectangles can become quite dense as the number of resources “N” increases. Histograms don’t have this limitation, so we can concisely show load for thousands of hosts. This example pulls in current host data from a RTView dataserver, then shows memory used as a percentage in a histogram.

**File: histogramBWMon.R**

### Email Notifications

RTView Enterprise Monitor calls a user-editable script for each alert, so it's easy to craft custom responses to each alertable scenario. In this example, an R script snapshots metrics relevant to the alert instance, generates a plot for easy visualization, and then emails the result. When RTView EM generates an alert, it calls the \rtvapm\common\bin\my_alert_actions.bat(sh) script to perform default actions relevant to the alert. Users may customize this script to add any special processing (eg, email notification). Perform the following steps to start using rich email notifications in your RTView installation.

#### Installation instructions for custom email alert notifications
1) Install R and the packages referenced in the samples\r_alert_handler.R script. 
2) Copy the alert actions script to your project:
cp <path>\rtvapm\common\bin\my_alert_actions.bat(sh) <your project path>\project\servers\central
3) Edit my_alert_actions.bat(sh), adding the following line near the end:
Rscript r_alert_handler.R %DOMAINNAME% %ALERTNAME% %ALERTINDEX% %ALERTID% %ALERTSEVERITY% "%ALERTTEXT%"
4) Edit the samples\r_alert_handler.R script in this repository to set values for the required parameters at the beginning of this script.
5) Copy the r alert handler script and associated Rmd handlers to your project.
cp -r r_alert_handler.R alert_handlers <your project path>\project\servers\central

When the next alert occurs, the r_alert_handler.R script will execute the handler (if it exists) for the given alert type. A sample handler is provided in the alert_handlers directory, along with an html rendering to show what you can expect to appear in the body of the email sent by r_alert_handler.R. 

### Intelligent Alerting

The most basic type of alerting occurs when the current value of a metric exceeds a static threshold. However, alerting in this manner may only indicate a transient stress, so we may additionally require that the metric (either raw or smoothed) exceed the threshold for a certain amount of time. Such triggering rules can greatly reduce the incidence of false alarms, but are unsatisfactory in answering questions like "is the current load normal for this seasonally adjusted point in time". We are interested not only in cases where the key performance indicator (KPI) is not only significantly higher tham expected, but also much lower than expected, as this condition may indicate loss of inputs to an otherwise healthy system (eg, on-line customers are not able to complete orders, credit-card transactions are lagging, etc.) .

To answer such questions, we turn to dynamically computed thresholds. The classic example is “Bollinger Bands”, where the upper and lower bounds are plotted as the moving average for the metric plus or minus a standard deviation (or two). Given these bounding time-series, it is possible to generate alerts when the real-time trend crosses either boundary. Although the calculations to produce these high and low bounds could be done by RTView, this examples demonstrates the basic idea using R. 

The attached R example calculates an expected upper and lower bound for total pending messages queued by a TIBCO EMS server for the next 24 hours. From a technical standpoint, a big problem with modeling the time-series for a KPI is that it's quite often "non-stationary". That is, its statistics (mean and variance) vary with time, and this makes it tricky to determine appropriate upper and lower bounds. Fortunately, R comes to the rescue with a number of packaged methods to help "stationarize" your data. In this example, we remove the trend by a standard technique (differencing), calculate the standard deviation, and then add and subtract it from a smoothed average for the last two weeks to arrive at a suitable high and low bounds for the KPI. 

**File: bollingerBands.R**


