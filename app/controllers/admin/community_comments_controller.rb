class Admin::CommunityCommentsController < ApplicationController
  def destroy
    community_comment = CommunityComment.find(params[:id])
    community = community_comment.community
    if community_comment.destroy
      redirect_to admin_community_path(community)
    else
      flash.now[:notice] = "削除に失敗しました"
      render "communities#show"
    end
  end
end
