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
    Rails.logger.info("ECOSYSTEMS: #{params[:ecosystems]}")
    @ecosystems = params[:ecosystems]
    @biophys_workaround = []

    @rscript_output = ClimateRegulatingValues.calculate @ecosystems

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
    @longitude = params[:lng].to_f
    @latitude = params[:lat].to_f

    @biome_data = Biome.list(@latitude, @longitude)

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
    FileUtils.rm("#{@rscript_rundir}/biome.json", force: true)
    FileUtils.rm("#{@rscript_rundir}/multisite_config.xml", force: true)
    FileUtils.rm("#{@rscript_outdir}/ghgv.json", force: true)
    FileUtils.rm("#{@rscript_outdir}/ghgv.csv", force: true)
    FileUtils.rm("#{@rscript_outdir}/output.svg", force: true)



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
