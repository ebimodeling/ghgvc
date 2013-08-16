require "numru/netcdf"
require "cobravsmongoose"
require "json"

class WorkflowsController < ApplicationController
  # GET /workflows
  # GET /workflows.json
  def index
    @workflows = Workflow.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @workflows }
    end
  end

  # GET /workflows/1
  # GET /workflows/1.json
  def show
    @workflow = Workflow.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @workflow }
    end
  end
  
  def create_config_input
    if Rails.env == "development"
        multisite_config_path = "/home/thrive/rails_projects/ghgvcR/inst/multisite_config.xml"
        ghgvcR_instantiation_path = "/home/thrive/rails_projects/ghgvcR/"
        ghgvcR_output_path = "/home/thrive/rails_projects/ghgvcR/inst/extdata/output.json"
    end
    if Rails.env == "production"
        multisite_config_path = "/home/ubuntu/ghgvcR/inst/multisite_config.xml"
        ghgvcR_instantiation_path = "/home/ubuntu/ghgvcR/"
        ghgvcR_output_path = "/home/ubuntu/ghgvcR/inst/extdata/output.json"
    end
  
    @ecosystems = params[:ecosystems]
    @biophys_workaround = []
    
    def hax( name, csep_list )
      biophys_values = {}
      csep_list.each do |key, value|        
        

        # Value comes in as a hash with its source attached
        # we need to isolate the single value
        isolated_value = value.to_a[0][1]

        ## Checking sanity        
        raise "ERROR: Expecting superclass to be Hash \n\t... evaluted as #{csep_list.class.superclass}" unless csep_list.class.superclass.to_s == "Hash"     
        raise "ERROR: Expecting a String got a #{isolated_value.class}" unless isolated_value.class.to_s == "String"     

        # Kludgy biophysical workaround
        if key == "latent"
          biophys_values['latent'] = {}
          biophys_values['latent']['input'] = isolated_value
        end

        if key == "sw_radiative_forcing"
          biophys_values['radiative'] = {}
          biophys_values['radiative']['input'] = isolated_value
        end       

      end
      
      return biophys_values
    end
    
    # Example call
    # convert_single_level_hash_to_xml ("Desert", {"OM_ag"=>{"Anderson-Teixeira and DeLucia (2011)"=>"444.0"}, "OM_root"=>{"Anderson-Teixeira and DeLucia (2011)"=>"108.0"}} )    
    def convert_single_level_hash_to_xml( name, csep_list )
      # each ecosystem is labled within an opening <pft> and closing </pft> tag
      xml_string = "\t<pft>"
      xml_string << "\n\t\t<name>#{name}</name>\n"
  
      csep_list.each do |key, value|        
        # Value comes in as a hash with its source attached
        # we need to isolate the single value
        
        isolated_value = value.to_a[0][1]

        ## Checking sanity        
        raise "ERROR: Expecting superclass to be Hash \n\t... evaluted as #{csep_list.class.superclass}" unless csep_list.class.superclass.to_s == "Hash"     
        raise "ERROR: Expecting a String got a #{isolated_value.class}" unless isolated_value.class.to_s == "String"     

        # rework data to badgerfish convention
        # http://badgerfish.ning.com/
        csep_list[key] = { "$" => isolated_value }
        hash = { "#{key}" => csep_list[key] }
        
        # parse into XML string
        xml = CobraVsMongoose.hash_to_xml(hash)
        xml_string << "\t\t" << xml << "\n"
      end
      xml_string << "\t</pft>\n"
    end

    # Clean the file for testing purposes
    File.open(multisite_config_path, 'w') { |file| file.write("") }
    # Write in opening header
    opening_header = "<ghgvc>\n\t<options>\n\t\t<storage>TRUE</storage>\n\t\t<flux>TRUE</flux>\n\t\t<disturbance>FALSE</disturbance>\n\t\t"
    opening_header << "<co2>TRUE</co2>\n\t\t<ch4>TRUE</ch4>\n\t\t<n2o>TRUE</n2o>\n\t\t<T_A>100</T_A>\n\t\t<T_E>50</T_E>\n\t\t<r>0</r>\n\t</options>\n"
    
    File.open(multisite_config_path, 'a') { |file| file.write(opening_header) }
    
    @ecosystems.each do |key, value|
      site_name = "site_#{key.split('-')[1]}_data"
      puts "key #{key}"
      puts "value #{value}"
      puts site_name
      # We should build the beginning and end biome_instance-0/site_0_data tags first
      
      # start the xml tag for the site
      file_string = ""
      file_string << "<#{site_name}>\n"
      
      @ecosystem_index = key.split('-')[1].to_i
      
      # Also needing to collapse out the native_eco, agroecosystem_eco, aggrading_eco, biofuel_eco
      if value['native_eco'] != nil
        value['native_eco'].each do | ecosystem_k, ecosystem_v |
          @biophys_workaround[@ecosystem_index] = hax( ecosystem_k, ecosystem_v)
          file_string << convert_single_level_hash_to_xml( ecosystem_k, ecosystem_v )
        end
      end      
      if value['agroecosystem_eco'] != nil
        value['agroecosystem_eco'].each do | agroecosystem_k, agroecosystem_v |
#          @biophys_workaround[@ecosystem_index] = hax( ecosystem_k, ecosystem_v)
          file_string << convert_single_level_hash_to_xml( agroecosystem_k, agroecosystem_v )
          
        end
      end
      if value['aggrading_eco'] != nil
        value['aggrading_eco'].each do | aggrading_k, aggrading_v |
#          @biophys_workaround[@ecosystem_index] = hax( ecosystem_k, ecosystem_v)
          file_string << convert_single_level_hash_to_xml( aggrading_k, aggrading_v )
        end
      end
      if value['biofuel_eco'] != nil
        value['biofuel_eco'].each do | biofuel_k, biofuel_v |
#          @biophys_workaround[@ecosystem_index] = hax( ecosystem_k, ecosystem_v)
          file_string << convert_single_level_hash_to_xml( biofuel_k, biofuel_v )
        end      
      end
      file_string << "</#{site_name}>\n"

      File.open(multisite_config_path, 'a') { |file| file.write( file_string ) }
    end
    
    # and the closing ghgvc tag
    File.open(multisite_config_path, 'a') { |file| file.write( "</ghgvc>" ) }

    # Ruby script running a shell command to run a R script
    rcmd = "cd #{ghgvcR_instantiation_path} && ./src/ghgvc_script.R"
    puts "The shell command we're running: \n\t#{rcmd}"
    # this will wait for the script to finish
    r = `#{rcmd}`

    # then poll to see if script is finished 
    @ghgvcR_output = JSON.parse(File.read( "#{ghgvcR_output_path}" ))
    
    # Horrible practice assuming that both @biophys_workaround and @ghgvcR_output are same length
    @ghgvcR_output.each do |site_k, site_data|
      sitenum = site_k.split('_')[1].to_i
      @biophys_workaround[sitenum]['radiative']['output'] = site_data[0]['swRFV']
      
      output = @biophys_workaround[sitenum]['radiative']['output'].to_f 
      input = @biophys_workaround[sitenum]['radiative']['input'].to_f

      scale_factor = output / input
      output_latent =  scale_factor *  @biophys_workaround[sitenum]['latent']['input'].to_f
      @ghgvcR_output[site_k][0]['latent'] = output_latent

    end

    p @ghgvcR_output
    
    
    

=begin
{"site_4_data":[{
    "name":"temperate_grassland",
    "S_CO2":163.2,
    "S_CH4":0.3,
    "S_N2O":0.4,
    "F_CO2":58.9,
    "F_CH4":2.9,
    "F_N2O":-6.4,
    "D_CO2":0,
    "D_CH4":0,
    "D_N2O":0,
    "swRFV":362.3,
    "latent": 300.6
}]
=end

    ## TODO: HANDLE "NA"
    # in a few instances we get back values of "NA" .. replace those with zero    
    @ghgvcR_output.each do | site_k, site_v |
      site_v.each do |i| # site_v is an array
        i.each do |k,v|
          if v == "NA"
            i[k] = 0
          end
        end
      end
    end

    
    respond_to do |format|
      format.json { render json: @ghgvcR_output }
    end
  
  end
  
  
  def download_csv
    if Rails.env == "development"
        ghgvcR_output_path = "/home/thrive/rails_projects/ghgvcR/inst/extdata/output.json"
    end
    if Rails.env == "production"
        ghgvcR_output_path = "/home/ubuntu/ghgvcR/inst/extdata/output.json"
    end
  
    @json_output = JSON.parse(File.read( "#{ghgvcR_output_path}"  ))
    header = "biome S_CO2	S_CH4	S_N2O	F_CO2	F_CH4	F_N2O	D_CO2	D_CH4	D_N2O	swRFV".split(" ")

    @output_csv = File.open("#{Rails.root}/public/output.csv","w")
    @output_csv << header.join(",") << "\n"

    @json_output.each do |biome_k, biome_v|
      biome_v.each do |i|
        line = []
        # Each location can have multiple biomes which are stored as an array
        i.each do | csep_k, csep_v |
          line << csep_v
        end
        @output_csv << line.join(",") << "\n"
      end

      
    end
    @output_csv.close()
  
    send_file("#{Rails.root}/public/output.csv",
              :filename => "output.csv",
              :type => "text/csv")
  end

  # accepts a longitude, latitude:
    # http://localhost:3000/get_biome?lng=-89.25&lat=41.75
    # OR
    # $.post("get_biome", { lng: 106, lat: 127 });
  # returns JSON object of the biome
  def get_biome
    @request_lng = params[:lng].to_f
    @request_lat = params[:lat].to_f
    # used by each file
    @dims = {}

    def remap_range(input, in_low, in_high, out_low, out_high)
      # map onto [0,1] using input range
      frac = ( input - in_low ) / ( in_high - in_low )
      # map onto output range
      ( frac * ( out_high - out_low ) + out_low ).to_i.round()
    end




    ######## Biophysical: ########
#    so for a given biome ... 
#    value = vegetated-bare ground
#    "Latent heat flux" and "Net radiation"
#    @us_corn_latent = value for each of these:
#    us_corn_latent_10yr_avg.nc - us_bare_latent_10yr_avg.nc
#    IE the vegitated ... and what is there in the ground
    
    
    
    #### BR Bare sugarcane rnet: ####
    # http://localhost:3000/get_biome.json?lng=-88.75&lat=37.75 # => 46.0195
    @br_bare_sugc_net_radiation = NumRu::NetCDF.open("netcdf/GCS/Crops/Brazil/Bare/brazil_bare_sugc_rnet_10yr_avg.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @br_bare_sugc_net_radiation.var("latitude")
    @dims["lon"] = @br_bare_sugc_net_radiation.var("longitude")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @br_bare_sugc_net_radiation_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @br_bare_sugc_net_radiation_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @br_bare_sugc_net_radiation.var_names[-1]
      @br_bare_sugc_net_radiation_num = @br_bare_sugc_net_radiation.var( @file_var_name )[ @br_bare_sugc_net_radiation_i, @br_bare_sugc_net_radiation_j, 0, 0 ][0]
#      puts "#######################################"      
#      puts @br_bare_sugc_net_radiation_num
      @br_bare_sugc_net_radiation.close()
    end
    #### BR sugarcane rnet: ####
    # http://localhost:3000/get_biome.json?lng=-88.75&lat=37.75 # => 46.0195
    @br_sugc_net_radiation = NumRu::NetCDF.open("netcdf/GCS/Crops/Brazil/Sugarcane/brazil_sugc_rnet_10yr_avg.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @br_sugc_net_radiation.var("latitude")
    @dims["lon"] = @br_sugc_net_radiation.var("longitude")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @br_sugc_net_radiation_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @br_sugc_net_radiation_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @br_sugc_net_radiation.var_names[-1]
      @br_sugc_net_radiation_num = @br_sugc_net_radiation.var( @file_var_name )[ @br_sugc_net_radiation_i, @br_sugc_net_radiation_j, 0, 0 ][0]
#      puts "#######################################"      
#      puts @br_sugc_net_radiation_num
      @br_sugc_net_radiation.close()
      @br_sugc_net_radiation_diff = @br_sugc_net_radiation_num - @br_bare_sugc_net_radiation_num 
    end
    #### BR Bare sugarcane latent heat flux: ####
    # http://localhost:3000/get_biome.json?lng=-88.75&lat=37.75 # => 46.0195
    @br_bare_sugc_latent_heat_flux = NumRu::NetCDF.open("netcdf/GCS/Crops/Brazil/Bare/brazil_bare_sugc_latent_10yr_avg.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @br_bare_sugc_latent_heat_flux.var("latitude")
    @dims["lon"] = @br_bare_sugc_latent_heat_flux.var("longitude")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @br_bare_sugc_latent_heat_flux_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @br_bare_sugc_latent_heat_flux_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @br_bare_sugc_latent_heat_flux.var_names[-1]
      @br_bare_sugc_latent_heat_flux_num = @br_bare_sugc_latent_heat_flux.var( @file_var_name )[ @br_bare_sugc_latent_heat_flux_i, @br_bare_sugc_latent_heat_flux_j, 0, 0 ][0]
#      puts "#######################################"      
#      puts @br_bare_sugc_latent_heat_flux_num
      @br_bare_sugc_latent_heat_flux.close()
    end
    #### BR sugarcane latent heat flux: ####
    # http://localhost:3000/get_biome.json?lng=-88.75&lat=37.75 # => 46.0195
    @br_sugc_latent_heat_flux = NumRu::NetCDF.open("netcdf/GCS/Crops/Brazil/Sugarcane/brazil_sugc_latent_10yr_avg.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @br_sugc_latent_heat_flux.var("latitude")
    @dims["lon"] = @br_sugc_latent_heat_flux.var("longitude")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @br_sugc_latent_heat_flux_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @br_sugc_latent_heat_flux_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @br_sugc_latent_heat_flux.var_names[-1]
      @br_sugc_latent_heat_flux_num = @br_sugc_latent_heat_flux.var( @file_var_name )[ @br_sugc_latent_heat_flux_i, @br_sugc_latent_heat_flux_j, 0, 0 ][0]
#      puts "#######################################"      
#      puts @br_sugc_latent_heat_flux_num
      @br_sugc_latent_heat_flux.close()
      @br_sugc_latent_heat_flux_diff = @br_sugc_latent_heat_flux_num - @br_bare_sugc_latent_heat_flux_num
    end


    
    #narf
#    bare net radiation - crop rnet
#    bare latent heat flux - crop heat flux
    
#    @br_sugc_net_radiation_diff
    
    

    #### Global Bare latent heat flux: ####
    # http://localhost:3000/get_biome.json?lng=-88.75&lat=37.75 # => 46.0195
    @global_bare_latent_heat_flux = NumRu::NetCDF.open("netcdf/GCS/PotVeg/Bare/global_bare_latent_10yr_avg.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @global_bare_latent_heat_flux.var("latitude")
    @dims["lon"] = @global_bare_latent_heat_flux.var("longitude")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @global_bare_latent_heat_flux_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @global_bare_latent_heat_flux_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @global_bare_latent_heat_flux.var_names[-1]
      @global_bare_latent_heat_flux_num = @global_bare_latent_heat_flux.var( @file_var_name )[ @global_bare_latent_heat_flux_i, @global_bare_latent_heat_flux_j, 0, 0 ][0]
#      puts "#######################################"      
#      puts @global_bare_latent_heat_flux_num
      @global_bare_latent_heat_flux.close()
    end    
#    #### US Bare latent heat flux: ####
#    # http://localhost:3000/get_biome.json?lng=-88.75&lat=37.75 # => 46.0195
#    @us_bare_latent_heat_flux = NumRu::NetCDF.open("netcdf/GCS/Crops/US/Bare/us_bare_latent_10yr_avg.nc")
#    @dims.clear # ensure hash is empty
#    @dims["lat"] = @us_bare_latent_heat_flux.var("latitude")
#    @dims["lon"] = @us_bare_latent_heat_flux.var("longitude")
#    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
#      @us_bare_latent_heat_flux_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
#      # high and low values are counter-intuitive ... but are infact correct
#      @us_bare_latent_heat_flux_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
#      @file_var_name = @us_bare_latent_heat_flux.var_names[-1]
#      @global_bare_latent_heat_flux_num = @us_bare_latent_heat_flux.var( @file_var_name )[ @us_bare_latent_heat_flux_i, @us_bare_latent_heat_flux_j, 0, 0 ][0]
##      puts "#######################################"      
##      puts @global_bare_latent_heat_flux_num
#      @us_bare_latent_heat_flux.close()
#    end
    #### US Corn latent heat flux: ####
    # http://localhost:3000/get_biome.json?lng=-82.75&lat=35.25 # => 45.6976
    @us_corn_latent_heat_flux = NumRu::NetCDF.open("netcdf/GCS/Crops/US/Corn/us_corn_latent_10yr_avg.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @us_corn_latent_heat_flux.var("latitude")
    @dims["lon"] = @us_corn_latent_heat_flux.var("longitude")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @us_corn_latent_heat_flux_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @us_corn_latent_heat_flux_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @us_corn_latent_heat_flux.var_names[-1]
      @us_corn_latent_heat_flux_num = @us_corn_latent_heat_flux.var( @file_var_name )[ @us_corn_latent_heat_flux_i, @us_corn_latent_heat_flux_j, 0, 0 ][0]
#      puts "#######################################"      
#      puts @us_corn_latent_heat_flux_num
      @us_corn_latent_heat_flux.close()
      @us_corn_latent_heat_flux_diff = @global_bare_latent_heat_flux_num - @us_corn_latent_heat_flux_num
    end
    #### US Miscanthus latent heat flux: ####
    # http://localhost:3000/get_biome.json?lng=-82.75&lat=38.75 # => 54.0584
    @us_misc_latent_heat_flux = NumRu::NetCDF.open("netcdf/GCS/Crops/US/MXG/us_mxg_latent_10yr_avg.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @us_misc_latent_heat_flux.var("latitude")
    @dims["lon"] = @us_misc_latent_heat_flux.var("longitude")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @us_misc_latent_heat_flux_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @us_misc_latent_heat_flux_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @us_misc_latent_heat_flux.var_names[-1]
      @us_misc_latent_heat_flux_num = @us_misc_latent_heat_flux.var( @file_var_name )[ @us_misc_latent_heat_flux_i, @us_misc_latent_heat_flux_j, 0, 0 ][0]
#      puts "#######################################"
#      puts @us_misc_latent_heat_flux_num
      @us_misc_latent_heat_flux.close()
      @us_misc_latent_heat_flux_diff = @global_bare_latent_heat_flux_num - @us_misc_latent_heat_flux_num
    end
    #### US Soybean latent heat flux: ####
    # http://localhost:3000/get_biome.json?lng=-79.25&lat=36.25 # => 55.0473
    @us_soy_latent_heat_flux = NumRu::NetCDF.open("netcdf/GCS/Crops/US/Soybean/us_soyb_latent_10yr_avg.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @us_soy_latent_heat_flux.var("latitude")
    @dims["lon"] = @us_soy_latent_heat_flux.var("longitude")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @us_soy_latent_heat_flux_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @us_soy_latent_heat_flux_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @us_soy_latent_heat_flux.var_names[-1]
      @us_soy_latent_heat_flux_num = @us_soy_latent_heat_flux.var( @file_var_name )[ @us_soy_latent_heat_flux_i, @us_soy_latent_heat_flux_j, 0, 0 ][0]
#      puts "#######################################"
#      puts @us_soy_latent_heat_flux_num
      @us_soy_latent_heat_flux.close()
      @us_soy_latent_heat_flux_diff = @global_bare_latent_heat_flux_num - @us_soy_latent_heat_flux_num
    end
    #### US Switchgrass latent heat flux: ####
    # http://localhost:3000/get_biome.json?lng=-83.75&lat=34.25 # => 59.6367
    @us_switch_latent_heat_flux = NumRu::NetCDF.open("netcdf/GCS/Crops/US/Switch/us_switch_latent_10yr_avg.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @us_switch_latent_heat_flux.var("latitude")
    @dims["lon"] = @us_switch_latent_heat_flux.var("longitude")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @us_switch_latent_heat_flux_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @us_switch_latent_heat_flux_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @us_switch_latent_heat_flux.var_names[-1]
      @us_switch_latent_heat_flux_num = @us_switch_latent_heat_flux.var( @file_var_name )[ @us_switch_latent_heat_flux_i, @us_switch_latent_heat_flux_j, 0, 0 ][0]
#      puts "#######################################"
#      puts @us_switch_latent_heat_flux_num
      @us_switch_latent_heat_flux.close()
      @us_switch_latent_heat_flux_diff = @global_bare_latent_heat_flux_num - @us_switch_latent_heat_flux_num
    end
    


    #### Bare net radiation: ####
    @global_bare_net_radiation = NumRu::NetCDF.open("netcdf/GCS/PotVeg/Bare/global_bare_rnet_10yr_avg.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @global_bare_net_radiation.var("latitude")
    @dims["lon"] = @global_bare_net_radiation.var("longitude")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @global_bare_net_radiation_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @global_bare_net_radiation_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @global_bare_net_radiation.var_names[-1]
      @global_bare_net_radiation_num = @global_bare_net_radiation.var( @file_var_name )[ @global_bare_net_radiation_i, @global_bare_net_radiation_j, 0, 0 ][0]
#      puts "#######################################"      
#      puts @global_bare_net_radiation_num
      @global_bare_net_radiation.close()
    end

#    #### Bare net radiation: ####
#    # http://localhost:3000/get_biome.json?lng=-84.25&lat=38.75 # => 72.8878
#    @us_bare_net_radiation = NumRu::NetCDF.open("netcdf/GCS/Crops/US/Bare/us_bare_rnet_10yr_avg.nc")
#    @dims.clear # ensure hash is empty
#    @dims["lat"] = @us_bare_net_radiation.var("latitude")
#    @dims["lon"] = @us_bare_net_radiation.var("longitude")
#    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
#      @us_bare_net_radiation_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
#      # high and low values are counter-intuitive ... but are infact correct
#      @us_bare_net_radiation_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
#      @file_var_name = @us_bare_net_radiation.var_names[-1]
#      @global_bare_net_radiation_num = @us_bare_net_radiation.var( @file_var_name )[ @us_bare_net_radiation_i, @us_bare_net_radiation_j, 0, 0 ][0]
##      puts "#######################################"      
##      puts @global_bare_net_radiation_num
#      @us_bare_net_radiation.close()
#    end
    #### US Corn net radiation: ####
    # http://localhost:3000/get_biome.json?lng=-84.25&lat=39.25 # => 69.3745
    @us_corn_net_radiation = NumRu::NetCDF.open("netcdf/GCS/Crops/US/Corn/us_corn_rnet_10yr_avg.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @us_corn_net_radiation.var("latitude")
    @dims["lon"] = @us_corn_net_radiation.var("longitude")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @us_corn_net_radiation_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @us_corn_net_radiation_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @us_corn_net_radiation.var_names[-1]
      @us_corn_net_radiation_num = @us_corn_net_radiation.var( @file_var_name )[ @us_corn_net_radiation_i, @us_corn_net_radiation_j, 0, 0 ][0]
#      puts "#######################################"      
#      puts @us_corn_net_radiation_num
      @us_corn_net_radiation.close()
      @us_corn_net_radiation_diff = @global_bare_net_radiation_num - @us_corn_net_radiation_num
    end
    #### US Miscanthus net radiation: ####
    # http://localhost:3000/get_biome.json?lng=-86.25&lat=35.75 # => 79.7539
    @us_misc_net_radiation = NumRu::NetCDF.open("netcdf/GCS/Crops/US/MXG/us_mxg_rnet_10yr_avg.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @us_misc_net_radiation.var("latitude")
    @dims["lon"] = @us_misc_net_radiation.var("longitude")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @us_misc_net_radiation_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @us_misc_net_radiation_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @us_misc_net_radiation.var_names[-1]
      @us_misc_net_radiation_num = @us_misc_net_radiation.var( @file_var_name )[ @us_misc_net_radiation_i, @us_misc_net_radiation_j, 0, 0 ][0]
#      puts "#######################################"      
#      puts @us_misc_net_radiation_num
      @us_misc_net_radiation.close()
      @us_misc_net_radiation_diff = @global_bare_net_radiation_num - @us_misc_net_radiation_num
    end
    #### US Soybean net radiation: ####
    # http://localhost:3000/get_biome.json?lng=-84.25&lat=36.25 # => 76.7026
    @us_soy_net_radiation = NumRu::NetCDF.open("netcdf/GCS/Crops/US/Soybean/us_soyb_rnet_10yr_avg.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @us_soy_net_radiation.var("latitude")
    @dims["lon"] = @us_soy_net_radiation.var("longitude")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @us_soy_net_radiation_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @us_soy_net_radiation_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @us_soy_net_radiation.var_names[-1]
      @us_soy_net_radiation_num = @us_soy_net_radiation.var( @file_var_name )[ @us_soy_net_radiation_i, @us_soy_net_radiation_j, 0, 0 ][0]
#      puts "#######################################"      
#      puts @us_soy_net_radiation_num
      @us_soy_net_radiation.close()
      @us_soy_net_radiation_diff = @global_bare_net_radiation_num - @us_soy_net_radiation_num
    end
    #### US Switchgrass net radiation: ####
    # http://localhost:3000/get_biome.json?lng=-76.75&lat=37.75 # => 74.2739
    @us_switch_net_radiation = NumRu::NetCDF.open("netcdf/GCS/Crops/US/Switch/us_switch_rnet_10yr_avg.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @us_switch_net_radiation.var("latitude")
    @dims["lon"] = @us_switch_net_radiation.var("longitude")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @us_switch_net_radiation_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @us_switch_net_radiation_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @us_switch_net_radiation.var_names[-1]
      @us_switch_net_radiation_num = @us_switch_net_radiation.var( @file_var_name )[ @us_switch_net_radiation_i, @us_switch_net_radiation_j, 0, 0 ][0]
#      puts "#######################################"      
#      puts @us_switch_net_radiation_num
      @us_switch_net_radiation.close()
      @us_switch_net_radiation_diff = @global_bare_net_radiation_num - @us_switch_net_radiation_num
    end

    #### NBCD: ####
    # http://localhost:3000/get_biome.json?lng=-81.47451&lat=37.69139 # => 806.4
    @nbcd = NumRu::NetCDF.open("netcdf/nbcd.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @nbcd.var("lat")
    @dims["lon"] = @nbcd.var("lon")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @nbcd_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @nbcd_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @nbcd.var_names[-1]
      @nbcd_num = @nbcd.var( @file_var_name )[ @nbcd_i, @nbcd_j, 0, 0 ][0]
#      puts "#######################################"      
#      puts @nbcd_num
      @nbcd.close()
    end  
    
    #### SOC: ####
    
    # http://localhost:3000/get_biome.json?lng=-84.625&lat=52.95833 # => 674.298
    @soc = NumRu::NetCDF.open("netcdf/SoilCarbonDataS.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @soc.var("y")
    @dims["lon"] = @soc.var("x")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @soc_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @soc_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @soc.var_names[-1]
      @soc_num = @soc.var( @file_var_name )[ @soc_i, @soc_j, 0, 0 ][0]
#      puts "#######################################"
#      puts @soc_num
      @soc.close()
    end  



    #### Saatchi: ####

    ## asia_agb_1km
    # http://localhost:3000/get_biome.json?lng=113.8042&lat=1.918004 # => 90.7488
    @saatchi_asia_bgb = NumRu::NetCDF.open("netcdf/saatchi_asia_bgb_1km.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @saatchi_asia_bgb.var("lat")
    @dims["lon"] = @saatchi_asia_bgb.var("lon")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @saatchi_asia_bgb_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @saatchi_asia_bgb_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @saatchi_asia_bgb.var_names[-1]
      @saatchi_asia_bgb_num = @saatchi_asia_bgb.var( @file_var_name )[ @saatchi_asia_bgb_i, @saatchi_asia_bgb_j, 0, 0 ][0]
#      puts "#######################################"
#      puts @saatchi_asia_bgb_num
      @saatchi_asia_bgb.close()
    end  


    ## asia_agb_1km
    # http://localhost:3000/get_biome.json?lng=113.8042&lat=1.918004 # => 353.926
    @saatchi_asia_agb = NumRu::NetCDF.open("netcdf/saatchi_asia_agb_1km.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @saatchi_asia_agb.var("lat")
    @dims["lon"] = @saatchi_asia_agb.var("lon")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @saatchi_asia_agb_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @saatchi_asia_agb_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @saatchi_asia_agb.var_names[-1]
      @saatchi_asia_agb_num = @saatchi_asia_agb.var( @file_var_name )[ @saatchi_asia_agb_i, @saatchi_asia_agb_j, 0, 0 ][0]
#      puts "#######################################"
#      puts @saatchi_asia_agb_num
      @saatchi_asia_agb.close()
    end  


    ## america_agb_1km
    # http://localhost:3000/get_biome.json?lng=-54.91339&lat=1.91196 # => 83.0064
    @saatchi_america_bgb = NumRu::NetCDF.open("netcdf/saatchi_america_bgb_1km.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @saatchi_america_bgb.var("lat")
    @dims["lon"] = @saatchi_america_bgb.var("lon")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @saatchi_america_bgb_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @saatchi_america_bgb_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @saatchi_america_bgb.var_names[-1]
      @saatchi_america_bgb_num = @saatchi_america_bgb.var( @file_var_name )[ @saatchi_america_bgb_i, @saatchi_america_bgb_j, 0, 0 ][0]
#      puts "#######################################"
#      puts @saatchi_america_bgb_num
      @saatchi_america_bgb.close()
    end  


    ## america_agb_1km
    # http://localhost:3000/get_biome.json?lng=-53.78006&lat=1.345293 # => 251.726
    @saatchi_america_agb = NumRu::NetCDF.open("netcdf/saatchi_america_agb_1km.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @saatchi_america_agb.var("lat")
    @dims["lon"] = @saatchi_america_agb.var("lon")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @saatchi_america_agb_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @saatchi_america_agb_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @saatchi_america_agb.var_names[-1]
      @saatchi_america_agb_num = @saatchi_america_agb.var( @file_var_name )[ @saatchi_america_agb_i, @saatchi_america_agb_j, 0, 0 ][0]
#      puts "#######################################"
#      puts @saatchi_america_agb_num
      @saatchi_america_agb.close()
    end  


    ## africa_bgb_1km
    # http://localhost:3000/get_biome.json?lng=-7.470817&lat=5.702878 # => 60.4312
    @saatchi_africa_bgb = NumRu::NetCDF.open("netcdf/saatchi_africa_bgb_1km.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @saatchi_africa_bgb.var("lat")
    @dims["lon"] = @saatchi_africa_bgb.var("lon")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @saatchi_africa_bgb_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @saatchi_africa_bgb_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @saatchi_africa_bgb.var_names[-1]
      @saatchi_africa_bgb_num = @saatchi_africa_bgb.var( @file_var_name )[ @saatchi_africa_bgb_i, @saatchi_africa_bgb_j, 0, 0 ][0]
#      puts "#######################################"
#      puts @saatchi_africa_bgb_num
      @saatchi_africa_bgb.close()
    end   


    ## africa_agb_1km
    # http://localhost:3000/get_biome.json?lng=-8.47915&lat=6.061211 # => 343.329
    @saatchi_africa_agb = NumRu::NetCDF.open("netcdf/saatchi_africa_agb_1km.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @saatchi_africa_agb.var("lat")
    @dims["lon"] = @saatchi_africa_agb.var("lon")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @saatchi_africa_agb_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @saatchi_africa_agb_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @saatchi_africa_agb.var_names[-1]
      @saatchi_africa_agb_num = @saatchi_africa_agb.var( @file_var_name )[ @saatchi_africa_agb_i, @saatchi_africa_agb_j, 0, 0 ][0]
#      puts "#######################################"
#      puts @saatchi_africa_agb_num
      @saatchi_africa_agb.close()
    end   

    #### Brazil: ####
    
    ## Brazil Sugarcane
    @braz_sugarcane = NumRu::NetCDF.open("netcdf/GCS/Crops/Brazil/Sugarcane/brazil_sugc_latent_10yr_avg.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @braz_sugarcane.var("latitude")
    @dims["lon"] = @braz_sugarcane.var("longitude")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @braz_sugarcane_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @braz_sugarcane_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @braz_sugarcane.var_names[-1]
      @braz_sugarcane_num = @braz_sugarcane.var( @file_var_name )[ @braz_sugarcane_i, @braz_sugarcane_j, 0, 0 ][0]
#      Testing:
#      http://localhost:3000/get_biome.json?lng=-45.25&lat=-14.75 # => 81.625
#      puts "################### brz sugarcane ####################"
#      puts @braz_sugarcane_num
      @braz_sugarcane.close()
    end  
    
    

    #### Global biomes: ####

    ## Global biomes: tundra
    @global_biome_tundra = NumRu::NetCDF.open("netcdf/GCS/biomes/Tundra.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @global_biome_tundra.var("lat")
    @dims["lon"] = @global_biome_tundra.var("lon")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @global_biome_tundra_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @global_biome_tundra_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @global_biome_tundra.var_names[-1]
      @global_biome_tundra_num = @global_biome_tundra.var( @file_var_name )[ @global_biome_tundra_i, @global_biome_tundra_j, 0, 0 ][0]
#      Testing:
#      http://localhost:3000/get_biome.json?lng=-150.9497&lat=69.61112 # => 17077
#      puts "################### global biome tundra ####################"
#      puts @global_biome_tundra_num
      @global_biome_tundra.close()
    end   


    ## Global biomes: savanna
    @global_biome_savanna = NumRu::NetCDF.open("netcdf/GCS/biomes/TropicalSavanna.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @global_biome_savanna.var("lat")
    @dims["lon"] = @global_biome_savanna.var("lon")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @global_biome_savanna_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @global_biome_savanna_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @global_biome_savanna.var_names[-1]
      @global_biome_savanna_num = @global_biome_savanna.var( @file_var_name )[ @global_biome_savanna_i, @global_biome_savanna_j, 0, 0 ][0]
#      Testing:
#      http://localhost:3000/get_biome.json?lng=-0.2647708&lat=12.52548 # => 10139
#      puts "################### global biome savanna ####################"
#      puts @global_biome_savanna_num
      @global_biome_savanna.close()
    end

    
    ## Global biomes: peat
    @global_biome_peat = NumRu::NetCDF.open("netcdf/GCS/biomes/TopicalForestAndPeatForest.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @global_biome_peat.var("lat")
    @dims["lon"] = @global_biome_peat.var("lon")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @global_biome_peat_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @global_biome_peat_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @global_biome_peat.var_names[-1]
      @global_biome_peat_num = @global_biome_peat.var( @file_var_name )[ @global_biome_peat_i, @global_biome_peat_j, 0, 0 ][0]
#      Testing:
#      http://localhost:3000/get_biome.json?lng=22.01513&lat=-0.6995686 # => 10088
#      puts "################### global biome peat ####################"
#      puts @global_biome_peat_num
      @global_biome_peat.close()
    end 
    
    
    ## Global biomes: temperate_scrub
    @global_biome_temperate_scrub = NumRu::NetCDF.open("netcdf/GCS/biomes/TemperateScrubAndWoodland.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @global_biome_temperate_scrub.var("lat")
    @dims["lon"] = @global_biome_temperate_scrub.var("lon")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @global_biome_temperate_scrub_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @global_biome_temperate_scrub_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @global_biome_temperate_scrub.var_names[-1]
      @global_biome_temperate_scrub_num = @global_biome_temperate_scrub.var( @file_var_name )[ @global_biome_temperate_scrub_i, @global_biome_temperate_scrub_j, 0, 0 ][0]
#      Testing:
#      http://localhost:3000/get_biome.json?lng=-4.978971&lat=39.16113 # => 16
#      puts "################### global biome temperate_scrub ####################"
#      puts @global_biome_temperate_scrub_num
      @global_biome_temperate_scrub.close()
    end   
    
    
    # Global biomes: temperate_grassland
    @global_biome_temperate_grassland = NumRu::NetCDF.open("netcdf/GCS/biomes/TemperateGrassland.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @global_biome_temperate_grassland.var("lat")
    @dims["lon"] = @global_biome_temperate_grassland.var("lon")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @global_biome_temperate_grassland_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @global_biome_temperate_grassland_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @global_biome_temperate_grassland.var_names[-1]
      @global_biome_temperate_grassland_num = @global_biome_temperate_grassland.var( @file_var_name )[ @global_biome_temperate_grassland_i, @global_biome_temperate_grassland_j, 0, 0 ][0]
#      Testing:
#      http://localhost:3000/get_biome.json?lng=39.89124&lat=36.02617 # => 16
#      puts "################### global biome temperate_grassland ####################"
#      puts @global_biome_temperate_grassland_num
      @global_biome_temperate_grassland.close()
    end
    
    
    
    ## Global biomes: temperate_forest
    @global_biome_temperate_forest = NumRu::NetCDF.open("netcdf/GCS/biomes/TemperateForest.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @global_biome_temperate_forest.var("lat")
    @dims["lon"] = @global_biome_temperate_forest.var("lon")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @global_biome_temperate_forest_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @global_biome_temperate_forest_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @global_biome_temperate_forest.var_names[-1]
      @global_biome_temperate_forest_num = @global_biome_temperate_forest.var( @file_var_name )[ @global_biome_temperate_forest_i, @global_biome_temperate_forest_j, 0, 0 ][0]
#      Testing:
#      http://localhost:3000/get_biome.json?lng=-80.58157&lat=38.78027 # => 10031
#      puts "################### global biome temperate_forest ####################"
#      puts @global_biome_temperate_forest_num
      @global_biome_temperate_forest.close()
    end


    
    ## Global biomes: Boreal
    @global_biome_boreal = NumRu::NetCDF.open("netcdf/GCS/biomes/NorthernPeatlandAndBorealForest.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @global_biome_boreal.var("lat")
    @dims["lon"] = @global_biome_boreal.var("lon")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @global_biome_boreal_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @global_biome_boreal_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @global_biome_boreal.var_names[-1]
      @global_biome_boreal_num = @global_biome_boreal.var( @file_var_name )[ @global_biome_boreal_i, @global_biome_boreal_j, 0, 0 ][0]
#      Testing:
#      http://localhost:3000/get_biome.json?lng=-117.6874&lat=60.88063 # => 17060
#      puts "################### global biome boreal ####################"
#      puts @global_biome_boreal_num
      @global_biome_boreal.close()
    end
    
    
    ## Global biomes: Marsh
    @global_biome_marsh = NumRu::NetCDF.open("netcdf/GCS/biomes/MarshAndSwampland.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @global_biome_marsh.var("lat")
    @dims["lon"] = @global_biome_marsh.var("lon")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @global_biome_marsh_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @global_biome_marsh_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @global_biome_marsh.var_names[-1]
      @global_biome_marsh_num = @global_biome_marsh.var( @file_var_name )[ @global_biome_marsh_i, @global_biome_marsh_j, 0, 0 ][0]
#      Testing:
#      http://localhost:3000/get_biome.json?lng=-32.02963&lat=7.605901 # => 10147
#      puts "################### global biome marsh ####################"
#      puts @global_biome_marsh_num
      @global_biome_marsh.close()
    end



    ## Global biomes: Desert
    @global_biome_desert = NumRu::NetCDF.open("netcdf/GCS/biomes/Desert.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @global_biome_desert.var("lat")
    @dims["lon"] = @global_biome_desert.var("lon")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @global_biome_desert_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @global_biome_desert_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @global_biome_desert.var_names[-1]
      @global_biome_desert_num = @global_biome_desert.var( @file_var_name )[ @global_biome_desert_i, @global_biome_desert_j, 0, 0 ][0]
#      Testing:
#      http://localhost:3000/get_biome.json?lng=17.41822&lat=25.00726 # => 10698
#      puts "################### global biome marsh ####################"
#      puts @global_biome_desert_num
      @global_biome_desert.close()
    end




    ## Global pasture
    @global_pasture = NumRu::NetCDF.open("netcdf/GCS/Pasture2000_5min.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @global_pasture.var("latitude")
    @dims["lon"] = @global_pasture.var("longitude")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @global_pasture_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @global_pasture_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @global_pasture.var_names[-1]
#      @global_pasture_num = @global_pasture.var( @file_var_name )[ 382, 127, 0, 0 ][0]
      @global_pasture_num = @global_pasture.var( @file_var_name )[ @global_pasture_i, @global_pasture_j, 0, 0 ][0]
#      Testing:
#      http://localhost:3000/get_biome.json?lng=-101.0417&lat=44.95834 # => 0.9817577600479126
#      puts "################### global biome marsh ####################"
#      puts @global_pasture_num
      @global_pasture.close()
    end



    ## Global cropland
    @global_cropland = NumRu::NetCDF.open("netcdf/GCS/Cropland2000_5min.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @global_cropland.var("latitude")
    @dims["lon"] = @global_cropland.var("longitude")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @global_cropland_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @global_cropland_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @global_cropland.var_names[-1]
#      @global_cropland_num = @global_cropland.var( @file_var_name )[ 382, 127, 0, 0 ][0]
      @global_cropland_num = @global_cropland.var( @file_var_name )[ @global_cropland_i, @global_cropland_j, 0, 0 ][0]
#      Testing:
#      http://localhost:3000/get_biome.json?lng=-113.375&lat=51.70834
#      puts "################### global biome marsh ####################"
#      puts @global_cropland_num
      @global_cropland.close()
    end

    ## Global PotVeg Latent
    @global_potVeg_latent = NumRu::NetCDF.open("netcdf/GCS/PotVeg/PotentialVeg/global_veg_latent_10yr_avg.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @global_potVeg_latent.var("latitude")
    @dims["lon"] = @global_potVeg_latent.var("longitude")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @global_potVeg_latent_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @global_potVeg_latent_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @global_potVeg_latent.var_names[-1]
#      @global_potVeg_latent_num = @global_potVeg_latent.var( @file_var_name )[ 382, 127, 0, 0 ][0]
      @global_potVeg_latent_num = @global_potVeg_latent.var( @file_var_name )[ @global_potVeg_latent_i, @global_potVeg_latent_j, 0, 0 ][0]
#      Testing:
#      http://localhost:3000/get_biome.json?lng=-76.25&lat=-2.75  # =>  149.84
#      puts "################### Global PotVeg ####################"
#      puts @global_potVeg_latent_num
      @global_potVeg_latent.close()
    end

    ## Global PotVeg Rnet
    @global_potVeg_rnet = NumRu::NetCDF.open("netcdf/GCS/PotVeg/PotentialVeg/global_veg_rnet_10yr_avg.nc")
    @dims.clear # ensure hash is empty
    @dims["lat"] = @global_potVeg_rnet.var("latitude")
    @dims["lon"] = @global_potVeg_rnet.var("longitude")
    if ( @dims["lat"].get.min <= @request_lat && @request_lat <= @dims["lat"].get.max && @dims["lon"].get.min <= @request_lng && @request_lng <= @dims["lon"].get.max )
      @global_potVeg_rnet_i = remap_range( @request_lng, @dims["lon"].get.min, @dims["lon"].get.max, 0, @dims["lon"].get.shape[0] )
      # high and low values are counter-intuitive ... but are infact correct
      @global_potVeg_rnet_j = remap_range( @request_lat, @dims["lat"].get.max, @dims["lat"].get.min, 0, @dims["lat"].get.shape[0] )
      @file_var_name = @global_potVeg_rnet.var_names[-1]
#      @global_potVeg_rnet_num = @global_potVeg_rnet.var( @file_var_name )[ 382, 127, 0, 0 ][0]
      @global_potVeg_rnet_num = @global_potVeg_rnet.var( @file_var_name )[ @global_potVeg_rnet_i, @global_potVeg_rnet_j, 0, 0 ][0]
#      Testing:
#      http://localhost:3000/get_biome.json?lng=-76.25&lat=-2.75  # =>  149.84
#      puts "################### Global PotVeg ####################"
#      puts @global_potVeg_rnet_num
      @global_potVeg_rnet.close()
    end


#netcdf/GCS/PotVeg/PotentialVeg/global_veg_rnet_10yr_avg.nc

#     Disabled per request
##    ## US SpringWheat
#    # This map has an ij coordinate range of (0,0) to (80, 50)
#    # top left LatLng being (49.75 ,-105.25)
#    # bottom right LatLng being (24.75 ,-65.25)
#    # Therefore it sits between:
#    # Lat 24.75 and 49.75
#    # Lon -105.25 and -65.25
#    # http://localhost:3000/get_biome.json?lng=-97.25&lat=44.75 # => 0.0956562
#    if ( 49.75 >= @request_lat && @request_lat >= 24.75 && -65.25 >= @request_lng && @request_lng >= -105.25 )
#      @us_springwheat_i = remap_range( @request_lng, -105.25, -65.25, 0, 80 )
#      @us_springwheat_j = remap_range( @request_lat, 49.75, 24.75, 0, 50 ) # j == 0 where lat is at its lowest value
#      @us_springwheat = NumRu::NetCDF.open("netcdf/GCS/Crops/US/SpringWheat/fractioncover/fswh_2.7_us.0.5deg.nc")
#      @us_springwheat_num = @us_springwheat.var("fswh")[@us_springwheat_i,@us_springwheat_j,0,0][0]
##      @us_springwheat_num = @us_springwheat.var("fswh")[12,7,0,0][0] #=>> 0.21387700736522675
#      @us_springwheat.close()
#    end
##    http://localhost:3000/get_biome.json?lng=-97.25&lat=44.75 # => 0.0956562
##    puts "################### US springwheat ####################"
##    puts @us_springwheat_num


    ## US Soybean
    # This map has an ij coordinate range of (0,0) to (80, 50)
    # top left LatLng being (49.75 ,-105.25)
    # bottom right LatLng being (24.75 ,-65.25)
    # Therefore it sits between:
    # Lat 24.75 and 49.75
    # Lon -105.25 and -65.25
    if ( 49.75 >= @request_lat && @request_lat >= 24.75 && -65.25 >= @request_lng && @request_lng >= -105.25 )
      @us_soybean_i = remap_range( @request_lng, -105.25, -65.25, 0, 80 )
      @us_soybean_j = remap_range( @request_lat, 49.75, 24.75, 0, 50 ) # j == 0 where lat is at its lowest value
      @us_soybean = NumRu::NetCDF.open("netcdf/GCS/Crops/US/Soybean/fractioncover/fsoy_2.7_us.0.5deg.nc")
      @us_soybean_num = @us_soybean.var("fsoy")[@us_soybean_i,@us_soybean_j,0,0][0]
#      @us_soybean_num = @us_soybean.var("fsoy")[22,13,0,0][0] #=>> 0.40256670117378235
      @us_soybean.close()
    end
#   http://localhost:3000/get_biome.json?lng=-88.25&lat=40.75 # => 0.409562
#   puts "################### US soybean ####################"
#   puts @us_soybean_num



    ## US Corn
    # This map has an ij coordinate range of (0,0) to (80, 50)
    # top left LatLng being (49.75 ,-105.25)
    # bottom right LatLng being (25.25 ,-65.25)
    # Therefore it sits between:
    # Lat 24.75 and 49.75
    # Lon -105.25 and -65.25
    # http://localhost:3000/get_biome.json?lng=-91.25&lat=42.25 # => 0.404886
    if ( 49.75 >= @request_lat && @request_lat >= 24.75 && -65.25 >= @request_lng && @request_lng >= -105.25 )
      @us_corn_i = remap_range( @request_lng, -105.25, -65.25, 0, 80 ) 
      @us_corn_j = remap_range( @request_lat, 49.75, 25.25, 0, 50 ) # j == 0 where lat is at its lowest value
      @us_corn = NumRu::NetCDF.open("netcdf/GCS/Crops/US/Corn/fractioncover/fcorn_2.7_us.0.5deg.nc")
      @us_corn_num = @us_corn.var("fcorn")[@us_corn_i,@us_corn_j,0,0][0]
      @us_corn.close()
    end

    ## Vegtype
    # This map has an ij coordinate range of (0,0) to (720, 360)
    # top left LatLng being (89.75, -179.25)
    # top left LatLng being (-89.75, 179.25)
    # Therefore it sits between:
    # Lat -89.75 and 89.75
    # Lon -179.25 and 179.25
    @vegtype_i = remap_range( @request_lng.to_i , -179.25, 179.25, 0, 720 )
    @vegtype_j = remap_range( @request_lat.to_i , 89.75, -89.75, 0, 360 ) # j == 0 where lat is at its lowest value
    @vegtype = NumRu::NetCDF.open("netcdf/vegtype.nc")
    @biome_num = @vegtype.var("vegtype")[@vegtype_i,@vegtype_j,0,0][0]
#    http://localhost:3000/get_biome.json?lng=24.25&lat=24.25 # => 14
#    puts "################### vegtype ####################"
#    puts @biome_num
    @vegtype.close()

    
    @name_indexed_ecosystems = JSON.parse( File.open( "#{Rails.root}/data/final_ecosystems.json" , "r" ).read )

############ Here we set the additional logic threshold levels ############

    @biome_data = { "native_eco" => {}, "agroecosystem_eco" => {}, "aggrading_eco" => {}, "biofuel_eco" => {} }
    if @biome_num <= 15
      ## Logic for vegtype ecosystems
      case @biome_num
        when 1
          # Per Kristas request
          # "tropical_peat_forest" only where SOC 30-100 cm > 75
          if @soc_num > 75 
            @biome_data["native_eco"]["tropical_peat_forest"] = @name_indexed_ecosystems["tropical peat forest"]
          end
          @biome_data["native_eco"]["tropical_forest"] = @name_indexed_ecosystems["tropical forest"]
        when 2
          @biome_data["native_eco"]["tropical_forest"] = @name_indexed_ecosystems["tropical forest"]
          @biome_data["native_eco"]["tropical_savanna"] = @name_indexed_ecosystems["tropical savanna"]
        when 3, 4, 5
          @biome_data["native_eco"]["temperate_forest"] = @name_indexed_ecosystems["temperate forest"]
        when 6, 7
          # Per Kristas request
          # "northern_peatland" only where SOC 30-100 cm > 75
          if @soc_num > 75 
            @biome_data["native_eco"]["northern_peatland"] = @name_indexed_ecosystems["northern peatland"]
          end
          @biome_data["native_eco"]["boreal_forest"] = @name_indexed_ecosystems["boreal forest"]
        when 8
          if @request_lat >= 50
            @biome_data["native_eco"]["boreal_forest"] = @name_indexed_ecosystems["boreal forest"]
          else 
            @biome_data["native_eco"]["temperate_forest"] = @name_indexed_ecosystems["temperate forest"]
          end
        when 9
          if @request_lat.abs >= 50
            @biome_data["native_eco"]["boreal_forest"] = @name_indexed_ecosystems["boreal forest"]
          elsif @request_lat.abs > 23.26 && @request_lat.abs <= 50
            @biome_data["native_eco"]["temperate_grassland"] = @name_indexed_ecosystems["temperate grassland"]
            @biome_data["native_eco"]["scrub/woodland"] = @name_indexed_ecosystems["scrub/woodland"]
            @biome_data["native_eco"]["temperate_forest"] = @name_indexed_ecosystems["temperate forest"]
          elsif @request_lat.abs <= 23.26
            @biome_data["native_eco"]["tropical_savanna"] = @name_indexed_ecosystems["tropical savanna"]
          end
        when 10
          @biome_data["native_eco"]["temperate_grassland"] = @name_indexed_ecosystems["temperate grassland"]
        when 11
          if @request_lat <= 5
            @biome_data["native_eco"]["scrub/woodland"] = @name_indexed_ecosystems["scrub/woodland"]
          end
        when 12, 14
          @biome_data["native_eco"]["desert"] = @name_indexed_ecosystems["desert"]
        when 13, 15
          @biome_data["native_eco"]["tundra"] = @name_indexed_ecosystems["tundra"]
#        when 14
#          @biome_data["native_eco"] = ["desert [No Vegitation]"]
      end
    end
    
    #### SOC Logic
    ##
    if @soc != 0 && @soc != nil # 0 - 126.577
      @biome_data["native_eco"].each do |k,v|
        @biome_data["native_eco"][k]["OM_SOM"]["s002"] = @soc_num * 1.72 # 0.30 x (soc 0-30 + soc 30-100).
      end
    end
    
    #### Saatchi Logic
    ##
    if @saatchi_asia_bgb_num != 0 && @saatchi_asia_bgb_num != nil # 0 - 126.577
      @biome_data["native_eco"].each do |k,v|
        @biome_data["native_eco"][k]["OM_root"]["s001"] = @saatchi_asia_bgb_num
      end
    end
    if @saatchi_asia_agb_num != 0 && @saatchi_asia_agb_num != nil # 0 - 514.385
      @biome_data["native_eco"].each do |k,v|
        @biome_data["native_eco"][k]["OM_ag"]["s001"] = @saatchi_asia_agb_num
      end
    end
    
    ## Saatchi South America
    if @saatchi_america_bgb_num != 0 && @saatchi_america_bgb_num != nil # 0 - 112.375
      @biome_data["native_eco"].each do |k,v|
        @biome_data["native_eco"][k]["OM_root"]["s001"] = @saatchi_america_bgb_num
      end
    end
    if @saatchi_america_agb_num != 0 && @saatchi_america_agb_num != nil # 0 - 450
      @biome_data["native_eco"].each do |k,v|
        @biome_data["native_eco"][k]["OM_ag"]["s001"] = @saatchi_america_agb_num
      end
    end
    
    ## Saatchi Africa
    if @saatchi_africa_bgb_num != 0 && @saatchi_africa_bgb_num != nil # 0 - 88.418
      @biome_data["native_eco"].each do |k,v|
        @biome_data["native_eco"][k]["OM_root"]["s001"] = @saatchi_africa_bgb_num
      end
    end
    if @saatchi_africa_agb_num != 0 && @saatchi_africa_agb_num != nil # 0 - 343.728
      @biome_data["native_eco"].each do |k,v|
        @biome_data["native_eco"][k]["OM_ag"]["s001"] = @saatchi_africa_agb_num
      end
    end

    # Will we have a saatchi match without a vegtype?
    # Which ecosystems does the saatchi data get places into? ... is it just every ecosystem that comes up?



###   AGROECOSYSTEMS: tropical pasture, temperate pasture, tropical cropland, temperate cropland, wetland rice
    # disabled per kristas request
    if @us_springwheat_num != nil #&& @us_springwheat_num > 0.01
#      @biome_data["agroecosystem_eco"]["springwheat"] = @name_indexed_ecosystems["switchgrass"]
    end
    if @global_pasture_num != nil && @global_pasture_num > 0.01 && @global_pasture_num < 1.0
      if @request_lat.abs < 23.26
        @biome_data["agroecosystem_eco"]["tropical_pasture"] = @name_indexed_ecosystems["tropical pasture"]
      else
        @biome_data["agroecosystem_eco"]["temperate_pasture"] = @name_indexed_ecosystems["temperate pasture"]
      end
    end
    if @global_cropland_num != nil && @global_cropland_num > 0.01 && @global_cropland_num < 1.0
      if @request_lat.abs < 23.26
        @biome_data["agroecosystem_eco"]["tropical_cropland"] = @name_indexed_ecosystems["tropical cropland"]
      else
        @biome_data["agroecosystem_eco"]["temperate_cropland"] = @name_indexed_ecosystems["temperate cropland"]
      end
    end



#    puts "#######################################"
    @biome_data.each do |k,v| #= { "native_eco" => {}, "agroecosystem_eco" => {}, "aggrading_eco" => {}, "biofuel_eco" => {} }
        @biome_data[k].each do |biome_k, biome_v|
            @biome_data[k][biome_k]["sw_radiative_forcing"] = {"s000" => ( @global_potVeg_rnet_num.to_f - @global_bare_net_radiation_num.to_f)/ 51007200000*1000000000 }
            @biome_data[k][biome_k]["latent"] = {"s000" => ( @global_potVeg_latent_num.to_f - @global_bare_latent_heat_flux_num.to_f )/ 51007200000*1000000000  }

#            puts "\n"
#            puts biome_k
#            puts biome_v
#            puts "###"
#            puts "swRadF:"
#            puts ( @global_potVeg_rnet_num.to_f - @global_bare_net_radiation_num.to_f)/ 51007200000 * 1000000000
#            puts "latent:"
#            puts ( @global_potVeg_latent_num.to_f - @global_bare_latent_heat_flux_num.to_f )/ 51007200000 * 1000000000
            
        end
    end
    


    # These must be populated bc the R code wont run without XML fields present for these values
    if @us_corn_num != nil && @us_corn_num > 0.01
      @biome_data["biofuel_eco"]["US_corn"] = @name_indexed_ecosystems["US corn"]
      @biome_data["biofuel_eco"]["US_corn"]["latent"] = {"s000" => 0 , "User defined" => "custom" }
      @biome_data["biofuel_eco"]["US_corn"]["sw_radiative_forcing"] = {"s000" =>  0 , "User defined" => "custom" }
      
      @biome_data["agroecosystem_eco"]["US_corn"] = @name_indexed_ecosystems["US corn"]
      @biome_data["agroecosystem_eco"]["US_corn"]["latent"] = {"s000" =>  0 , "User defined" => "custom" }
      @biome_data["agroecosystem_eco"]["US_corn"]["sw_radiative_forcing"] = {"s000" => 0 , "User defined" => "custom" }
    end
    if @us_soybean_num != nil && @us_soybean_num > 0.01
      @biome_data["biofuel_eco"]["soybean"] = @name_indexed_ecosystems["US corn"]
      @biome_data["biofuel_eco"]["soybean"]["latent"] = {"s000" =>  0 , "User defined" => "custom" }
      @biome_data["biofuel_eco"]["soybean"]["sw_radiative_forcing"] = {"s000" => 0 , "User defined" => "custom" }
      
      @biome_data["agroecosystem_eco"]["soybean"] = @name_indexed_ecosystems["US corn"]
      @biome_data["agroecosystem_eco"]["soybean"]["latent"] = {"s000" =>  0 , "User defined" => "custom" }
      @biome_data["agroecosystem_eco"]["soybean"]["sw_radiative_forcing"] = {"s000" => 0 , "User defined" => "custom" }
    end
    if @braz_sugarcane_num != nil && @braz_sugarcane_num > 0.01 && @braz_sugarcane_num < 110.0
      @biome_data["biofuel_eco"]["BR_sugarcane"] = @name_indexed_ecosystems["BR Sugarcane"]
      @biome_data["biofuel_eco"]["BR_sugarcane"]["latent"] = {"s000" =>  0 , "User defined" => "custom" }
      @biome_data["biofuel_eco"]["BR_sugarcane"]["sw_radiative_forcing"] = {"s000" =>  0 , "User defined" => "custom" }
      
      @biome_data["agroecosystem_eco"]["BR_sugarcane"] = @name_indexed_ecosystems["BR Sugarcane"]
      @biome_data["agroecosystem_eco"]["BR_sugarcane"]["latent"] = {"s000" =>  0 , "User defined" => "custom" }
      @biome_data["agroecosystem_eco"]["BR_sugarcane"]["sw_radiative_forcing"] = {"s000" => 0 , "User defined" => "custom" }
    end
    
#    if @braz_saatchi_carbon
##      @native_names << '{{"Anderson-Teixeira and DeLucia (2011)"=>"400","Saatchi and others (2011)"=>"800"},"OM_root"=>"108"}'
#    end
    # should include corn in the JSON:
    # http://localhost:3000/get_biome.json?lng=-95.25&lat=44.25
    # should NOT include corn in the JSON:
    # http://localhost:3000/get_biome.json?lng=-71.25&lat=33.75
    
    
# TODO: Aggreding not yet added
###   AGGRADING: aggrading temperate non-forest, aggrading tropical non-forest, aggrading boreal forest, aggrading tropical forest, aggrading temperate forest



    respond_to do |format|
      format.json { render json: @biome_data }
    end

  end

  # GET /workflows/new
  # GET /workflows/new.json
  def new
    @workflow = Workflow.new
    # open data/default_ecosystems.json and parse
    # object returned is an array of hashes... Ex:
    # p @ecosystems[0] # will return a Hash
    # p @ecosystems[0]["category"] # => "native"
    @ecosystems = JSON.parse( File.open( "#{Rails.root}/data/default_ecosystems.json" , "r" ).read )
    @name_indexed_ecosystems = JSON.parse( File.open( "#{Rails.root}/data/name_indexed_ecosystems.json" , "r" ).read )
    @ecosystem = @ecosystems[0]

# This is where I'll open the Priors from the DB    
#    @priors = Prior.all
# A prior will have a number of variables
# One of those variables can belong to a given citation

# A PFT would be akin to an ecosystem 
#render :partial => "my_partial", :locals => {:player => Player.new}


    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @workflow }
    end
  end

  # GET /workflows/1/edit
  def edit
    @workflow = Workflow.find(params[:id])
  end

  # POST /workflows
  # POST /workflows.json
  def create
    @workflow = Workflow.new(params[:workflow])

    respond_to do |format|
      if @workflow.save
        format.html { redirect_to @workflow, notice: 'Workflow was successfully created.' }
        format.json { render json: @workflow, status: :created, location: @workflow }
      else
        format.html { render action: "new" }
        format.json { render json: @workflow.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /workflows/1
  # PUT /workflows/1.json
  def update
    @workflow = Workflow.find(params[:id])

    respond_to do |format|
      if @workflow.update_attributes(params[:workflow])
        format.html { redirect_to @workflow, notice: 'Workflow was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @workflow.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /workflows/1
  # DELETE /workflows/1.json
  def destroy
    @workflow = Workflow.find(params[:id])
    @workflow.destroy

    respond_to do |format|
      format.html { redirect_to workflows_url }
      format.json { head :no_content }
    end
  end
end
