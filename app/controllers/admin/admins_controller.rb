class Admin::AdminsController < ApplicationController
  before_action :authenticate_admin!
  before_action :check_adnmin_residence
  before_action :is_matching_login_admin, {only: [:edit, :update]}

  def show
    if params[:residence].present?
      redirect_to admin_residence_admin_path(params[:residence], current_admin)
    end
    @admin = current_admin
    @residences = @admin.residences
  end

  def edit
    @admin = current_admin
    @residences = @admin.residences
  end

  def update
    @admin = current_admin
    if @admin.update(admin_params)
      redirect_to admin_residence_admin_path(params[:residence_id], current_admin)
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
     redirect_to admin_residence_admin_path(params[:residence_id], current_admin)
    end
  end
  
  def check_adnmin_residence
    unless current_admin.residences.present?
      redirect_to destroy_admin_session_path
    end
  end

end