class Public::EventMembersController < ApplicationController
  before_action :authenticate_member!

  def index
    @event = Event.find(params[:event_id])
    @members = @event.residence.members
  end

  def create
    event = Event.find(params[:event_id])
    event_member = EventMember.new(event_member_params)
    if event_member.save
      redirect_to public_event_event_members_path(event)
    else
      flash.now[:notice] = "招待に失敗しました"
      render "index"
    end
  end

  def participate
    event = Event.find(params[:event_id])
    event_member = EventMember.new(event_member_params)
    if event_member.save
      redirect_to public_event_path(event)
    else
      flash.now[:notice] = "参加に失敗しました"
      render "index"
    end
  end

  def update
    event = Event.find(params[:event_id])
    event_member = EventMember.find(params[:id])
    if event_member.update(event_member_params)
      redirect_to public_event_path(event)
    else
      flash.now[:notice] = "承認に失敗しました"
      render "index"
    end
  end

  def destroy
    event = Event.find(params[:event_id])
    event_member = EventMember.find_by(member_id: params[:id])
    if event_member.destroy
      redirect_to public_event_event_members_path(event)
    else
      flash.now[:notice] = "退会に失敗しました"
      render "index"
    end
  end

  def observe
    event = Event.find(params[:event_id])
    event_member = EventMember.find_by(member_id: params[:id])
    if event_member.destroy
      redirect_to public_event_path(event)
    else
      flash.now[:notice] = "不参加に変更できませんでした"
      render "index"
    end
  end

  private

  def event_member_params
    params.require(:event_member).permit(:event_id, :member_id, :is_approved)
  end

end
