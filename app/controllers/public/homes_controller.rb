class Public::HomesController < ApplicationController
  before_action :authenticate_member!, except: [:top]

  def top
    if member_signed_in?
      @residence = current_member.residence
      @boards = @residence.boards.where("created_at > ?", current_member.last_sign_in_at).where.not(member_id: current_member.id)
      @exchanges = @residence.exchanges.where("created_at > ?", current_member.last_sign_in_at).where.not(member_id: current_member.id)
      @lost_itemss = @residence.lost_items.where("created_at > ?", current_member.last_sign_in_at).where.not(member_id: current_member.id)
      @reads = Read.all
      @member_events_array = EventMember.where(member_id: current_member.id, is_approved: false).pluck(:event_id)
      @events = @residence.events.where(id: @member_events_array).where('started_at > ?', Time.now)
    end
  end
end
