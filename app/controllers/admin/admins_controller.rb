class Admin::AdminsController < ApplicationController
  before_action :authenticate_admin!
  before_action :is_matching_login_admin, {only: [:edit, :update]}

  def show
    @admin = current_admin
    @residences = @admin.residences
  end

  def edit
    @admin = current_admin
  end

  def update
    @admin = current_admin
    if @admin.update(admin_params)
      redirect_to admin_admin_path(current_admin)
    else
      flash.now[:alert] = "編集に失敗しました。"
      render "edit"
    end
  end


  private

  def admin_params
    params.require(:admin).permit(:name, :email)
  end

  def is_matching_login_admin
    admin = Admin.find(params[:id])
    unless admin == current_admin
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to admin_admin_path(current_admin)
    end
  end

end