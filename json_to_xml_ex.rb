require 'rubygems'
require 'active_support/core_ext/array/conversions'
require 'json'
require 'cobravsmongoose'

@ecosystems = JSON.parse( File.open( "data/default_ecosystems.json" , "r" ).read )
@name_indexed_ecosystems = JSON.parse( File.open( "data/name_indexed_ecosystems.json" , "r" ).read )



# formating operations
def convert_single_level_hash_to_xml( name, b )
  # each ecosystem is labled within an opening <pft> and closing </pft> tag
  xml_string = "<pft>"
  xml_string << "\n\t<name>#{name}</name>\n"
  b.each do |key, value|
    # if its not a string make it one
    if b[key].class.to_s != "String"
      b[key] = b[key].to_s
    end
    
    # rework data to badgerfish convention
    # http://badgerfish.ning.com/
    b[key] = { "$" => b[key] }
    hash = { "#{key}" => b[key] }
    p hash
    
    # parse into XML string
    xml = CobraVsMongoose.hash_to_xml(hash)
    xml_string << "\t" << xml << "\n"
  end
  xml_string << "</pft>\n"
end

## Fires off the XML converting process
## Step through each entry of the name-indexed input hash
## and feed in a key like "cars" and the input hash {"domestic"=>"ford","foreign"=>"bugatti"}
## ex = '{"cars"=>{"domestic"=>"ford","foreign"=>"bugatti"},"motorcycles"=>{"domestic"=>"buell","foreign"=>"suzuki"}}'
@name_indexed_ecosystems.each do |key, value|
  file_string = ""
  file_string << convert_single_level_hash_to_xml( key, value )  
  File.open("config.xml", 'a') { |file| file.write( file_string ) }
end

