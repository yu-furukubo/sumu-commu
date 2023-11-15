class Public::HomesController < ApplicationController
  before_action :authenticate_member!, except: [:top]
  before_action :admin_signed_in

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
      @events_invited = @residence.events.where(id: current_member_events_array).where('finished_at > ?', Time.now)
    end
  end

  private

  def admin_signed_in
    if admin_signed_in?
      if params[:residence_id].present?
        residence = Residence.find(params[:residence_id])
      elsif params[:id].present?
        residence = Residence.find(params[:id])
      else
        residence = Residence.find_by(admin_id: current_admin.id)
      end
      redirect_to admin_residence_admin_path(residence, current_admin)
    end
  end
end
