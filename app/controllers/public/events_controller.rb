class Public::EventsController < ApplicationController
  before_action :authenticate_member!

  def index
    @events = Event.where(residence_id: current_member.residence.id).where('finished_at > ?', Time.now).order(started_at: "ASC")
    @events_mine = @events.where(member_id: current_member.id).where('finished_at > ?', Time.now).order(started_at: "ASC")
    @events_finished = Event.where(residence_id: current_member.residence.id).where('finished_at < ?', Time.now).order(started_at: "DESC")
  end

  def show
    @event = Event.find(params[:id])
    @event_members = @event.event_members.where(is_approved: true)
    @event_invited_members = @event.event_members.where(is_approved: false)
    @event_member = @event.event_members.find_by(member_id: current_member.id)
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      EventMember.create(event_id: @event.id, member_id: current_member.id, is_approved: true)
      redirect_to public_event_path(@event)
    else
      flash.now[:alert] = "イベントの作成に失敗しました。"
      render "new"
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to public_event_path(@event)
    else
      flash.now[:alert] = "イベント内容の更新に失敗しました。"
      render "edit"
    end
  end

  def destroy
    @event = Event.find(params[:id])
    if @event.destroy
      redirect_to public_events_path
    else
      flash.now[:alert] = "イベントの削除に失敗しました。"
      @event_members = @event.event_members.where(is_approved: true)
      @event_invited_members = @event.event_members.where(is_approved: false)
      render "show"
    end
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :started_at, :finished_at, :venue, :residence_id, :member_id)
  end

end
