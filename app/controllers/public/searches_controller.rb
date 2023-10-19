class Public::SearchesController < ApplicationController
  def search
  end

  def search_result
    @category = params[:category]
    @reads = Read.all

    if @category == "all"
      @boards = Board.looks(params[:word], current_member)
      @communities = Community.looks(params[:word], current_member)
      @equipments = Equipment.looks(params[:word], current_member)
      @facilities = Facility.looks(params[:word], current_member)
      @events = Event.looks(params[:word], current_member)
      @exchanges = Exchange.looks(params[:word], current_member)
      @lost_items = LostItem.looks(params[:word], current_member)
      @members = Member.looks(params[:word], current_member)
    elsif @category == "board"
      @boards = Board.looks(params[:word], current_member)
    elsif @category == "community"
      @communities = Community.looks(params[:word], current_member)
    elsif @category == "event"
      @events = Event.looks(params[:word], current_member)
    elsif @category == "exchange"
      @exchanges = Exchange.looks(params[:word], current_member)
    elsif @category == "lost_item"
      @lost_items = LostItem.looks(params[:word], current_member)
    elsif @category == "equipment"
      @equipments = Equipment.looks(params[:word], current_member)
    elsif @category == "facility"
      @facilities = Facility.looks(params[:word], current_member)
    elsif @category == "member"
      @members = Member.looks(params[:word], current_member)
    end
  end
end
