class Admin::EventMembersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @event = Event.find(params[:event_id])
    @residence_members = @event.residence.members
    @event_members = @event.event_members.where(is_approved: true)
    @event_invited_members = @event.event_members.where(is_approved: false)
  end

  def create
    @event = Event.find(params[:event_id])
    event_member = EventMember.new(event_member_params)
    if event_member.save
      redirect_to admin_event_event_members_path(@event)
    else
      flash.now[:notice] = "イベントへの招待に失敗しました。"
      @members = @event.residence.members
      render "index"
    end
  end

  def invite_all
    @event = Event.find(params[:event_id])
    @residence_members = @event.residence.members
    @residence_members.each do |member|
      unless EventMember.find_or_create_by(event_id: @event.id, member_id: member.id, is_approved: false)
        flash.now[:notice] =　"#{member}の招待に失敗しました。"
        render "index"
        return
      end
    end
    redirect_to admin_event_event_members_path(@event)

  end

  def quit_invite
    @event = Event.find(params[:event_id])
    event_member = EventMember.find(params[:id])
    if event_member.destroy
      redirect_to admin_event_event_members_path(@event)
    else
      flash.now[:notice] = "イベント招待の削除に失敗しました"
      @members = @event.residence.members
      render "index"
    end
  end

  private

  def event_member_params
    params.require(:event_member).permit(:event_id, :member_id, :is_approved)
  end
end
