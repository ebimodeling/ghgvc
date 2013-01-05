require 'rubygems'
require 'json'

@ecosystems = JSON.parse( File.open( "data/default_ecosystems.json" , "r" ).read )

#asdf = [12,3,4,5]

#for e in 0..asdf.count

#puts e

#end
a=0.5

asdf = ( a.abs > 1) ? ["boreal forest"]:nil

puts asdf

for e in 0...@ecosystems.length
#  if @ecosystems[e]["category"].to_s == "agroecosystems"
    puts "#{@ecosystems[e]["name"]}"
#    p @ecosystems[e]["category"]
#  end
end 

#@global_biome_savanna_num, @global_biome_peat_num, @global_biome_temperate_scrub_num = 2,3,5


#[@global_biome_savanna_num, @global_biome_peat_num, @global_biome_temperate_scrub_num].each do |n|
#    if n != nil && n > 0
#      puts eval(n)
#    end
#end

