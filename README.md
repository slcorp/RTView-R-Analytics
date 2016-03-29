# RTView - R Analytics

Learn how R can be used to interactively explore relationships in data from your RTView repositories, and provide views that complement those available in RTView Enterprise Monitor. This will be a gentle introduction to R, with no prior experience assumed.

## System Requirements

* RTView
* R
* R Studio
* Java

## Useful Links

* Download R: http://www.r-project.org/
* Download R Studio: http://www.rstudio.com/
* Download RTView: http://sl.com/evaluation-request/
* Download Java: http://www.oracle.com/technetwork/java/javase/downloads/index.html

## RTView R Examples

For each example listed here, the corresponding code is included in this package for you to test and play with (in this case R files). 

### RTView Current Data

In this example, we’ll query RTView using the REST interface for current data in the HostStats cache. So, the hosts dataframe has 4 rows and 30 columns. The “names” function gives us a list of the column names.

**File name: currentDataBWMon.R**

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

## For More Details on this Sample

RTView Blog: http://sl.com/1700-2/
