class Public::PlansController < ApplicationController
  before_action :authenticate_member!
  before_action :is_matching_login_member, {only: [:show, :edit, :update, :destroy]}

  def index
    @plans = Plan.where(member_id: current_member.id).where('finished_at > ?', Time.now).order(started_at: "ASC", finished_at: "ASC")
    @plans_past = Plan.where(member_id: current_member.id).where('finished_at < ?', Time.now).order(started_at: "DESC", finished_at: "DESC")
  end

  def show
    @plan = Plan.find(params[:id])
  end

  def new
    @plan = Plan.new
  end

  def create
    @plan = Plan.new(plan_params)

    if params[:plan][:start_date] == "" || params[:plan][:finish_date] == ""
      flash.now[:alert] = "日付を入力してください。"
      render "new"
      return
    end

    set_the_day_implement(@plan)

    if @plan.started_at > @plan.finished_at
      flash.now[:alert] = "終了日時は、開始日時より後の日時を指定してください。"
      render "new"
      return
    end

    if @plan.save
      redirect_to plan_path(@plan)
    else
      flash.now[:alert] = "予定の作成に失敗しました。"
      render "new"
    end
  end

  def edit
    @plan = Plan.find(params[:id])
  end

  def update
    @plan = Plan.find(params[:id])

    if params[:plan][:start_date] == "" || params[:plan][:finish_date] == ""
      flash.now[:alert] = "日付を入力してください。"
      render "edit"
      return
    end

    set_the_day_implement_edit(@plan)

    if @plan.started_at > @plan.finished_at
      flash.now[:alert] = "終了日時は、開始日時より後の日時を指定してください。"
      render "edit"
      return
    end

    if @plan.update(
          subject: params[:plan][:subject],
          start_date: params[:plan][:start_date],
          started_at: @plan.started_at,
          finish_date: params[:plan][:finish_date],
          finished_at: @plan.finished_at,
          venue: params[:plan][:venue],
          memo: params[:plan][:memo]
        )
      redirect_to plan_path(@plan)
    else
      flash.now[:alert] = "予定の修正に失敗しました。"
      render "edit"
    end
  end

  def destroy
    @plan = Plan.find(params[:id])
    if @plan.destroy
      redirect_to plans_path
    else
      flash.now[:alert] = "予定の削除に失敗しました。"
      render "show"
    end
  end

  private

  def plan_params
    params.require(:plan).permit(:subject, :start_date, :started_at, :finish_date, :finished_at, :venue, :memo, :member_id)
  end

  def set_the_day_implement(plan)
    start_year = plan.start_date.year
    start_month = plan.start_date.month
    start_day = plan.start_date.day
    finish_year = plan.finish_date.year
    finish_month = plan.finish_date.month
    finish_day = plan.finish_date.day

    plan.started_at = plan.started_at.change(year: start_year, month: start_month, day: start_day)
    plan.finished_at = plan.finished_at.change(year: finish_year, month: finish_month, day: finish_day)
  end

  def set_the_day_implement_edit(plan)
    start_year = params[:plan][:start_date].to_date.year
    start_month = params[:plan][:start_date].to_date.month
    start_day = params[:plan][:start_date].to_date.day
    start_hour = params[:plan]["started_at(4i)"].to_i
    start_min = params[:plan]["started_at(5i)"].to_i
    finish_year = params[:plan][:finish_date].to_date.year
    finish_month = params[:plan][:finish_date].to_date.month
    finish_day = params[:plan][:finish_date].to_date.day
    finish_hour = params[:plan]["finished_at(4i)"].to_i
    finish_min = params[:plan]["finished_at(5i)"].to_i

    plan.started_at = plan.started_at.change(year: start_year, month: start_month, day: start_day, hour: start_hour, min: start_min)
    plan.finished_at = plan.finished_at.change(year: finish_year, month: finish_month, day: finish_day, hour: finish_hour, min: finish_min)
  end

  def is_matching_login_member
    plan = Plan.find(params[:id])
    unless plan.member_id == current_member.id
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to plans_path
    end
  end

end
