class Public::EquipmentsController < ApplicationController
  before_action :authenticate_member!
  before_action :is_matching_residence

  def show
    @equipment = Equipment.find(params[:id])
    @equipment_reservations = @equipment.reservations.where('finished_at > ?', Time.now).order(started_at: "asc")
  end

  private

  def is_matching_residence
    residence = current_member.residence
    equipment = Equipment.find(params[:id])
    unless equipment.residence == residence
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to reservations_path
    end
  end
end
