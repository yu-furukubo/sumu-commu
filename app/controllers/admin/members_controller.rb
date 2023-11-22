class Admin::MembersController < ApplicationController
  before_action :authenticate_admin!
  before_action :check_adnmin_residence
  before_action :is_matching_login_admin, {only: [:show, :edit, :update, :destroy]}

  def index
    @residences = current_admin.residences
    @residence = Residence.find(params[:residence_id])
    @members = @residence.members
  end

  def show
    @residences = current_admin.residences
    @member = Member.find(params[:id])
  end

  def edit
    @residences = current_admin.residences
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])
    if @member.update(member_params)
      redirect_to admin_residence_member_path(params[:residence_id], @member)
    else
      flash.now[:alert] = "会員情報の更新に失敗しました。"
      @residences = current_admin.residences
      render "edit"
    end
  end

  def destroy
    member = Member.find(params[:id])
    if member.destroy
      redirect_to admin_residence_members_path(params[:residence_id])
    else
      flash.now[:alert] = "会員の削除に失敗しました。"
      @residences = current_admin.residences
      render "show"
    end
  end

  private

  def member_params
    params.require(:member).permit(:name, :house_address, :email, :profile_image)
  end

  def is_matching_login_admin
    residences = current_admin.residences
    admin_members = Member.where(residence_id: residences.pluck(:id))
    unless admin_members.where(id: params[:id]).present?
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to admin_residence_members_path(params[:residence_id])
    end
  end

end
