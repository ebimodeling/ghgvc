class PriorsController < ApplicationController
  # GET /priors
  # GET /priors.json
  def index
    @priors = Prior.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @priors }
    end
  end

  # GET /priors/1
  # GET /priors/1.json
  def show
    @prior = Prior.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @prior }
    end
  end

  # GET /priors/new
  # GET /priors/new.json
  def new
    @prior = Prior.new
    @ecosystems = JSON.parse( File.open( "#{Rails.root}/public/data/default_ecosystems.json" , "r" ).read )
    @ecosystem = @ecosystems[0]
#    p @ecosystem
    
    p @ecosystem["OM_root"]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @prior }
    end
  end

  # GET /priors/1/edit
  def edit
    @prior = Prior.find(params[:id])
  end

  # POST /priors
  # POST /priors.json
  def create
    @prior = Prior.new(params[:prior])

    respond_to do |format|
      if @prior.save
        format.html { redirect_to @prior, notice: 'Prior was successfully created.' }
        format.json { render json: @prior, status: :created, location: @prior }
      else
        format.html { render action: "new" }
        format.json { render json: @prior.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /priors/1
  # PUT /priors/1.json
  def update
    @prior = Prior.find(params[:id])

    respond_to do |format|
      if @prior.update_attributes(params[:prior])
        format.html { redirect_to @prior, notice: 'Prior was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @prior.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /priors/1
  # DELETE /priors/1.json
  def destroy
    @prior = Prior.find(params[:id])
    @prior.destroy

    respond_to do |format|
      format.html { redirect_to priors_url }
      format.json { head :no_content }
    end
  end
end
