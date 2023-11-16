class Admin::EventMembersController < ApplicationController
  before_action :authenticate_admin!
  before_action :check_adnmin_residence
  before_action :is_matching_login_admin

  def index
    @residences = current_admin.residences
    @event = Event.find(params[:event_id])
    @residence_members = @event.residence.members
    @event_members = @event.event_members.where(is_approved: true)
    @event_invited_members = @event.event_members.where(is_approved: false)
  end

  def create
    @residences = current_admin.residences
    @event = Event.find(params[:event_id])
    event_member = EventMember.new(event_member_params)
    @residence_members = @event.residence.members
    @event_members = @event.event_members.where(is_approved: true)
    @event_invited_members = @event.event_members.where(is_approved: false)
    unless event_member.save
      flash.now[:alert] = "イベントへの招待に失敗しました。"
      render "index"
    end
  end

  def invite_all
    @residences = current_admin.residences
    @event = Event.find(params[:event_id])
    @residence_members = @event.residence.members
    @event_members = @event.event_members.where(is_approved: true)
    @event_invited_members = @event.event_members.where(is_approved: false)
    @residence_members.each do |member|
      if not EventMember.find_by(event_id: @event.id, member_id: member.id, is_approved: true).present?
        unless EventMember.find_or_create_by(event_id: @event.id, member_id: member.id, is_approved: false)
          flash.now[:alert] =　"#{member}の招待に失敗しました。"
          render "index"
          return
        end
      end
    end
  end

  def quit_invite
    @residences = current_admin.residences
    @event = Event.find(params[:event_id])
    event_member = EventMember.find(params[:id])
    @residence_members = @event.residence.members
    @event_members = @event.event_members.where(is_approved: true)
    @event_invited_members = @event.event_members.where(is_approved: false)
    unless event_member.destroy
      flash.now[:alert] = "イベント招待の削除に失敗しました"
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
     redirect_to admin_residence_events_path(params[:residence_id])
    end
  end

end
