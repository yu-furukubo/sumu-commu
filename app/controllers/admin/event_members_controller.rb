class Admin::EventMembersController < ApplicationController
  before_action :authenticate_admin!
  before_action :is_matching_login_admin

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
      flash.now[:alert] = "イベントへの招待に失敗しました。"
      @members = @event.residence.members
      render "index"
    end
  end

  def invite_all
    @event = Event.find(params[:event_id])
    @residence_members = @event.residence.members
    @residence_members.each do |member|
      if not EventMember.find_by(event_id: @event.id, member_id: member.id, is_approved: true).present?
        unless EventMember.find_or_create_by(event_id: @event.id, member_id: member.id, is_approved: false)
          flash.now[:alert] =　"#{member}の招待に失敗しました。"
          @event_members = @event.event_members.where(is_approved: true)
          @event_invited_members = @event.event_members.where(is_approved: false)
          render "index"
          return
        end
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
      flash.now[:alert] = "イベント招待の削除に失敗しました"
      @members = @event.residence.members
      render "index"
    end
  end

  private

  def event_member_params
    params.require(:event_member).permit(:event_id, :member_id, :is_approved)
  end

  def is_matching_login_admin
    residences = current_admin.residences
    admin_events = Event.where(residence_id: residences.pluck(:id))
    unless admin_events.where(id: params[:event_id]).present?
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to admin_events_path
    end
  end

end
