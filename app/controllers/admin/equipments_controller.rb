class Admin::EquipmentsController < ApplicationController
  before_action :authenticate_admin!
  before_action :check_adnmin_residence
  before_action :is_matching_login_admin, {only: [:show, :edit, :update, :destroy]}

  def index
    @residences = current_admin.residences
    @residence = Residence.find(params[:residence_id])
    @equipments = @residence.equipments
  end

  def new
    @residences = current_admin.residences
    @equipment = Equipment.new
    @residence = Residence.find(params[:equipment][:residence_id])
    @genres = @residence.genres.where(is_deleted: false)
  end

  def create
    @equipment = Equipment.new(equipment_params)
    if params[:equipment][:genre_id] == ""
      @equipment.genre_id = 0
    end
    if @equipment.save
      redirect_to admin_residence_equipment_path(params[:residence_id], @equipment)
    else
      flash.now[:alert] = "備品の登録に失敗しました。"
      @residences = current_admin.residences
      @residence = Residence.find(params[:equipment][:residence_id])
      @genres = @residence.genres.where(is_deleted: false)
      render "new"
    end
  end

  def show
    @residences = current_admin.residences
    @equipment = Equipment.find(params[:id])
    @equipment_reservations = @equipment.reservations.where('finished_at > ?', Time.now).order(started_at: "asc")
  end

  def edit
    @residences = current_admin.residences
    @equipment = Equipment.find(params[:id])
    @residence = @equipment.residence
    @genres = @residence.genres.where(is_deleted: false)
  end

  def update
    @equipment = Equipment.find(params[:id])
    if @equipment.update(equipment_params)
      redirect_to admin_residence_equipment_path(params[:residence_id], @equipment)
    else
      flash.now[:alert] = "備品の登録内容変更に失敗しました。"
      @residences = current_admin.residences
      @residence = @equipment.residence
      @genres = @residence.genres.where(is_deleted: false)
      render "edit"
    end
  end

  def destroy
    @equipment = Equipment.find(params[:id])
    if @equipment.destroy
      redirect_to admin_residence_equipments_path(params[:residence_id])
    else
      flash.now[:alert] = "備品の削除に失敗しました。"
      @residences = current_admin.residences
      @equipment_reservations = @equipment.reservations.where('finished_at > ?', Time.now).order(started_at: "asc")
      render "show"
    end
  end

  private

  def equipment_params
    params.require(:equipment).permit(:genre_id, :name, :description, :stock, :storage_location, :return_location, :note, :residence_id, :image)
  end

  def is_matching_login_admin
    residences = current_admin.residences
    admin_equipments = Equipment.where(residence_id: residences.pluck(:id))
    unless admin_equipments.where(id: params[:id]).present?
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to admin_residence_equipments_path(params[:residence_id])
    end
  end

end
