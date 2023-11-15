class Admin::EventsController < ApplicationController
  before_action :authenticate_admin!
  before_action :check_adnmin_residence
  before_action :is_matching_login_admin, {only: [:show, :edit, :update, :destroy]}

  def index
    @residences = current_admin.residences
    @residence = Residence.find(params[:residence_id])
    @events = @residence.events.where('finished_at > ?', Time.now).order(started_at: "ASC", finished_at: "ASC")
    @events_finished = @residence.events.where('finished_at < ?', Time.now).order(started_at: "DESC", finished_at: "DESC")
  end

  def new
    @residences = current_admin.residences
    @event = Event.new
    @residence = Residence.find(params[:event][:residence_id])
  end

  def create
    @residences = current_admin.residences
    @event = Event.new(event_params)
    @event.member_id = 0
    @residence = Residence.find(params[:event][:residence_id])

    if @event.started_at > @event.finished_at
      flash.now[:alert] = "終了日時は、開始日時より後の日時を指定してください。"
      render "new"
      return
    end

    if @event.save
      redirect_to admin_residence_event_path(params[:residence_id], @event)
    else
      flash.now[:alert] = "イベントの作成に失敗しました。"
      render "new"
    end
  end

  def show
    @residences = current_admin.residences
    @event = Event.find(params[:id])
    @event_members = @event.event_members.where(is_approved: true)
    @event_invited_members = @event.event_members.where(is_approved: false)
  end

  def edit
    @residences = current_admin.residences
    @event = Event.find(params[:id])
    @residence = @event.residence
  end

  def update
    @residences = current_admin.residences
    @event = Event.find(params[:id])
    @residence = @event.residence

    if params[:event][:started_at] > params[:event][:finished_at]
      flash.now[:alert] = "終了日時は、開始日時より後の日時を指定してください。"
      render "edit"
      return
    end

    if @event.update(event_params)
      redirect_to admin_residence_event_path(params[:residence_id], @event)
    else
      flash.now[:alert] = "イベント内容の更新に失敗しました。"
      render "edit"
    end
  end

  def destroy
    @residences = current_admin.residences
    @event = Event.find(params[:id])
    if @event.destroy
      redirect_to admin_residence_events_path(params[:residence_id])
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

  def is_matching_login_admin
    residences = current_admin.residences
    admin_events = Event.where(residence_id: residences.pluck(:id))
    unless admin_events.where(id: params[:id]).present?
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to admin_residence_events_path(params[:residence_id])
    end
  end

end
