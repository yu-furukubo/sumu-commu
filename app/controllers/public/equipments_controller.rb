class Public::EquipmentsController < ApplicationController
  before_action :authenticate_member!

  def show
    @equipment = Equipment.find(params[:id])
  end
end
