class Admin::EventsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @residences = current_admin.residences
    @residence_id_array = @residences.pluck(:id)
    @events = Event.where(residence_id: @residence_id_array).where('finished_at > ?', Time.now).order(started_at: "ASC", finished_at: "ASC")
    @events_finished = Event.where(residence_id: @residence_id_array).where('finished_at < ?', Time.now).order(started_at: "DESC", finished_at: "DESC")
  end

  def residence_search
    @residences = current_admin.residences
    @residence = Residence.find(params[:id])
    @events = @residence.events.where('finished_at > ?', Time.now).order(started_at: "ASC", finished_at: "ASC")
    @events_finished = @residence.events.where('finished_at < ?', Time.now).order(started_at: "DESC", finished_at: "DESC")
  end

  def new
    @event = Event.new
    @residence = Residence.find(params[:event][:residence_id])
  end

  def create
    @event = Event.new(event_params)
    @event.member_id = 0
    @residence = Residence.find(params[:event][:residence_id])

    if @event.started_at > @event.finished_at
      flash.now[:alert] = "終了日時は、開始日時より後の日時を指定してください。"
      render "new"
      return
    end

    if @event.save
      redirect_to admin_event_path(@event)
    else
      flash.now[:alert] = "イベントの作成に失敗しました。"
      render "new"
    end
  end

  def show
    @event = Event.find(params[:id])
    @event_members = @event.event_members.where(is_approved: true)
    @event_invited_members = @event.event_members.where(is_approved: false)
  end

  def edit
    @event = Event.find(params[:id])
    @residence = @event.residence
  end

  def update
    @event = Event.find(params[:id])
    @residence = @event.residence

    if params[:event][:started_at] > params[:event][:finished_at]
      flash.now[:alert] = "終了日時は、開始日時より後の日時を指定してください。"
      render "edit"
      return
    end

    if @event.update(event_params)
      redirect_to admin_event_path(@event)
    else
      flash.now[:alert] = "イベント内容の更新に失敗しました。"
      render "edit"
    end
  end

  def destroy
    @event = Event.find(params[:id])
    if @event.destroy
      redirect_to admin_events_path
    else
      flash.now[:alert] = "イベントの削除に失敗しました。"
      @event_members = @event.event_members
      render "show"
    end
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :started_at, :finished_at, :venue, :residence_id)
  end

end
