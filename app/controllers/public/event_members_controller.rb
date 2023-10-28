class Public::EventMembersController < ApplicationController
  before_action :authenticate_member!

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
      redirect_to public_event_event_members_path(@event)
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
      if not EventMember.find_by(event_id: @event.id, member_id: member.id, is_approved: true).present? || @event.member == member
        unless EventMember.find_or_create_by(event_id: @event.id, member_id: member.id, is_approved: false)
          flash.now[:alert] =　"#{member}の招待に失敗しました。"
          @event_members = @event.event_members.where(is_approved: true)
          @event_invited_members = @event.event_members.where(is_approved: false)
          render "index"
          return
        end
      end
    end
    redirect_to public_event_event_members_path(@event)
  end

  def participate
    @event = Event.find(params[:event_id])
    event_member = EventMember.new(event_member_params)
    if event_member.save
      redirect_to public_event_path(@event)
    else
      flash.now[:alert] = "イベントへの参加に失敗しました。"
      @event_members = @event.event_members.where(is_approved: true)
      @event_invited_members = @event.event_members.where(is_approved: false)
      @event_member = @event.event_members.find_by(member_id: current_member.id)
      render template: "public/events/show"
    end
  end

  def update
    @event = Event.find(params[:event_id])
    event_member = @event.event_members.find_by(member_id: current_member.id)
    if event_member.update(event_member_params)
      redirect_to public_event_path(@event)
    else
      flash.now[:alert] = "イベント招待の承認に失敗しました。"
      @event_members = @event.event_members.where(is_approved: true)
      @event_invited_members = @event.event_members.where(is_approved: false)
      @event_member = @event.event_members.find_by(member_id: current_member.id)
      render template: "public/events/show"
    end
  end

  def destroy
    @event = Event.find(params[:event_id])
    event_member = @event.event_members.find_by(member_id: current_member.id)
    if event_member.destroy
      redirect_to public_event_path(@event)
    else
      flash.now[:alert] = "イベント不参加への変更に失敗しました。"
      @event_members = @event.event_members.where(is_approved: true)
      @event_invited_members = @event.event_members.where(is_approved: false)
      @event_member = @event.event_members.find_by(member_id: current_member.id)
      render template: "public/events/show"
    end
  end

  def observe
    @event = Event.find(params[:event_id])
    event_member = @event.event_members.find_by(member_id: current_member.id)
    if event_member.destroy
      redirect_to public_event_path(@event)
    else
      flash.now[:alert] = "イベント招待の否認に失敗しました"
      @members = @event.residence.members
      render "index"
    end
  end

  def quit_invite
    @event = Event.find(params[:event_id])
    event_member = EventMember.find(params[:id])
    if event_member.destroy
      redirect_to public_event_event_members_path(@event)
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
