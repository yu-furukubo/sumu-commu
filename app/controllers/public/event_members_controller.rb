class Public::EventMembersController < ApplicationController
  before_action :authenticate_member!
  before_action :is_matching_login_member, {only: [:create, :invite_all, :quit_invite]}
  before_action :is_matching_residence, {only: [:index, :participate, :update, :destroy, :decline]}

  def index
    @event = Event.find(params[:event_id])
    @residence_members = @event.residence.members
    @event_members = @event.event_members.where(is_approved: true)
    @event_invited_members = @event.event_members.where(is_approved: false)
  end

  def create
    @event = Event.find(params[:event_id])
    @residence_members = @event.residence.members
    @event_members = @event.event_members.where(is_approved: true)
    @event_invited_members = @event.event_members.where(is_approved: false)
    event_member = EventMember.new(event_member_params)
    unless event_member.save
      flash.now[:alert] = "イベントへの招待に失敗しました。"
      render "index"
    end
  end

  def invite_all
    @event = Event.find(params[:event_id])
    @residence_members = @event.residence.members
    @event_members = @event.event_members.where(is_approved: true)
    @event_invited_members = @event.event_members.where(is_approved: false)
    @residence_members.each do |member|
      if not EventMember.find_by(event_id: @event.id, member_id: member.id, is_approved: true).present? || @event.member == member
        unless EventMember.find_or_create_by(event_id: @event.id, member_id: member.id, is_approved: false)
          flash.now[:alert] =　"#{member}の招待に失敗しました。"
          render "index"
          return
        end
      end
    end
  end

  def quit_invite
    @event = Event.find(params[:event_id])
    @residence_members = @event.residence.members
    @event_members = @event.event_members.where(is_approved: true)
    @event_invited_members = @event.event_members.where(is_approved: false)
    event_member = EventMember.find(params[:id])
    unless event_member.destroy
      flash.now[:notice] = "イベント招待の削除に失敗しました"
      render "index"
    end
  end

  def participate
    @event = Event.find(params[:event_id])
    @event_members = @event.event_members.where(is_approved: true)
    @event_invited_members = @event.event_members.where(is_approved: false)
    event_member = EventMember.new(event_member_params)
    unless event_member.save
      flash.now[:alert] = "イベントへの参加に失敗しました。"
      @event_member = @event.event_members.find_by(member_id: current_member.id)
      render template: "public/events/show"
    end
    @event_member = @event.event_members.find_by(member_id: current_member.id)
  end

  def update
    @event = Event.find(params[:event_id])
    @event_members = @event.event_members.where(is_approved: true)
    @event_invited_members = @event.event_members.where(is_approved: false)
    event_member = @event.event_members.find_by(member_id: current_member.id)
    unless event_member.update(event_member_params)
      flash.now[:alert] = "イベント招待の承認に失敗しました。"
      @event_member = @event.event_members.find_by(member_id: current_member.id)
      render template: "public/events/show"
    end
    @event_member = @event.event_members.find_by(member_id: current_member.id)
  end

  def destroy
    @event = Event.find(params[:event_id])
    @event_members = @event.event_members.where(is_approved: true)
    @event_invited_members = @event.event_members.where(is_approved: false)
    event_member = @event.event_members.find_by(member_id: current_member.id)
    unless event_member.destroy
      flash.now[:alert] = "イベント不参加への変更に失敗しました。"
      @event_member = @event.event_members.find_by(member_id: current_member.id)
      render template: "public/events/show"
    end
    @event_member = @event.event_members.find_by(member_id: current_member.id)
  end

  def decline
    @event = Event.find(params[:event_id])
    @residence_members = @event.residence.members
    @event_members = @event.event_members.where(is_approved: true)
    @event_invited_members = @event.event_members.where(is_approved: false)
    event_member = @event.event_members.find_by(member_id: current_member.id)
    unless event_member.destroy
      flash.now[:alert] = "イベント招待の否認に失敗しました"
      @event_member = @event.event_members.find_by(member_id: current_member.id)
      render "index"
    end
    @event_member = @event.event_members.find_by(member_id: current_member.id)
  end

  private

  def event_member_params
    params.require(:event_member).permit(:event_id, :member_id, :is_approved)
  end

  def is_matching_login_member
    event = Event.find(params[:event_id])
    unless event.member_id == current_member.id
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to public_events_path
    end
  end

  def is_matching_residence
    residence = current_member.residence
    event = Event.find(params[:event_id])
    unless event.residence == residence
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to public_events_path
    end
  end

end
