require 'rubygems'
require 'json'

@ecosystems = JSON.parse( File.open( "data/default_ecosystems.json" , "r" ).read )

#asdf = [12,3,4,5]

#for e in 0..asdf.count

#puts e

#end



for e in 0...@ecosystems.length
#  if @ecosystems[e]["category"].to_s == "agroecosystems"
    p @ecosystems[e]["name"]
#  end
end 

