require "rubygems"
require "numru/netcdf"



@global_biome_marsh = NumRu::NetCDF.open("netcdf/GCS/biomes/MarshAndSwampland.nc")

@global_biome_marsh_num = @global_biome_marsh.var("Mrsh_Swmp")[390,83,0,0][0]

p @global_biome_marsh.var_names[-1]#.to_s#.split("=")[-1].to_s




#@global_biome_marsh.var("Mrsh_Swmp").get.length
#@global_biome_marsh.var("Mrsh_Swmp").dim(0)


#puts @global_biome_marsh.var("Mrsh_Swmp").get[0..5,10]#[0]

#puts @global_biome_marsh.var("Mrsh_Swmp")
#puts @global_biome_marsh.var("Mrsh_Swmp").get.min
#puts @global_biome_marsh.var("Mrsh_Swmp").get.max


# http://www.andrewsturges.com/2011/04/using-rubynetcdf-to-read-netcdf-files.html

@dims, @dims['lat'], @dims['lng'] = {}, @global_biome_marsh.var("lat"), @global_biome_marsh.var("lng")


puts "    ## Lon"
puts @dims['lng'].get.shape # max i value
puts @dims['lng'].get.min
puts @dims['lng'].get.max

puts "    ## Lat"
puts @global_biome_marsh.var("lat").get.shape # max j value
puts @global_biome_marsh.var("lat").get.min
puts @global_biome_marsh.var("lat").get.max




#var_temp = file1.var("T") # open variable
#temp = var_temp.get # get values of variable
#p temp # show the values
#p temp[0..4,10,true] # show the part of values






