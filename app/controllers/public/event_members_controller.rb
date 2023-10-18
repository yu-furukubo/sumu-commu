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
      flash.now[:notice] = "イベントへの招待に失敗しました"
      @members = @event.residence.members
      render "index"
    end
  end

  def participate
    @event = Event.find(params[:event_id])
    event_member = EventMember.new(event_member_params)
    if event_member.save
      redirect_to public_event_path(@event)
    else
      flash.now[:notice] = "イベントへの参加に失敗しました"
      @members = @event.residence.members
      render "index"
    end
  end

  def update
    @event = Event.find(params[:event_id])
    event_member = EventMember.find(params[:id])
    if event_member.update(event_member_params)
      redirect_to public_event_path(@event)
    else
      flash.now[:notice] = "イベント招待の承認に失敗しました"
      @members = @event.residence.members
      render "index"
    end
  end

  def destroy
    @event = Event.find(params[:event_id])
    event_member = EventMember.find_by(member_id: params[:id])
    if event_member.destroy
      redirect_to public_event_event_members_path(@event)
    else
      flash.now[:notice] = "イベント不参加への変更に失敗しました"
      @members = @event.residence.members
      render "index"
    end
  end

  def observe
    @event = Event.find(params[:event_id])
    event_member = EventMember.find_by(member_id: params[:id])
    if event_member.destroy
      redirect_to public_event_path(@event)
    else
      flash.now[:notice] = "イベント招待の否認に失敗しました"
      @members = @event.residence.members
      render "index"
    end
  end

  private

  def event_member_params
    params.require(:event_member).permit(:event_id, :member_id, :is_approved)
  end

end
