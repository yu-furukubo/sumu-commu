class Admin::MembersController < ApplicationController
  def index
    @members = Member.all
    @residences = Residence.all
  end

  def residence_search
    @residences = Residence.all
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
      render "edit"
    end
  end

# 削除時エラー出るので追って解消
  def destroy
    member = Member.find(params[:id])
    if member.destroy
      redirect_to admin_members_path
    else
      flash.now[:notice] = "削除に失敗しました"
      render "show"
    end
  end

  private

  def member_params
    params.require(:member).permit(:name, :house_address, :email)
  end

end
