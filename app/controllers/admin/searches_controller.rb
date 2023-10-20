class Admin::SearchesController < ApplicationController
  before_action :authenticate_admin!

  def search
  end

  def search_result
    @category = params[:category]

    if @category == "all"
      @boards = Board.looks(params[:word], params[:residence_id])
      @communities = Community.looks(params[:word], params[:residence_id])
      @equipments = Equipment.looks(params[:word], params[:residence_id])
      @facilities = Facility.looks(params[:word], params[:residence_id])
      @events = Event.looks(params[:word], params[:residence_id])
      @exchanges = Exchange.looks(params[:word], params[:residence_id])
      @lost_items = LostItem.looks(params[:word], params[:residence_id])
      @members = Member.looks(params[:word], params[:residence_id])
    elsif @category == "board"
      @boards = Board.looks(params[:word], params[:residence_id])
    elsif @category == "community"
      @communities = Community.looks(params[:word], params[:residence_id])
    elsif @category == "event"
      @events = Event.looks(params[:word], params[:residence_id])
    elsif @category == "exchange"
      @exchanges = Exchange.looks(params[:word], params[:residence_id])
    elsif @category == "lost_item"
      @lost_items = LostItem.looks(params[:word], params[:residence_id])
    elsif @category == "equipment"
      @equipments = Equipment.looks(params[:word], params[:residence_id])
    elsif @category == "facility"
      @facilities = Facility.looks(params[:word], params[:residence_id])
    elsif @category == "genre"
      @genres = Genre.looks(params[:word], params[:residence_id])
    elsif @category == "member"
      @members = Member.looks(params[:word], params[:residence_id])
    end
  end
end
