class Public::FacilitiesController < ApplicationController
  before_action :authenticate_member!

  def show
    @facility = Facility.find(params[:id])
    @facility_reservations = @facility.reservations.where('finished_at > ?', Time.now).order(started_at: "asc")
  end
end
