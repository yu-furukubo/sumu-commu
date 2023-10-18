class Public::EquipmentsController < ApplicationController
  before_action :authenticate_member!

  def show
    @equipment = Equipment.find(params[:id])
    @equipment_reservations = @equipment.reservations.where('finished_at > ?', Time.now).order(started_at: "asc")
  end
end
