#######################################################################
#   R script to generate an email report for an alert.
#
#   set the following constants to send email.
emailServer <- "192.9.200.21"
recipients  <- c("ckominczak@sl.com")  # list of recipients
acctName    <- "sl\\ckominczak"        # need a valid email account to send mail
acctPassword <- "myAcc0unt"           # password for email account

# set location of RTView REST server for data fetched by template
rtviewRestServer <- "localhost:8068"
#######################################################################

source("sl_utils.R")
inputArgs <- commandArgs(trailingOnly = TRUE)
tod <- Sys.time()

library(knitr)
# use knitr to create html report from a R-markdown template
mdFileName <- paste('sample_report_', Sys.getpid(), '.md', sep="")
htmlFileName <- paste('sample_report_', Sys.getpid(), '.html', sep="")
knit('sample_report.Rmd', output=mdFileName)
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
         paste("EM Alert: ",inputArgs[2],sep=""), message)

unlink(htmlFileName)   # delete html report
unlink(mdFileName)   # delete markdown
