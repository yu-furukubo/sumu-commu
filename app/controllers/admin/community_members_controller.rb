class Admin::CommunityMembersController < ApplicationController
  before_action :authenticate_admin!

  def update
    @community = Community.find(params[:community_id])
    @community_member = CommunityMember.find(params[:id])
    if @community_member.update(community_member_params)
      redirect_to admin_community_path(@community)
    else
      flash.now[:alert] = "コミュニティメンバーの更新に失敗しました。"
      @community_members = CommunityMember.where(community_id: @community.id)
      @community_comments = CommunityComment.where(community_id: @community.id)
      render template: "admin/communities/show"
    end
  end

  def destroy
    @community = Community.find(params[:community_id])
    community_member = CommunityMember.find(params[:id])
    if community_member.destroy
      redirect_to admin_community_path(@community)
    else
      flash.now[:alert] = "コミュニティメンバーの削除に失敗しました。"
      @community_members = CommunityMember.where(community_id: @community.id)
      @community_comments = CommunityComment.where(community_id: @community.id)
      render template: "admin/communities/show"
    end
  end

  private

  def community_member_params
    params.require(:community_member).permit(:is_admin)
  end

end
