class Admin::CommunityCommentsController < ApplicationController
  before_action :authenticate_admin!
  
  def update
    community = Community.find(params[:community_id])
    community_comment = CommunityComment.find(params[:id])
    if community_comment.update(community_comment_params)
      redirect_to admin_community_path(community)
    else
      flash.now[:notice] = "更新に失敗しました"
      render template: "admin/communities/show"
    end
  end

  private

  def community_comment_params
    params.require(:community_comment).permit(:is_deleted)
  end
end
