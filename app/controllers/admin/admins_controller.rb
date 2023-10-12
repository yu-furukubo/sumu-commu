class Admin::AdminsController < ApplicationController
  before_action :authenticate_admin!

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
      render "edit"
    end
  end


  private

  def admin_params
    params.require(:admin).permit(:name, :email)
  end

end