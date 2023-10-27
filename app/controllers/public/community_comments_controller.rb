class Public::CommunityCommentsController < ApplicationController
  before_action :authenticate_member!

  def create
    @community = Community.find(params[:community_id])
    @community_comment = CommunityComment.new(community_comment_params)
    if @community_comment.save
      redirect_to public_community_path(@community)
    else
      if params[:community_comment][:comment] == ""
        flash.now[:alert] = "コメントを１文字以上入力してください。"
      else
        flash.now[:alert] = "コメントの投稿に失敗しました。"
      end
      @community_members = CommunityMember.where(community_id: @community.id)
      @community_comments = CommunityComment.where(community_id: @community.id).order(created_at: "DESC")
      @community_member = CommunityMember.find_by(community_id: @community.id, member_id: current_member.id)
      render template: "public/communities/show"
    end
  end

  def update
    @community = Community.find(params[:community_id])
    community_comment = CommunityComment.find(params[:id])
    if community_comment.update(community_comment_params)
      redirect_to public_community_path(@community)
    else
      flash.now[:alert] = "コメントの削除に失敗しました。"
      @community_members = CommunityMember.where(community_id: @community.id)
      @community_comments = CommunityComment.where(community_id: @community.id).order(created_at: "DESC")
      @community_member = CommunityMember.find_by(community_id: @community.id, member_id: current_member.id)
      @community_comment = CommunityComment.new
      render template: "public/communities/show"
    end
  end

  # def destroy
  #   community = Community.find(params[:community_id])
  #   community_comment = CommunityComment.find(params[:id])
  #   if community_comment.destroy
  #     redirect_to public_community_path(community)
  #   else
  #     flash.now[:notice] = "更新に失敗しました"
  #     render template: "public/communities/show"
  #   end
  # end

  private

  def community_comment_params
    params.require(:community_comment).permit(:community_id, :member_id, :comment, :is_deleted)
  end
end
