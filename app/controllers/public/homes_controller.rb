class Public::HomesController < ApplicationController
  before_action :authenticate_member!, except: [:top]

  def top
    if member_signed_in?
      @residence = current_member.residence
      @boards = @residence.boards.where("created_at > ?", current_member.last_sign_in_at).where.not(member_id: current_member.id)
      @exchanges = @residence.exchanges.where("created_at > ?", current_member.last_sign_in_at).where(is_finished: false).where.not(member_id: current_member.id)
      @lost_items = @residence.lost_items.where("created_at > ?", current_member.last_sign_in_at).where(is_finished: false).where.not(member_id: current_member.id)
      @reads = Read.all
      @communities = @residence.communities.where("created_at > ?", current_member.last_sign_in_at).where.not(member_id: current_member.id)
      @events = @residence.events.where("created_at > ?", current_member.last_sign_in_at).where.not(member_id: current_member.id)
      current_member_events_array = EventMember.where(member_id: current_member.id, is_approved: false).pluck(:event_id)
      @events_invited = @residence.events.where(id: current_member_events_array).where('started_at > ?', Time.now)
    end
  end
end
