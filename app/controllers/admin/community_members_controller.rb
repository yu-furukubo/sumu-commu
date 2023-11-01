class Admin::CommunityMembersController < ApplicationController
  before_action :authenticate_admin!
  before_action :is_matching_login_admin

  def update
    @community = Community.find(params[:community_id])
    @community_member = CommunityMember.find(params[:id])
    @community_members = CommunityMember.where(community_id: @community.id)
    @community_comments = CommunityComment.where(community_id: @community.id).order(created_at: "desc")
    @community_comments_deleted = @community_comments.where(is_deleted: true)
    unless @community_member.update(community_member_params)
      flash.now[:alert] = "コミュニティメンバーの更新に失敗しました。"
      render template: "admin/communities/show"
    end
  end

  def destroy
    @community = Community.find(params[:community_id])
    community_member = CommunityMember.find(params[:id])
    @community_members = CommunityMember.where(community_id: @community.id)
    @community_comments = CommunityComment.where(community_id: @community.id).order(created_at: "desc")
    @community_comments_deleted = @community_comments.where(is_deleted: true)
    unless community_member.destroy
      flash.now[:alert] = "コミュニティメンバーの削除に失敗しました。"
      render template: "admin/communities/show"
    end
  end

  private

  def community_member_params
    params.require(:community_member).permit(:is_admin)
  end

  def is_matching_login_admin
    residences = current_admin.residences
    admin_communities = Community.where(residence_id: residences.pluck(:id))
    unless admin_communities.where(id: params[:community_id]).present?
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to admin_communities_path
    end
  end

end
