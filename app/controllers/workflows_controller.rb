require "numru/netcdf"

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

  # accepts a longitude, latitude:
    # http://localhost:3000/get_biome?lng=106&lat=127
    # OR
    # $.post("get_biome", { lng: 106, lat: 127 });
  # returns JSON object of the biome
  def get_biome
    lng = params[:lng].to_i
    lat = params[:lat].to_i
    #puts "js inputs >>  lng: #{lng} / lat: #{lat}"
    
    def map_lng_netcdf_range(input)
      lng_in_low = -179.75
      lng_in_high = 179.75
      lng_out_low = 0
      lng_out_high = 720

      # map onto [0,1] using input range
      frac = ( input - lng_in_low ) / ( lng_in_high - lng_in_low )
      # map onto output range
      ( frac * ( lng_out_high - lng_out_low ) + lng_out_low ).to_i.round()
    end
    
    def map_lat_netcdf_range(input)
      # these following high/low values seem wrong, but are infact correct
      # the coordinate value closest to the j = 0 value for the nextcdf file is where the lattitude = 89.75
      # thus the min and max values are swapped
      lat_in_low = 89.75
      lat_in_high = -89.75
      lat_out_low = 0
      lat_out_high = 360

      # map onto [0,1] using input range
      frac = ( input - lat_in_low ) / ( lat_in_high - lat_in_low )
      # map onto output range
      ( frac * ( lat_out_high - lat_out_low ) + lat_out_low ).to_i.round()
    end
    
    i = map_lng_netcdf_range(lng)
    j = map_lat_netcdf_range(lat)
    p "i: #{i} ... lng"
    p "j: #{j} ... lat"
    
    @netcdf = NumRu::NetCDF.open("netcdf/vegtype.nc")
    @biome_num = @netcdf.var("vegtype")[i,j,0,0][0]

    # open data/default_ecosystems.json and parse
    # object returned is an array of hashes... Ex:
    # p @ecosystems[0] # will return a Hash
    # p @ecosystems[0]["category"] # => "native"
    @ecosystems = JSON.parse( File.open( "#{Rails.root}/data/default_ecosystems.json" , "r" ).read )

#    @biome = @ecosystems[@biome_num]
    if @biome_num <= 15
      @biome = @ecosystems[@biome_num]
    else
      @biome = ["name"=>"none"].to_json
    end
    p @biome
    
    # return straight text
#    if @biome_num <= 15
#      @biome = biome_opts[@biome_num] 
#      p @biome
#      render :text => @biome
#    else
#      return :text => "none"
#    end

    respond_to do |format|
      format.json { render json: @biome }
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
    @ecosystem = @ecosystems[0]

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
