class Admin::CommunityCommentsController < ApplicationController
  before_action :authenticate_admin!
  before_action :check_adnmin_residence
  before_action :is_matching_login_admin

  def update
    @community = Community.find(params[:community_id])
    community_comment = CommunityComment.find(params[:id])
    @community_members = CommunityMember.where(community_id: @community.id)
    @community_comments = CommunityComment.where(community_id: @community.id).order(created_at: "desc")
    @community_comments_deleted = @community_comments.where(is_deleted: true)
    unless community_comment.update(community_comment_params)
      flash.now[:alert] = "コメントの削除に失敗しました。"
      render template: "admin/communities/show"
    end
  end

  private

  def community_comment_params
    params.require(:community_comment).permit(:is_deleted)
  end

  def is_matching_login_admin
    residences = current_admin.residences
    admin_communities = Community.where(residence_id: residences.pluck(:id))
    unless admin_communities.where(id: params[:community_id]).present?
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to admin_residence_communities_path(params[:residence_id])
    end
  end

end
