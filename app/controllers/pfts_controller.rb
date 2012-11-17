class PftsController < ApplicationController
  # GET /pfts
  # GET /pfts.json
  def index
    @pfts = Pft.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pfts }
    end
  end

  # GET /pfts/1
  # GET /pfts/1.json
  def show
    @pft = Pft.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pft }
    end
  end

  # GET /pfts/new
  # GET /pfts/new.json
  def new
    @pft = Pft.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pft }
    end
  end

  # GET /pfts/1/edit
  def edit
    @pft = Pft.find(params[:id])
  end

  # POST /pfts
  # POST /pfts.json
  def create
    @pft = Pft.new(params[:pft])

    respond_to do |format|
      if @pft.save
        format.html { redirect_to @pft, notice: 'Pft was successfully created.' }
        format.json { render json: @pft, status: :created, location: @pft }
      else
        format.html { render action: "new" }
        format.json { render json: @pft.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pfts/1
  # PUT /pfts/1.json
  def update
    @pft = Pft.find(params[:id])

    respond_to do |format|
      if @pft.update_attributes(params[:pft])
        format.html { redirect_to @pft, notice: 'Pft was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @pft.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pfts/1
  # DELETE /pfts/1.json
  def destroy
    @pft = Pft.find(params[:id])
    @pft.destroy

    respond_to do |format|
      format.html { redirect_to pfts_url }
      format.json { head :no_content }
    end
  end
end
