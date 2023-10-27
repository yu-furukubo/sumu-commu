class Public::MembersController < ApplicationController
  before_action :authenticate_member!
  before_action :ensure_guest_member, only: [:edit]

  def index
    @residence = current_member.residence
    @members = @residence.members
  end

  def show
    @member = current_member
  end

  # def edit
  #   @member = current_member
  # end

  # def update
  #   @member = current_member
  #   if @member.update(member_params)
  #     redirect_to member_public_members_path
  #   else
  #     render "edit"
  #   end
  # end

  # private

  # def member_params
  #   params.require(:member).permit(:name, :house_address, :email, :encypted_password, :profile_image)
  # end

  def ensure_guest_member
    @member = current_member
    if @member.email == "guest@example.com"
      redirect_to public_member_information_path , notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end

end
