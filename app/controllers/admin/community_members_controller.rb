class Admin::CommunityMembersController < ApplicationController
  def update
    @community = Community.find(params[:community_id])
    @community_member = CommunityMember.find(params[:id])
    if @community_member.update(community_member_params)
      redirect_to admin_community_path(@community)
    else
      flash.now[:notice] = "更新に失敗しました"
      render template: "admin/communities/show"
    end
  end

  def destroy
    community = Community.find(params[:community_id])
    community_member = CommunityMember.find(params[:id])
    if community_member.destroy
      redirect_to admin_community_path(community)
    else
      flash.now[:notice] = "削除に失敗しました"
      render template: "admin/communities/show"
    end
  end

  private

  def community_member_params
    params.require(:community_member).permit(:is_admin)
  end

end
