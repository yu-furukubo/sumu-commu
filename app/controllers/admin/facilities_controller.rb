class Admin::FacilitiesController < ApplicationController
  before_action :authenticate_admin!
  before_action :check_adnmin_residence
  before_action :is_matching_login_admin, {only: [:show, :edit, :update, :destroy]}

  def index
    @residences = current_admin.residences
    @residence = Residence.find(params[:residence_id])
    @facilities = @residence.facilities
  end

  def new
    @residences = current_admin.residences
    @facility = Facility.new
    @residence = Residence.find(params[:facility][:residence_id])
    @genres = @residence.genres.where(is_deleted: false)
  end

  def create
    @facility = Facility.new(facility_params)
    if params[:facility][:genre_id] == ""
      @facility.genre_id = 0
    end
    if @facility.save
      redirect_to admin_residence_facility_path(params[:residence_id], @facility)
    else
      flash.now[:alert] = "設備の登録に失敗しました。"
      @residences = current_admin.residences
      @residence = Residence.find(params[:facility][:residence_id])
      @genres = @residence.genres.where(is_deleted: false)
      render "new"
    end
  end

  def show
    @residences = current_admin.residences
    @facility = Facility.find(params[:id])
    @facility_reservations = @facility.reservations.where('finished_at > ?', Time.now).order(started_at: "asc")
  end

  def edit
    @residences = current_admin.residences
    @facility = Facility.find(params[:id])
    @residence = @facility.residence
    @genres = @residence.genres.where(is_deleted: false)
  end

  def update
    @facility = Facility.find(params[:id])
    if @facility.update(facility_params)
      redirect_to admin_residence_facility_path(params[:residence_id], @facility)
    else
      flash.now[:alert] = "設備の登録内容変更に失敗しました。"
      @residences = current_admin.residences
      @residence = @facility.residence
      @genres = @residence.genres.where(is_deleted: false)
      render "edit"
    end
  end

  def destroy
    @facility = Facility.find(params[:id])
    if @facility.destroy
      redirect_to admin_residence_facilities_path(params[:residence_id])
    else
      flash.now[:alert] = "設備の削除に失敗しました。"
      @residences = current_admin.residences
      @facility_reservations = @facility.reservations.where('finished_at > ?', Time.now).order(started_at: "asc")
      render "show"
    end
  end

  private

  def facility_params
    params.require(:facility).permit(:genre_id, :name, :description, :note, :residence_id, :image)
  end

  def is_matching_login_admin
    residences = current_admin.residences
    admin_facilities = Facility.where(residence_id: residences.pluck(:id))
    unless admin_facilities.where(id: params[:id]).present?
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to admin_residence_facilities_path(params[:residence_id])
    end
  end
end
