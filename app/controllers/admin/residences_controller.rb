class Admin::ResidencesController < ApplicationController
  before_action :authenticate_admin!

  def new
    @residence = Residence.new
  end

  def create
    @residence = Residence.new(residence_params)
    if @residence.save
      redirect_to admin_admin_path(current_admin)
    else
      flash.now[:notice] = "管理居住地の追加に失敗しました。"
      render "new"
    end
  end

  def edit
    @residence = Residence.find(params[:id])
  end

  def update
    @residence = Residence.find(params[:id])
    if @residence.update(residence_params)
      redirect_to admin_admin_path(current_admin)
    else
      flash.now[:notice] = "管理居住地の登録内容変更に失敗しました。"
      render "edit"
    end
  end

  def confirm
    @residence = Residence.find(params[:id])
  end

  def destroy
    residence = Residence.find(params[:id])
    if residence.destroy
      redirect_to admin_admin_path(current_admin)
    else
      flash.now[:notice] = "管理居住地の削除に失敗しました。"
      @admin = current_admin
      @residences = @admin.residences
      render template: "admin/admin/show"
    end
  end

  private

  def residence_params
    params.require(:residence).permit(:admin_id, :housing_type, :name, :address)
  end
end
