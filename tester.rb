require 'rubygems'
require 'active_support/core_ext/array/conversions'
require 'json'
require 'cobravsmongoose'

@ecosystems = JSON.parse( File.open( "data/default_ecosystems.json" , "r" ).read )
@name_indexed_ecosystems = JSON.parse( File.open( "data/name_indexed_ecosystems.json" , "r" ).read )

ex_hash = @name_indexed_ecosystems




#insert object as ruby hash



b = JSON.parse('{"category":"native","T_A":100,"T_E":50,"r":0,"OM_ag":444,"OM_root":108,"OM_wood":0,"OM_litter":0,"OM_peat":1388.889,"OM_SOM":88.96552,"fc_ag_wood_litter":0.5,"fc_root":0,"fc_peat":0,"fc_SOM":0,"Ec_CO2":35.909,"Ec_CH4":0.07,"Ec_N2O":0.0059,"k_ag_wood_litter":0.167,"k_root":0.04,"k_peat":0.02,"k_SOM":0.4,"termite":3,"Ed_CO2_ag_wood_litter":41.66667,"Ed_CO2_root":41.66667,"Ed_CO2_peat":45,"Ed_CO2_litter":48.33333,"Ed_CH4_ag_wood_litter":0.0275,"Ed_CH4_root":0,"Ed_CH4_peat":0,"Ed_CH4_litter":0,"Ed_N2O_ag_wood_litter":0,"Ed_N2O_root":0,"Ed_N2O_peat":0.013645,"Ed_N2O_litter":0,"F_CO2":-443.333,"F_CH4":9.877813,"F_N2O":0.017103,"rd":0,"tR":-9999,"FR_CO2":-9999,"FR_CH4":-9999,"FR_N2O":-9999,"dfc_ag_wood_litter":0.5,"dfc_root":0,"dfc_peat":0,"dk_ag_wood_litter":0.167,"dk_root":0.02,"dk_peat":0.02,"age_transition":-9999,"new_F_CO2":-9999,"new_F_CH4":-9999,"new_F_N2O":-9999,"F_anth":0}')

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

# step through each entry of the name-indexed input hash
#ex = '{"cars":{"domestic":"ford","foreign":"bugatti"},"motorcycles":{"domestic":"buell","foreign":"suzuki"}}'
@name_indexed_ecosystems.each do |key, value|
  file_string = ""
  file_string << convert_single_level_hash_to_xml( key, value )  
  File.open("config.xml", 'a') { |file| file.write( file_string ) }
end




puts "############"
#p b
#d = b.to_json
#p d

j = '{"T_A":"100"}'
#p CobraVsMongoose.json_to_xml(j)
# => <alice charlie='david'>bob</alice>

#h = { "T_A" => { "$" => "100" } }
h = {"category"=>{"$"=>"native"}, "T_A"=>{"$"=>"100"}}
#p CobraVsMongoose.hash_to_xml(h)
# => <alice charlie='david'>bob</alice>

hash = { "alice" => { "$" => "bob", "@charlie" => "david" } }
#puts CobraVsMongoose.hash_to_xml(hash)
# => <alice charlie='david'>bob</alice>





#d = JSON.parse(a)
#p d["tropical peat forest"]

#my_xml = JSON.parse(a).to_xml(:root => :my_root)

## WORKS
#  my_xml = JSON.parse( File.open( "data/default_ecosystems.json" , "r" ).read ).to_xml()
#  ## This is what well end up using
#  hash = { "alice" => { "$" => "bob", "@charlie" => "david" } }
#  hash = {"alice" => {"$" => "bob"}}
#  my_xml = CobraVsMongoose.json_to_xml(a)
#  p my_xml

#<alice charlie='david'>bob</alice>
# => <alice charlie='david'>bob</alice>


#p Hash.from_xml('<variable type="product_code">5</variable>').to_json

#my_xml = JSON.parse('[{"variable":"5"}]').to_xml(:root => :my_root, :type => nil)

#File.open("dingo", 'w') { |file| file.write( my_xml) }

#b = '{"bingo":{},"bango":{}}'
#j = JSON.parse(b)
#b.to_xml(:root => :my_root)

#b = '{
#  "bingo":{},
#  "bango":{}
#}'


#c = JSON.parse(b)
#p c.class

#["":{},]
 



#asdf = [12,3,4,5]
#for e in 0..asdf.count

#puts e

#end
a=0.5

asdf = ( a.abs > 1) ? ["boreal forest"]:nil

puts asdf

for e in 0...@ecosystems.length
#  if @ecosystems[e]["category"].to_s == "agroecosystems"
#    puts "#{@ecosystems[e]["name"]}"
#      p @ecosystems[e]["name"].include?("marsh & swamp")
#    p @ecosystems[e]["category"]
#  end
end 

#p @ecosystems.class
#p @ecosystems.select {|k| k["name"] == "marsh & swamp"}
#level_2_employees = infoHash["employee"].select {|k| k["level"] == 2}

#@global_biome_savanna_num, @global_biome_peat_num, @global_biome_temperate_scrub_num = 2,3,5


#[@global_biome_savanna_num, @global_biome_peat_num, @global_biome_temperate_scrub_num].each do |n|
#    if n != nil && n > 0
#      puts eval(n)
#    end
#end


a ='[{"tropical peat forest":{"category":"native","T_A":100,"T_E":50,"r":0,"OM_ag":444,"OM_root":108,"OM_wood":0,"OM_litter":0,"OM_peat":1388.889,"OM_SOM":88.96552,"fc_ag_wood_litter":0.5,"fc_root":0,"fc_peat":0,"fc_SOM":0,"Ec_CO2":35.909,"Ec_CH4":0.07,"Ec_N2O":0.0059,"k_ag_wood_litter":0.167,"k_root":0.04,"k_peat":0.02,"k_SOM":0.4,"termite":3,"Ed_CO2_ag_wood_litter":41.66667,"Ed_CO2_root":41.66667,"Ed_CO2_peat":45,"Ed_CO2_litter":48.33333,"Ed_CH4_ag_wood_litter":0.0275,"Ed_CH4_root":0,"Ed_CH4_peat":0,"Ed_CH4_litter":0,"Ed_N2O_ag_wood_litter":0,"Ed_N2O_root":0,"Ed_N2O_peat":0.013645,"Ed_N2O_litter":0,"F_CO2":-443.333,"F_CH4":9.877813,"F_N2O":0.017103,"rd":0,"tR":-9999,"FR_CO2":-9999,"FR_CH4":-9999,"FR_N2O":-9999,"dfc_ag_wood_litter":0.5,"dfc_root":0,"dfc_peat":0,"dk_ag_wood_litter":0.167,"dk_root":0.02,"dk_peat":0.02,"age_transition":-9999,"new_F_CO2":-9999,"new_F_CH4":-9999,"new_F_N2O":-9999,"F_anth":0}} ,{"asdf":{}}]'

#a = '{"tropical peat forest"=>{"category"=>"native","T_A"=>100,"T_E"=>50,"r"=>0,"OM_ag"=>444,"OM_root"=>108,"OM_wood"=>0,"OM_litter"=>0,"OM_peat"=>1388.889,"OM_SOM"=>88.96552,"fc_ag_wood_litter"=>0.5,"fc_root"=>0,"fc_peat"=>0,"fc_SOM"=>0,"Ec_CO2"=>35.909,"Ec_CH4"=>0.07,"Ec_N2O"=>0.0059,"k_ag_wood_litter"=>0.167,"k_root"=>0.04,"k_peat"=>0.02,"k_SOM"=>0.4,"termite"=>3,"Ed_CO2_ag_wood_litter"=>41.66667,"Ed_CO2_root"=>41.66667,"Ed_CO2_peat"=>45,"Ed_CO2_litter"=>48.33333,"Ed_CH4_ag_wood_litter"=>0.0275,"Ed_CH4_root"=>0,"Ed_CH4_peat"=>0,"Ed_CH4_litter"=>0,"Ed_N2O_ag_wood_litter"=>0,"Ed_N2O_root"=>0,"Ed_N2O_peat"=>0.013645,"Ed_N2O_litter"=>0,"F_CO2"=>-443.333,"F_CH4"=>9.877813,"F_N2O"=>0.017103,"rd"=>0,"tR"=>-9999,"FR_CO2"=>-9999,"FR_CH4"=>-9999,"FR_N2O"=>-9999,"dfc_ag_wood_litter"=>0.5,"dfc_root"=>0,"dfc_peat"=>0,"dk_ag_wood_litter"=>0.167,"dk_root"=>0.02,"dk_peat"=>0.02,"age_transition"=>-9999,"new_F_CO2"=>-9999,"new_F_CH4"=>-9999,"new_F_N2O"=>-9999,"F_anth"=>0},"asdf"=>{}}'

a ='{"tropical peat forest":{"category":"native","T_A":100,"T_E":50,"r":0,"OM_ag":444,"OM_root":108,"OM_wood":0,"OM_litter":0,"OM_peat":1388.889,"OM_SOM":88.96552,"fc_ag_wood_litter":0.5,"fc_root":0,"fc_peat":0,"fc_SOM":0,"Ec_CO2":35.909,"Ec_CH4":0.07,"Ec_N2O":0.0059,"k_ag_wood_litter":0.167,"k_root":0.04,"k_peat":0.02,"k_SOM":0.4,"termite":3,"Ed_CO2_ag_wood_litter":41.66667,"Ed_CO2_root":41.66667,"Ed_CO2_peat":45,"Ed_CO2_litter":48.33333,"Ed_CH4_ag_wood_litter":0.0275,"Ed_CH4_root":0,"Ed_CH4_peat":0,"Ed_CH4_litter":0,"Ed_N2O_ag_wood_litter":0,"Ed_N2O_root":0,"Ed_N2O_peat":0.013645,"Ed_N2O_litter":0,"F_CO2":-443.333,"F_CH4":9.877813,"F_N2O":0.017103,"rd":0,"tR":-9999,"FR_CO2":-9999,"FR_CH4":-9999,"FR_N2O":-9999,"dfc_ag_wood_litter":0.5,"dfc_root":0,"dfc_peat":0,"dk_ag_wood_litter":0.167,"dk_root":0.02,"dk_peat":0.02,"age_transition":-9999,"new_F_CO2":-9999,"new_F_CH4":-9999,"new_F_N2O":-9999,"F_anth":0}}'


h = {"category"=>"native","T_A"=>"100","T_E"=>"50","r"=>"0","OM_ag"=>"444","OM_root"=>"108","OM_wood"=>"0","OM_litter"=>"0","OM_peat"=>"1388.889","OM_SOM"=>"88.96552","fc_ag_wood_litter"=>"0.5","fc_root"=>"0","fc_peat"=>"0","fc_SOM"=>"0","Ec_CO2"=>"35.909","Ec_CH4"=>"0.07","Ec_N2O"=>"0.0059","k_ag_wood_litter"=>"0.167","k_root"=>"0.04","k_peat"=>"0.02","k_SOM"=>"0.4","termite"=>"3","Ed_CO2_ag_wood_litter"=>"41.66667","Ed_CO2_root"=>"41.66667","Ed_CO2_peat"=>"45","Ed_CO2_litter"=>"48.33333","Ed_CH4_ag_wood_litter"=>"0.0275","Ed_CH4_root"=>"0","Ed_CH4_peat"=>"0","Ed_CH4_litter"=>"0","Ed_N2O_ag_wood_litter"=>"0","Ed_N2O_root"=>"0","Ed_N2O_peat"=>"0.013645","Ed_N2O_litter"=>"0","F_CO2"=>"-443.333","F_CH4"=>"9.877813","F_N2O"=>"0.017103","rd"=>"0","tR"=>"-9999","FR_CO2"=>"-9999","FR_CH4"=>"-9999","FR_N2O"=>"-9999","dfc_ag_wood_litter"=>"0.5","dfc_root"=>"0","dfc_peat"=>"0","dk_ag_wood_litter"=>"0.167","dk_root"=>"0.02","dk_peat"=>"0.02","age_transition"=>"-9999","new_F_CO2"=>"-9999","new_F_CH4"=>"-9999","new_F_N2O"=>"-9999","F_anth"=>"0"}

