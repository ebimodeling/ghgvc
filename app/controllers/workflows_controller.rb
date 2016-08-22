#require "numru/netcdf"
require "cobravsmongoose"
require "json"
require "fileutils"

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
    # Example call
    # convert_single_level_hash_to_xml ("Desert", {"OM_ag"=>{"Anderson-Teixeira and DeLucia (2011)"=>"444.0"}, "OM_root"=>{"Anderson-Teixeira and DeLucia (2011)"=>"108.0"}} )    
    def convert_single_level_hash_to_xml( name, csep_list )
      # each ecosystem is labled within an opening <pft> and closing </pft> tag
      xml_string = "\t<pft>"
      xml_string << "\n\t\t<name>#{name}</name>\n"
  
      csep_list.each do |key, value|        
        # Value comes in as a hash with its source attached
        # we need to isolate the single value
        
        isolated_value = value.to_a[0][1][0]
        
        ## Checking sanity        
        raise "ERROR: Expecting superclass to be Hash \n\t... evaluated as #{csep_list.class.superclass}" unless csep_list.class.superclass.to_s == "Hash"     
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
    
    @rscript_rundir = "#{Rails.root}/tmp/run/"
    @rscript_outdir = "#{Rails.root}/tmp/out/"
    @rscript_path = "#{Rails.root}/script/"
    
    
    @ecosystems = params[:ecosystems]
    @biophys_workaround = []

    # Clean the file for testing purposes
    File.open("#{@rscript_rundir}/multisite_config.xml", 'w') { |file| file.write("") }
    # Write in opening header
    opening_header = "<ghgvc>\n\t<options>\n\t\t<storage>TRUE</storage>\n\t\t<flux>TRUE</flux>\n\t\t<disturbance>FALSE</disturbance>\n\t\t"
    opening_header << "<co2>TRUE</co2>\n\t\t<ch4>TRUE</ch4>\n\t\t<n2o>TRUE</n2o>\n\t\t<T_A>100</T_A>\n\t\t<T_E>50</T_E>\n\t\t<r>0</r>\n\t</options>\n"
    
    File.open("#{@rscript_rundir}/multisite_config.xml", 'a') { |file| file.write(opening_header) }
    
    @ecosystems.each do |key, value|
      site_name = "site_#{key.split('-')[1]}_data"
      #puts "key #{key}"
      #puts "value #{value}"
      #puts site_name
      # We should build the beginning and end biome_instance-0/site_0_data tags first
      
      # start the xml tag for the site
      file_string = ""
      file_string << "<#{site_name} lat='#{value["lat"]}' lng='#{value["lng"]}'>\n"

      @ecosystem_index = key.split('-')[1].to_i
      
      # Also needing to collapse out the native_eco, agroecosystem_eco, aggrading_eco, biofuel_eco
      if value['native_eco'] != nil
        value['native_eco'].each do | ecosystem_k, ecosystem_v |
          #logger.info("ecosystem_k: #{ecosystem_k}\n\n")
          #logger.info("ecosystem_v: #{ecosystem_v}\n\n")
          file_string << convert_single_level_hash_to_xml( ecosystem_k, ecosystem_v )
        end
      end      
      if value['agroecosystem_eco'] != nil
        value['agroecosystem_eco'].each do | agroecosystem_k, agroecosystem_v |
          file_string << convert_single_level_hash_to_xml( agroecosystem_k, agroecosystem_v )
          
        end
      end
      # if value['aggrading_eco'] != nil
      #   value['aggrading_eco'].each do | aggrading_k, aggrading_v |
      #     file_string << convert_single_level_hash_to_xml( aggrading_k, aggrading_v )
      #   end
      # end

      # if value['biofuel_eco'] != nil
      #   value['biofuel_eco'].each do | biofuel_k, biofuel_v |
      #     file_string << convert_single_level_hash_to_xml( biofuel_k, biofuel_v )
      #   end      
      # end
      file_string << "</#{site_name}>\n"

      File.open("#{@rscript_rundir}/multisite_config.xml", 'a') { |file| file.write( file_string ) }
    end
    
    # and the closing ghgvc tag
    File.open("#{@rscript_rundir}/multisite_config.xml", 'a') { |file| file.write( "</ghgvc>" ) }

    # Ruby script running a shell command to run a R script
    rcmd = "cd #{@rscript_path} && ./calc_ghgv.R #{@rscript_rundir} #{@rscript_outdir}"
    #puts "The shell command we're running: \n\t#{rcmd}"
    # this will wait for the script to finish
	  r = `#{rcmd} 2>&1`
    logger.info("\n\nOutput from R script is:\n\n#{r}\n\n")
    # then poll to see if script is finished 
    @rscript_output = JSON.parse(File.read( "#{@rscript_outdir}ghgv.json" ))

    p @rscript_output
    
    
    

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
    @rscript_output.each do | site_k, site_v |
      site_v.each do |i| # site_v is an array
        i.each do |k,v|
          if v == "NA" || v == "NaN"
            i[k] = 0
          end
        end
      end
    end

    
    respond_to do |format|
      format.json { render json: @rscript_output }
    end
  
  end
  
  
  def download_csv
    send_file("#{Rails.root}/tmp/out/ghgv.csv",
              :filename => "output.csv",
              :type => "text/csv")
  end

  # accepts a longitude, latitude:
    # http://localhost:3000/get_biome?lng=-89.25&lat=41.75
    # OR
    # $.post("get_biome", { lng: 106, lat: 127 });
  # returns JSON object of the biome
  def get_biome
    def get_biomeR (latitude, longitude, ecosystem_default_file)
      # Get data from netcdf using R.
      rcmd = "cd #{@rscript_path} && ./get_biome.R #{latitude} #{longitude} #{@ecosystem_default_file} #{@netcdf_dir} #{@rscript_rundir}"
      r = `#{rcmd} 2>&1`
      #logger.info("\n\n#{r} \n\n")
      #logger.info("rscript_rundir is #{@rscript_rundir}\n\n")
      @res = JSON.parse(File.read( "#{@rscript_rundir}biome.json"))
      logger.info("\n\nresult is: #{@res}\n\n")
      @res
    end
    
    @rscript_rundir = "#{Rails.root}/tmp/run/"
    @rscript_outdir = "#{Rails.root}/tmp/out/"
    @rscript_path = "#{Rails.root}/script/"
    
    #NETCDF Data location
    if Rails.env == "development"
        @netcdf_dir = "/run/media/potterzot/zfire1/work/ebimodeling/netcdf/"
    end
    if Rails.env == "production"
        @netcdf_dir = "#{Rails.root}/netcdf/"
    end
    
    @longitude = params[:lng].to_f
    @latitude = params[:lat].to_f
    @ecosystem_default_file = "#{Rails.root}/public/data/final_ecosystems.json"
    
    #logger.info("params: #{@rscript_path}, #{@latitude}")
    @biome_data = get_biomeR(@latitude, @longitude, @ecosystem_default_file)

    respond_to do |format|
      format.json { render json: @biome_data }
    end
  end

  def get_svg
    begin
      send_file("#{Rails.root}/tmp/out/output.svg")
    rescue
      render(text: "Couldn't find svg file")
    end 
  end

  # GET /workflows/new
  # GET /workflows/new.json
  def new
    @workflow = Workflow.new
    
    @rscript_rundir = "#{Rails.root}/tmp/run/"
    @rscript_outdir = "#{Rails.root}/tmp/out/"
    @rscript_path = "#{Rails.root}/script/"
    
    #Remove the previous run/out files
    FileUtils.rm("#{@rscript_rundir}/biome.json", :force => TRUE)
    FileUtils.rm("#{@rscript_rundir}/multisite_config.xml", :force => TRUE)
    FileUtils.rm("#{@rscript_outdir}/ghgv.json", :force => TRUE)
    FileUtils.rm("#{@rscript_outdir}/ghgv.csv", :force => TRUE)
    FileUtils.rm("#{@rscript_outdir}/output.svg", :force => TRUE)
    
    
    
    # open data/default_ecosystems.json and parse
    # object returned is an array of hashes... Ex:
    # p @ecosystems[0] # will return a Hash
    # p @ecosystems[0]["category"] # => "native"
    @ecosystems = JSON.parse( File.open( "#{Rails.root}/public/data/default_ecosystems.json" , "r" ).read )
    @name_indexed_ecosystems = JSON.parse( File.open( "#{Rails.root}/public/data/name_indexed_ecosystems.json" , "r" ).read )
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
