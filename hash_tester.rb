require 'rubygems'
require 'active_support/core_ext/array/conversions'
require 'json'
require 'cobravsmongoose'



@ecosystems = JSON.parse( File.open( "data/final_ecosystems.json" , "r" ).read )






hash1 = JSON.parse('{"category":"native","T_A":"100","T_E":"50","r":"0","OM_ag":"444","OM_root":"108"}')
hash2 = JSON.parse('{"category":"native","T_A":"100","T_E":"50","r":"0","OM_ag":{"Anderson-Teixeira K and DeLucia EH (2011)":"400","Saatchi S, Harris NL, Brown S, Lefsky M, Mitchard ET (2011)":"800"},"OM_root":"108"}')


# for a given CSEP 
#accepts in the CSEP name
#returns array with all possible options for that CSEP

# swap out values
s000 = "Anderson-Teixeira K and DeLucia EH (2011)"
s001 = "Saatchi S, Harris NL, Brown S, Lefsky M, Mitchard ET (2011)"
# convert hash to array
arr2 = hash2.to_a
# append custom option
arr2 << ["custom","custom"]



#hash2.each do |key, value|
#  puts value.class  
##  if value.class.to_s == "Hash"
#  if value.is_a? Hash
#    puts "############"
#    p value
#  end
#end







