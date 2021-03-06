# ------------------------------------------------------------------------------
# Simple Shiny template for annotations utils 
# search, select, merge and download prototype 
# ------------------------------------------------------------------------------
usePackage <- function(p) 
{
  if (!is.element(p, installed.packages()[,1]))
    install.packages(p, dep = TRUE)
  require(p, character.only = TRUE)
}
usePackage("dplyr")
usePackage("tidyr")
usePackage("shiny")
usePackage("shinyBS")
usePackage("shinythemes")
usePackage("ggplot2")
usePackage("openxlsx")
usePackage("shinydashboard")
usePackage("jsonlite")
usePackage("data.table")
usePackage("DT")

# source('http://depot.sagebase.org/CRAN.R')
# pkgInstall("synapseClient")
# or for R newer versions pull from git 
library(devtools)
# install_github('Sage-Bionetworks/rSynapseClient', ref='develop')
# install_github("ebailey78/shinyBS")
library(dplyr)
library(tidyr)
library(shiny)
library(shinyBS)
library(shinythemes)
library(openxlsx)
library(jsonlite)
library(synapseClient)
library(shinydashboard)
library(data.table)
library(DT)
# ----------------------------------------------------------------------
# login to synapse 
# syn.login('me@nowhere.com', 'secret', rememberMe = TRUE)
# or caching credentials can also be done from the command line client:
# synapse login -u me@nowhere.com -p secret --rememberMe
# ----------------------------------------------------------------------
synapseLogin()

# ----------------------------------------------------------------------
options(stringsAsFactors = FALSE)

# by replacing the global dat variable
# you may use this app using the standard schema but your own melted data 
queryResult <- synTableQuery('select * from syn10242922')
dat <- as.data.frame(queryResult@values)
print(head(dat))

categories <- lapply(unique(dat$module), function(x) {x})
key <- unique(dat$key)
value <- unique(dat$value)

all.vars <- names(dat)
names(dat) <- c("key", "description", "columnType", "maximumSize", "value", "valueDescription", "source", "module")
dat <- dat %>% mutate_all(as.character)

# Get release version from syanpe table annotations
table <- synGet("syn10242922")
release.version <- annotations(table)$annotationReleaseVersion