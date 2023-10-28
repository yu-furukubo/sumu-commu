class Public::EventsController < ApplicationController
  before_action :authenticate_member!
  before_action :is_matching_login_member, {only: [:edit, :update, :destroy]}
  before_action :is_matching_residence, {only: [:show]}

  def index
    @residence = current_member.residence
    participate_events_array = EventMember.where(member_id: current_member.id, is_approved: true).pluck(:event_id)
    @events = @residence.events.where('finished_at > ?', Time.now).order(started_at: "ASC", finished_at: "ASC")
    @events_participate = @residence.events.where(id: participate_events_array).order(started_at: "ASC", finished_at: "ASC")
    @events_mine = @residence.events.where(member_id: current_member.id).order(started_at: "DESC", finished_at: "DESC")
    @events_finished = @residence.events.where('finished_at < ?', Time.now).order(started_at: "DESC", finished_at: "DESC")
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

    if @event.started_at > @event.finished_at
      flash.now[:alert] = "終了日時は、開始日時より後の日時を指定してください。"
      render "new"
      return
    end

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

    if params[:event][:started_at] > params[:event][:finished_at]
      flash.now[:alert] = "終了日時は、開始日時より後の日時を指定してください。"
      render "edit"
      return
    end

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

  def is_matching_login_member
    event = Event.find(params[:id])
    unless event.member_id == current_member.id
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to public_events_path
    end
  end

  def is_matching_residence
    residence = current_member.residence
    event = Event.find(params[:id])
    unless event.residence == residence
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to public_events_path
    end
  end

end
