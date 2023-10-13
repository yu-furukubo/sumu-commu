class Public::CommunityCommentsController < ApplicationController
  before_action :authenticate_member!

  def create
    community = Community.find(params[:community_id])
    community_comment = CommunityComment.new(community_comment_params)
    if community_comment.save
      redirect_to public_community_path(community)
    else
      flash.now[:notice] = "コメントの投稿に失敗しました"
      render template: "admin/communities/show"
    end
  end

  def update
    community = Community.find(params[:community_id])
    community_comment = CommunityComment.find(params[:id])
    if community_comment.update(community_comment_params)
      redirect_to public_community_path(community)
    else
      flash.now[:notice] = "コメントの更新に失敗しました"
      render template: "admin/communities/show"
    end
  end

  def destroy
    community = Community.find(params[:community_id])
    community_comment = CommunityComment.find(params[:id])
    if community_comment.destroy
      redirect_to public_community_path(community)
    else
      flash.now[:notice] = "更新に失敗しました"
      render template: "admin/communities/show"
    end
  end

  private

  def community_comment_params
    params.require(:community_comment).permit(:community_id, :member_id, :comment, :is_deleted)
  end
end
