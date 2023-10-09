class Admin::EventsController < ApplicationController
  def index
    @residences = current_admin.residences
    @residence_id_array = @residences.pluck(:id)
    @events = Event.where(residence_id: @residence_id_array)
  end

  def residence_search
    @residences = current_admin.residences
    @residence = Residence.find(params[:id])
    @events = @residence.events
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.member_id = 0
    if @event.save
      redirect_to admin_event_path(@event)
    else
      render "new"
    end
  end

  def show
    @event = Event.find(params[:id])
    @event_members = @event.event_members
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to admin_event_path(@event)
    else
      render "edit"
    end
  end

  def destroy
    event = Event.find(params[:id])
    if event.destroy
      redirect_to admin_events_path
    else
      flash.now[:notice] = "削除に失敗しました"
      render "show"
    end
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :started_at, :finished_at, :venue, :residence_id)
  end

end
