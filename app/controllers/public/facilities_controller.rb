class Public::FacilitiesController < ApplicationController
  before_action :authenticate_member!
  before_action :is_matching_residence

  def show
    @facility = Facility.find(params[:id])
    @facility_reservations = @facility.reservations.where('finished_at > ?', Time.now).order(started_at: "asc")
  end

  private

  def is_matching_residence
    residence = current_member.residence
    facility = Facility.find(params[:id])
    unless facility.residence == residence
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to public_reservations_path
    end
  end
end
