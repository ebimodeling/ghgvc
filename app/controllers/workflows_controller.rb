#require "numru/netcdf"
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
        rscript_rundir = "#{Rails.root}/tmp/run"
        #ghgvcR_instantiation_path = "/home/ubuntu/ghgvc/ghgvcR/"
        ghgvcR_instantiation_path = "/opt/ghgvc/ghgvcR/"
        rscript_outdir = "#{Rails.root}/tmp/out"
    end
    if Rails.env == "production"
        rscript_rundir = "#{Rails.root}/tmp/run"
        ghgvcR_instantiation_path = "#{Rails.root}/../ghgvcR"
        rscript_outdir = "#{Rails.root}/tmp/out"
    end
  
    @ecosystems = params[:ecosystems]
    @biophys_workaround = []

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
    File.open("#{rscript_rundir}/multisite_config.xml", 'w') { |file| file.write("") }
    # Write in opening header
    opening_header = "<ghgvc>\n\t<options>\n\t\t<storage>TRUE</storage>\n\t\t<flux>TRUE</flux>\n\t\t<disturbance>FALSE</disturbance>\n\t\t"
    opening_header << "<co2>TRUE</co2>\n\t\t<ch4>TRUE</ch4>\n\t\t<n2o>TRUE</n2o>\n\t\t<T_A>100</T_A>\n\t\t<T_E>50</T_E>\n\t\t<r>0</r>\n\t</options>\n"
    
    File.open("#{rscript_rundir}/multisite_config.xml", 'a') { |file| file.write(opening_header) }
    
    @ecosystems.each do |key, value|
      site_name = "site_#{key.split('-')[1]}_data"
      puts "key #{key}"
      puts "value #{value}"
      puts site_name
      # We should build the beginning and end biome_instance-0/site_0_data tags first
      
      # start the xml tag for the site
      file_string = ""
      file_string << "<#{site_name} lat='#{value["lat"]}' lng='#{value["lng"]}'>\n"

      @ecosystem_index = key.split('-')[1].to_i
      
      # Also needing to collapse out the native_eco, agroecosystem_eco, aggrading_eco, biofuel_eco
      if value['native_eco'] != nil
        value['native_eco'].each do | ecosystem_k, ecosystem_v |
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

      File.open("#{rscript_rundir}/multisite_config.xml", 'a') { |file| file.write( file_string ) }
    end
    
    # and the closing ghgvc tag
    File.open("#{rscript_rundir}/multisite_config.xml", 'a') { |file| file.write( "</ghgvc>" ) }

    # Ruby script running a shell command to run a R script
    rcmd = "cd #{ghgvcR_instantiation_path} && ./src/ghgvc_script.R #{rscript_rundir} #{rscript_outdir}"
    puts "The shell command we're running: \n\t#{rcmd}"
    # this will wait for the script to finish
	r = `#{rcmd} 2>&1`
    logger.info("\n\nOutput from R script is:\n\n#{r}\n\n")
    # then poll to see if script is finished 
    @ghgvcR_output = JSON.parse(File.read( "#{rscript_outdir}/output.json" ))

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
          if v == "NA" || v == "NaN"
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
    send_file("#{Rails.root}/tmp/out/output.csv",
              :filename => "output.csv",
              :type => "text/csv")
    return

    # We don't need all this below any more.  To-Do: delete this code
    # and unneeded code it depends upon.

    if Rails.env == "development"
        ghgvcR_output_path = "#{Rails.root}/tmp/out/output.json"
    end
    if Rails.env == "production"
        ghgvcR_output_path = "#{Rails.root}/tmp/out/output.json"
    end
  
    @json_output = JSON.parse(File.read( "#{ghgvcR_output_path}"  ))
    header = "biome S_CO2	S_CH4	S_N2O	F_CO2	F_CH4	F_N2O	D_CO2	D_CH4	D_N2O	Rnet latent CRV".split(" ")

    @output_csv = File.open("#{Rails.root}/public/output.csv","w")
    @output_csv << header.join(",") << "\n"

    @json_output.each do |location_k, location_v|
      @output_csv << location_k << "\n"      
      location_v.each do |i|
        row = []
        # Each location can have multiple biomes which are stored as an array
        i.each do | biome_output_k, biome_output_v |
          row << biome_output_v
        end
                
        @output_csv << row.join(",") << "\n"
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
    longitude = params[:lng].to_f
    latitude = params[:lat].to_f

    # Paths
    rscript_rundir = "#{Rails.root}/tmp/run"
    rscript_outdir = "#{Rails.root}/tmp/out"
    ghgvcR_path = "/opt/ghgvc/ghgvcR/"
    
    def get_biome (r_rundir, r_outdir, ghgvcR_path, latitude, longitude)
      # Get data from netcdf using R.
      rcmd = "cd #{ghgvcR_path} && ./src/get_biome.R #{r_rundir} #{r_outdir} #{latitude} #{longitude}"
      r = `#{rcmd} 2>&1`
      logger.info("\n\n#{r} \n\n")
      @res = JSON.parse(File.read( "#{r_outdir}/biome.json"))
      logger.info("\n\n#{name} result is: #{@res}\n\n")
      @res
    end

    @biome_data = get_biome(rscript_rundir, rscript_outdir, ghgvcR_path, latitude, longitude)

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
