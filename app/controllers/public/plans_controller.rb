class Public::PlansController < ApplicationController
  before_action :authenticate_member!

  def index
    @plans = Plan.where(member_id: current_member.id).where('finished_at > ?', Time.now).order(started_at: "ASC")
    @plans_past = Plan.where(member_id: current_member.id).where('finished_at < ?', Time.now).order(started_at: "DESC")
  end

  def show
    @plan = Plan.find(params[:id])
  end

  def new
    @plan = Plan.new
  end

  def create
    @plan = Plan.new(plan_params)
    if @plan.save
      redirect_to public_plan_path(@plan)
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
    if @plan.update(plan_params)
      redirect_to public_plan_path(@plan)
    else
      flash.now[:alert] = "予定の修正に失敗しました。"
      render "edit"
    end
  end

  def destroy
    @plan = Plan.find(params[:id])
    if @plan.destroy
      redirect_to public_plans_path
    else
      flash.now[:alert] = "予定の削除に失敗しました。"
      render "show"
    end
  end

  private

  def plan_params
    params.require(:plan).permit(:subject, :start_date, :started_at, :finish_date, :finished_at, :venue, :memo, :member_id)
  end

end
