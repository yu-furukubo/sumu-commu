class Public::EventsController < ApplicationController
  before_action :authenticate_member!

  def index
    @events = Event.where(residence_id: current_member.residence.id)
    @events_mine = @events.where(member_id: current_member.id)
    @events_others = @events.where.not(member_id: current_member.id)
  end

  def show
    @event = Event.find(params[:id])
    @event_members = @event.event_members.where(is_approved: true)
    @event_invited_members = @event.event_members.where(is_approved: false)
  end

  def new
    @event = Event.new
  end

  def create
    event = Event.new(event_params)
    if event.save
      EventMember.create(event_id: event.id, member_id: current_member.id, is_approved: true)
      redirect_to public_event_path(event)
    else
      render "new"
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    event = Event.find(params[:id])
    if event.update(event_params)
      redirect_to public_event_path(event)
    else
      render "edit"
    end
  end

  def destroy
    event = Event.find(params[:id])
    if event.destroy
      redirect_to public_events_path
    else
      flash.now[:notice] = "削除に失敗しました"
      render "show"
    end
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :started_at, :finished_at, :venue, :residence_id, :member_id)
  end

end
