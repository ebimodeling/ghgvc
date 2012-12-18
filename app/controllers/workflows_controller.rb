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
    @lng = params[:lng].to_i
    @lat = params[:lat].to_i
    
    def remap_range(input, in_low, in_high, out_low, out_high)
      # map onto [0,1] using input range
      frac = ( input - in_low ) / ( in_high - in_low )
      # map onto output range
      ( frac * ( out_high - out_low ) + out_low ).to_i.round()
    end

    ## Brazil Sugarcane
    # This map has an ij coordinate range of (0,0) to (59, 44)
    # top left LatLng being (-60.25 ,-4.75)
    # bottom right LatLng being (-30.75 ,-26.75)
    # Therefore it sits between:
    # Lat -4.75 and -26.75
    # Lon -30.75 and -60.25
    if ( -4.75 >= @lat && @lat >= -26.75 && -30.75 >= @lng && @lng >= -60.25 )
      @braz_sugarcane_i = remap_range( @lng, -30.75, -60.25, 0, 59 )
      @braz_sugarcane_j = remap_range( @lat, -4.75, -26.75, 0, 44 ) # i == 0 where lat is at its lowest value
      @braz_sugarcane = NumRu::NetCDF.open("netcdf/GCS/Crops/Brazil/Sugarcane/brazil_sugc_latent_10yr_avg.nc")
      @braz_sugarcane_num = @braz_sugarcane.var("latent")[@braz_sugarcane_i,@braz_sugarcane_j,0,0][0]
      @braz_sugarcane.close()
    end

    ## US Soybean
    # This map has an ij coordinate range of (0,0) to (80, 50)
    # top left LatLng being (49.75 ,-105.25)
    # bottom right LatLng being (25.75 ,-65.25)
    # Therefore it sits between:
    # Lat 25.75 and 49.75
    # Lon -105.25 and -65.25
    if ( 49.75 >= @lat && @lat >= 25.75 && -65.25 >= @lng && @lng >= -105.25 )
      @soybean_i = remap_range( @lng, -105.25, -65.25, 0, 80 )
      @soybean_j = remap_range( @lat, 25.75, 49.75, 0, 50 ) # i == 0 where lat is at its lowest value
      @soybean = NumRu::NetCDF.open("netcdf/GCS/Crops/US/Soybean/us_soyb_latent_10yr_avg.nc")
      @soybean_num = @soybean.var("latent")[@soybean_i,@soybean_j,0,0][0]
      @soybean.close()
    end
    

    ## Vegtype
    # This map has an ij coordinate range of (0,0) to (720, 360)
    # top left LatLng being (89.75, -179.25)
    # top left LatLng being (-89.75, 179.25)
    # Therefore it sits between:
    # Lat -89.75 and 89.75
    # Lon -179.25 and 179.25
    @vegtype_i = remap_range( @lng.to_i , -179.25, 179.25, 0, 720 )
    @vegtype_j = remap_range( @lat.to_i , 89.75, -89.75, 0, 360 ) # i == 0 where lat is at its lowest value
    @vegtype = NumRu::NetCDF.open("netcdf/vegtype.nc")
    @biome_num = @vegtype.var("vegtype")[@vegtype_i,@vegtype_j,0,0][0]
    @vegtype.close()
 
    # open data/default_ecosystems.json and parse
    # object returned is an array of hashes... Ex:
    # p @ecosystems[0] # will return a Hash
    # p @ecosystems[0]["category"] # => "native"
    @ecosystems = JSON.parse( File.open( "#{Rails.root}/data/default_ecosystems.json" , "r" ).read )

    @biome_data = {}
    if @biome_num <= 15
      @biome_data["native"] = @ecosystems[@biome_num]
    end
    
    puts "############ This soybean number is too high ##############"
    puts @soybean_num
    if @soybean_num != nil && @soybean_num < 89
      @biome_data["biofuels"] = {"name"=>"corn,mxg,soybean,spring wheat,switchgrass"}
    end
    
    if @braz_sugarcane_num != nil && @braz_sugarcane_num < 110
      @biome_data["biofuels"] = {"name"=>"soybean,sugarcane"}
    end
    
    # return straight text
#    if @biome_num <= 15
#      @biome = biome_opts[@biome_num] 
#      p @biome
#      render :text => @biome
#    else
#      return :text => "none"
#    end

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
