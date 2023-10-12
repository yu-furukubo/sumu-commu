class Admin::FacilitiesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @residences = current_admin.residences
    @residence_id_array = @residences.pluck(:id)
    @facilities = Facility.where(residence_id: @residence_id_array)
  end

  def residence_search
    @residences = current_admin.residences
    @residence = Residence.find(params[:id])
    @facilities = @residence.facilities
  end

  def new
    @facility = Facility.new
    @residence = Residence.find(params[:facility][:residence_id])
    @genres = @residence.genres.where(is_deleted: false)
  end

  def create
    @facility = Facility.new(facility_params)
    if @facility.save
      redirect_to admin_facility_path(@facility)
    else
      render "new"
    end
  end

  def show
    @facility = Facility.find(params[:id])
  end

  def edit
    @facility = Facility.find(params[:id])
    @residence = @facility.genre.residence
    @genres = @residence.genres.where(is_deleted: false)
  end

  def update
    @facility = Facility.find(params[:id])
    if @facility.update(facility_params)
      redirect_to admin_facility_path(@facility)
    else
      render "edit"
    end
  end

  def destroy
    facility = Facility.find(params[:id])
    if facility.destroy
      redirect_to admin_facilities_path
    else
      flash.now[:notice] = "削除に失敗しました"
      render "show"
    end
  end

  private

  def facility_params
    params.require(:facility).permit(:genre_id, :name, :description, :note, :residence_id, :image)
  end
end
