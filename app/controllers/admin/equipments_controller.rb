class Admin::EquipmentsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @residences = current_admin.residences
    @residence_id_array = @residences.pluck(:id)
    @equipments = Equipment.where(residence_id: @residence_id_array)
  end

  def residence_search
    @residences = current_admin.residences
    @residence = Residence.find(params[:id])
    @equipments = @residence.equipments
  end

  def new
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
      redirect_to admin_equipment_path(@equipment)
    else
      render "new"
    end
  end

  def show
    @equipment = Equipment.find(params[:id])
    @equipment_reservations = @equipment.reservations.where('finished_at > ?', Time.now).order(started_at: "asc")
  end

  def edit
    @equipment = Equipment.find(params[:id])
    @residence = @equipment.genre.residence
    @genres = @residence.genres.where(is_deleted: false)
  end

  def update
    @equipment = Equipment.find(params[:id])
    if @equipment.update(equipment_params)
      redirect_to admin_equipment_path(@equipment)
    else
      render "edit"
    end
  end

  def destroy
    equipment = Equipment.find(params[:id])
    if equipment.destroy
      redirect_to admin_equipments_path
    else
      flash.now[:notice] = "削除に失敗しました"
      render "show"
    end
  end

  private

  def equipment_params
    params.require(:equipment).permit(:genre_id, :name, :description, :stock, :storage_location, :return_location, :note, :residence_id, :image)
  end
end
