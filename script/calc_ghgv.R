#!/usr/bin/env Rscript
library(ghgvcr)
library(XML)
library(jsonlite)

#script args
args   <- commandArgs(trailingOnly = TRUE)
in_dir <- args[1]
out_dir <- args[2]

#load configuration
config_file <- file.path(in_dir, "multisite_config.xml")
config <- xmlToList(xmlParse(config_file))

### Run the GHG calculator V2
res <- ghgvc(config, output_dir = out_dir, write_data = TRUE)

### Create a plot of the results
#p <- ghgcv_plot(x, outdir, config$options$T_E)






