#######################################################################
#   R script to generate an email report for an alert.
#
#   set the following constants to send email.
emailServer <- "emailTest.company.com"
recipients  <- c("someone@company.com")  # list of recipients
acctName    <- "company\\someone"        # need a valid email account to send mail
acctPassword <- "password"        # password for email account

# set default location of RTView REST server for data fetched by alert handlers
rtvDataserver <- "rtvdemos-163.sl.com"
rtvquery <- "simdata_rtvquery"

#######################################################################
inputArgs <- commandArgs(trailingOnly = TRUE)
#inputArgs <- c("CENTRAL","VmwVmCpuUtilizationHigh","vSphere2~VMIRIS1061",1035,1,"High Warning Limit exceeded current value: 69.26 limit: 50.0")

source("sl_utils.R")
email_template <- paste("alert_handlers/",inputArgs[2],'.Rmd',sep="")

# ignore alert if there is no handler for it.
if(file_test("-f",email_template)) {

	library(knitr)
	# use knitr to create html report from a R-markdown template
	# make filenames unique to handle alerts concurrently
	# (WARNING: your CPU could become quite busy if there is an "alert storm")
	mdFileName <- paste(inputArgs[2], '_', Sys.getpid(), '.md', sep="")
	htmlFileName <- paste(inputArgs[2], '_', Sys.getpid(), '.html', sep="")
	knit(email_template, output=mdFileName)

	library(markdown)
	markdownToHTML(mdFileName, output=htmlFileName, options="")

	#define function to send email
	Sys.setenv(JAVA_HOME="")
	library(mailR)
	sendMail <- function(sender, recipients, subject, message) {
		send.mail(from = sender,
				  to = recipients,
				  subject = subject,
				  body = message,
				  html = TRUE, inline = TRUE,
				  smtp = list(host.name = emailServer, port = 25, 
							  user.name=acctName, passwd=acctPassword),
				  authenticate = TRUE, #debug = TRUE,
				  send = TRUE)
	}

	message <- paste(readLines(htmlFileName), collapse="\n")

	sendMail("RTView EM <noreply@sl.com>", recipients, 
			 paste("SL RTView EM Alert: ",inputArgs[2],sep=""), message)

	unlink(htmlFileName)   # delete html report
	unlink(mdFileName)   # delete markdown
} else {
    print("no handler")
}
