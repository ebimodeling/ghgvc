#require "numru/netcdf"
require "cobravsmongoose"
require "json"
require "fileutils"

class WorkflowsController < ApplicationController
  def create_config_input
    @rscript_output = JSON.parse(ClimateRegulatingValues.calculate(params))

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

  # Accepts a longitude, latitude:
  #
  #   http://localhost:3000/get_biome?lng=-89.25&lat=41.75
  #
  # OR
  #
  #   $.post("get_biome", { lng: 106, lat: 127 });
  #
  # Returns JSON object of the biome
  def get_biome
    @longitude = params[:lng].to_f
    @latitude = params[:lat].to_f

    @biome_data = Biome.list(@latitude, @longitude)

    respond_to do |format|
      format.json { render json: @biome_data }
    end
  end

  # GET /workflows/new
  # GET /workflows/new.json
  def new
    # open data/default_ecosystems.json and parse
    # object returned is an array of hashes... Ex:
    # p @ecosystems[0] # will return a Hash
    # p @ecosystems[0]["category"] # => "native"
    @ecosystems = JSON.parse( File.open( "#{Rails.root}/public/data/default_ecosystems.json" , "r" ).read )
    @name_indexed_ecosystems = JSON.parse( File.open( "#{Rails.root}/public/data/name_indexed_ecosystems.json" , "r" ).read )
    @ecosystem = @ecosystems[0]

    respond_to do |format|
      format.html
    end
  end
end
