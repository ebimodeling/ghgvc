#!/usr/bin/env Rscript
library("devtools")
library("ghgvcr")
library("XML")
library("jsonlite")
# options(warn=FALSE)

#script args
script_args   <- commandArgs(trailingOnly = TRUE)
if (length(script_args) < 6 | length(script_args) > 7) {
  stop("Incorrect number of arguments.\n
        USAGE: 'get_biome.R <latitude> <longitude> <netcdf_dir> <named_ecosystems> <output_dir> [output_filename] [output_format] [write_data]'\n
        latitude:         The latitude to load data for.
        longitude:        The longitude to load data for.
        named_ecosystem:  Ecosystem defaults file.
        netcdf_dir:       Full path to the netcdf biome data.
        map_dir:          Full path to the map biome data dir.
        output_dir:       Full path to write the biome data to.
        output_filename:  File name of file
        output_format:    Format (json or csv)
        write_data:       OPTIONAL Boolean whether to write data to a file.\n")
}

#write data is true by default.
write_data <- TRUE
if (length(script_args) == 9) {
  write_data <- as.logical(script_args[9])
}

latitude <- script_args[1]
longitude <- script_args[2]
ecosystem_defaults <- script_args[3]
netcdf_dir <- script_args[4]
map_dir <- script_args[5]
output_dir <- script_args[6]
output_filename <- "biome" # script_args[7]
output_format <- "json" # script_args[8]

#Get the biome data.
get_biome(latitude, longitude, ecosystem_defaults, netcdf_dir, map_dir, output_dir, output_filename, output_format, write_data)
