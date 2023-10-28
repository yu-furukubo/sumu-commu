class Admin::MembersController < ApplicationController
  before_action :authenticate_admin!
  before_action :is_matching_login_admin, {only: [:show, :edit, :update, :destroy]}

  def index
    @residences = current_admin.residences
    @residence_id_array = @residences.pluck(:id)
    @members = Member.where(residence_id: @residence_id_array)
  end

  def residence_search
    @residences = current_admin.residences
    @residence = Residence.find(params[:id])
    @members = @residence.members
  end

  def show
    @member = Member.find(params[:id])
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])
    if @member.update(member_params)
      redirect_to admin_member_path(@member)
    else
      flash.now[:alert] = "会員情報の更新に失敗しました。"
      render "edit"
    end
  end

  def destroy
    member = Member.find(params[:id])
    if member.destroy
      redirect_to admin_members_path
    else
      flash.now[:alert] = "会員の削除に失敗しました。"
      render "show"
    end
  end

  private

  def member_params
    params.require(:member).permit(:name, :house_address, :email)
  end

  def is_matching_login_admin
    residences = current_admin.residences
    admin_members = Member.where(residence_id: residences.pluck(:id))
    unless admin_members.where(id: params[:id]).present?
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to admin_members_path
    end
  end

end
