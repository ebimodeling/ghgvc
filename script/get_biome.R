#!/usr/bin/env Rscript
library(ghgvcr)

#script args
script_args   <- commandArgs(trailingOnly = TRUE)
if (length(script_args) < 6 | length(script_args) > 7) {
  stop("Incorrect number of arguments.\n
        USAGE: 'get_biome.R <latitude> <longitude> <netcdf_dir> <named_ecosystems> <output_dir> [output_filename] [output_format] [write_data]'\n
        latitude:         The latitude to load data for.
        longitude:        The longitude to load data for.
        named_ecosystem:  Ecosystem defaults file.
        netcdf_dir:       Full path to the netcdf biome data.
        mapdata_dir:      Full path to the map biome data dir.
        output_dir:       Full path to write the biome data to.
        write_data:       OPTIONAL Boolean whether to write data to a file.\n")
}



#write data is true by default.
write_data <- TRUE
if (length(script_args) == 7) {
  write_data <- as.logical(script_args[7])
}

#Get the biome data.
get_biome(script_args[1], #latitude 
          script_args[2], #longitude
          script_args[3], #ecosystem defaults file
          script_args[4], #netcdf directory
          script_args[5], #mapdata directory
          script_args[6], #output directory
          write_data = write_data)



