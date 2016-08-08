class DiabeticsController < ApplicationController
  before_action :set_diabetic, only: [:show, :edit, :update, :destroy]

  # GET /diabetics
  # GET /diabetics.json
  def index
    @diabetics = Diabetic.all
  end

  # GET /diabetics/1
  # GET /diabetics/1.json
  def show
  end

  # GET /diabetics/new
  def new
    @diabetic = Diabetic.new
  end

  # GET /diabetics/1/edit
  def edit
  end

  # POST /diabetics
  # POST /diabetics.json
  def create
    @diabetic = Diabetic.new(diabetic_params)

    respond_to do |format|
      if @diabetic.save
        format.html { redirect_to @diabetic, notice: 'Diabetic was successfully created.' }
        format.json { render :show, status: :created, location: @diabetic }
      else
        format.html { render :new }
        format.json { render json: @diabetic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /diabetics/1
  # PATCH/PUT /diabetics/1.json
  def update
    respond_to do |format|
      if @diabetic.update(diabetic_params)
        format.html { redirect_to @diabetic, notice: 'Diabetic was successfully updated.' }
        format.json { render :show, status: :ok, location: @diabetic }
      else
        format.html { render :edit }
        format.json { render json: @diabetic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /diabetics/1
  # DELETE /diabetics/1.json
  def destroy
    @diabetic.destroy
    respond_to do |format|
      format.html { redirect_to diabetics_url, notice: 'Diabetic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_diabetic
      @diabetic = Diabetic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def diabetic_params
      params.require(:diabetic).permit(:pregnant, :oral_glucose_tolerance, :blood_pressure, :skin_fold_thickness, :serum_insulin, :body_mass_index, :pedigree_function, :age, :positive)
    end
end
