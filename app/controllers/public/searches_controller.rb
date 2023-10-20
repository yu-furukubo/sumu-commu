class Public::SearchesController < ApplicationController
  before_action :authenticate_member!

  def search
  end

  def search_result
    @category = params[:category]
    @reads = Read.all

    if @category == "all"
      @boards = Board.looks(params[:word], current_member.residence_id)
      @communities = Community.looks(params[:word], current_member.residence_id)
      @equipments = Equipment.looks(params[:word], current_member.residence_id)
      @facilities = Facility.looks(params[:word], current_member.residence_id)
      @events = Event.looks(params[:word], current_member.residence_id)
      @exchanges = Exchange.looks(params[:word], current_member.residence_id)
      @lost_items = LostItem.looks(params[:word], current_member.residence_id)
      @members = Member.looks(params[:word], current_member.residence_id)
    elsif @category == "board"
      @boards = Board.looks(params[:word], current_member.residence_id)
    elsif @category == "community"
      @communities = Community.looks(params[:word], current_member.residence_id)
    elsif @category == "event"
      @events = Event.looks(params[:word], current_member.residence_id)
    elsif @category == "exchange"
      @exchanges = Exchange.looks(params[:word], current_member.residence_id)
    elsif @category == "lost_item"
      @lost_items = LostItem.looks(params[:word], current_member.residence_id)
    elsif @category == "equipment"
      @equipments = Equipment.looks(params[:word], current_member.residence_id)
    elsif @category == "facility"
      @facilities = Facility.looks(params[:word], current_member.residence_id)
    elsif @category == "member"
      @members = Member.looks(params[:word], current_member.residence_id)
    end
  end
end
