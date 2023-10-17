class Public::FacilitiesController < ApplicationController
  before_action :authenticate_member!

  def show
    @facility = Facility.find(params[:id])
  end
end
