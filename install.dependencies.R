#!/usr/bin/env Rscript
#-------------------------------------------------------------------------------
# Copyright (c) 2012 University of Illinois, NCSA.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the 
# University of Illinois/NCSA Open Source License
# which accompanies this distribution, and is available at
# http://opensource.ncsa.illinois.edu/license.html
#-------------------------------------------------------------------------------
library(methods)
update.packages(ask=FALSE, checkBuilt=TRUE, repos="http://cran.rstudio.com/")

list.of.required.packages <- c('jsonlite', 'XML', 'reshape', 'ncdf4', 'devtools')
list.of.installed.packages <- installed.packages()[,"Package"]
list.of.new.packages <- list.of.required.packages[!(list.of.required.packages %in% list.of.installed.packages)]

if(length(list.of.new.packages)){
  install.packages(list.of.new.packages, repos="http://cran.rstudio.com/")
}
if(!'ghgvcr' %in% list.of.installed.packages){
  devtools::install_github("ghgvcR", "ebimodeling")
}
