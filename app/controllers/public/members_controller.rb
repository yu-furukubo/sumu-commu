class Public::MembersController < ApplicationController
  def show
    @member = current_member
  end

  def edit
    @member = current_member
  end

  def update
    @member = current_member
    if @member.update(params_member)
      redirect_to member_public_members_path
    else
      render "edit"
    end
  end
end
