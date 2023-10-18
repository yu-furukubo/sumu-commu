class Public::MembersController < ApplicationController
  before_action :authenticate_member!

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

end
