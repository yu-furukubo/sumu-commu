class Public::PlansController < ApplicationController
  before_action :authenticate_member!

  def index
    @plans = Plan.where(member_id: current_member.id)
  end

  def show
    @plan = Plan.find(params[:id])
  end

  def new
    @plan = Plan.new
  end

  def create
    plan = Plan.new(plan_params)
    if plan.save
      redirect_to public_plan_path(plan)
    else
      render "new"
    end
  end

  def edit
    @plan = Plan.find(params[:id])
  end

  def update
    plan = Plan.find(params[:id])
    if plan.update(plan_params)
      redirect_to public_plan_path(plan)
    else
      render "edit"
    end
  end

  def destroy
    plan = Plan.find(params[:id])
    if plan.destroy
      redirect_to public_plans_path
    else
      flash.now[:notice] = "削除に失敗しました"
      render "show"
    end
  end

  private

  def plan_params
    params.require(:plan).permit(:subject, :started_at, :finished_at, :venue, :memo, :member_id)
  end

end
