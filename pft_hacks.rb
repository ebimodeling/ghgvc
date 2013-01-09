require 'rubygems'
require 'json'

@ecosystems = JSON.parse( File.open( "data/default_ecosystems.json" , "r" ).read )

asdf = @ecosystems[0]

#Hash.try_convert({
#name:string, category:string, T_A:integer, T_E:integer, r:integer, OM_ag:float, OM_root:float, OM_wood:float, OM_litter:float, OM_peat:float, OM_SOM:float, fc_ag_wood_litter:float, fc_root:float, fc_peat:float, fc_SOM:float, Ec_CO2:float, Ec_CH4:float, Ec_N2O:float, k_ag_wood_litter:float, k_root:float, k_peat:float, k_SOM:float, termite:integer, Ed_CO2_ag_wood_litter:float, Ed_CO2_root:float, Ed_CO2_peat:float, Ed_CO2_litter:float, Ed_CH4_ag_wood_litter:float, Ed_CH4_root:float, Ed_CH4_peat:float, Ed_CH4_litter:float, Ed_N2O_ag_wood_litter:float, Ed_N2O_root:float, Ed_N2O_peat:float, Ed_N2O_litter:float, F_CO2:float, F_CH4:float, F_N2O:float, rd:integer, tR:integer, FR_CO2:float, FR_CH4:float, FR_N2O:float, dfc_ag_wood_litter:float, dfc_root:float, dfc_peat:float, dk_ag_wood_litter:float, dk_root:float, dk_peat:float, age_transition:integer, new_F_CO2:float, new_F_CH4:float, new_F_N2O:float, F_anth:float, pft_id:integer, prior_id:integer
#})



asdf.each {|key, value| puts "
  <div class='field'>
    <%= f.label :#{key} %><br />
    <%= f.number_field :#{key}, :value => @ecosystem[\'#{key}\'] %>
  </div>
" }

#for e in 0...@ecosystems[0].length
##  if @ecosystems[e]["category"].to_s == "agroecosystems"
#    puts "#{e} #{@ecosystems[0]["name"]}"
#    #p @ecosystems[e]["category"]
##  end
#end 



#for i in blah
#puts "

#<p>
#  <b>Name:</b>
#  <%= @pft.#{i} %>
#</p>

#"
#end
