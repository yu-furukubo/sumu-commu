class Admin::ResidencesController < ApplicationController
  before_action :authenticate_admin!
  before_action :check_adnmin_residence, {except: [:new, :create]}
  before_action :is_matching_login_admin, {only: [:edit, :update, :confirm, :destroy]}

  def new
    @residence = Residence.new
  end

  def create
    @residence = Residence.new(residence_params)
    if @residence.save
      redirect_to admin_residence_admin_path(@residence, current_admin)
    else
      flash[:alert] = "管理居住地の追加に失敗しました。必要事項を入力してください。"
      redirect_to new_admin_residence_path
    end
  end

  def edit
    @residences = current_admin.residences
    @residence = Residence.find(params[:id])
  end

  def update
    @residence = Residence.find(params[:id])
    if @residence.update(residence_params)
      redirect_to admin_residence_admin_path(params[:id], current_admin)
    else
      flash[:alert] = "管理居住地の登録内容変更に失敗しました。"
      @residences = current_admin.residences
      redirect_to edit_admin_residence_path(@residence)
    end
  end

  def confirm
    @residences = current_admin.residences
    @residence = Residence.find(params[:id])
  end

  def destroy
    residence = Residence.find(params[:id])
    if residence.destroy
      if current_admin.residences.count > 0
        redirect_to admin_residence_admin_path(Residence.find_by(admin_id: current_admin.id), current_admin)
      else
        redirect_to new_admin_residence_path
      end
    else
      flash.now[:alert] = "管理居住地の削除に失敗しました。"
      @admin = current_admin
      @residences = @admin.residences
      @residences = current_admin.residences
      render template: "admin/admin/show"
    end
  end

  private

  def residence_params
    params.require(:residence).permit(:admin_id,
                                      :housing_type,
                                      :name,
                                      :address,
                                      :board_is_active,
                                      :community_is_active,
                                      :event_is_active,
                                      :exchange_is_active,
                                      :reservation_is_active,
                                      :lost_item_is_active)
  end

  def is_matching_login_admin
    residences = current_admin.residences
    unless residences.where(id: params[:id]).present?
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to admin_residence_admin_path(params[:id], current_admin)
    end
  end

end
