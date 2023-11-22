class Public::CommunityCommentsController < ApplicationController
  before_action :authenticate_member!
  before_action :is_matching_admin_member, {only: [:update]}
  before_action :is_matching_residence, {only: [:create]}

  def create
    @community = Community.find(params[:community_id])
    @community_comment = CommunityComment.new(community_comment_params)
    @community_members = CommunityMember.where(community_id: @community.id)
    @community_comments = CommunityComment.where(community_id: @community.id).order(created_at: "DESC")
    if params[:community_comment][:comment] == ""
      flash.now[:alert] = "コメントを１文字以上入力してください。"
      return
    end
    unless @community_comment.save
      flash.now[:alert] = "コメントの投稿に失敗しました。"
      render template: "public/communities/show"
    end
  end

  def update
    @community = Community.find(params[:community_id])
    community_comment = CommunityComment.find(params[:id])
    @community_members = CommunityMember.where(community_id: @community.id)
    @community_comments = CommunityComment.where(community_id: @community.id).order(created_at: "DESC")
    @community_comment = CommunityComment.new
    unless community_comment.update(community_comment_params)
      flash.now[:alert] = "コメントの削除に失敗しました。"
      render template: "public/communities/show"
    end
  end

  # def destroy
  #   community = Community.find(params[:community_id])
  #   community_comment = CommunityComment.find(params[:id])
  #   if community_comment.destroy
  #     redirect_to community_path(community)
  #   else
  #     flash.now[:notice] = "更新に失敗しました"
  #     render template: "public/communities/show"
  #   end
  # end

  private

  def community_comment_params
    params.require(:community_comment).permit(:community_id, :member_id, :comment, :is_deleted)
  end

  def is_matching_admin_member
    community = Community.find(params[:community_id])
    unless community.community_members.find_by(member_id: current_member.id, is_admin: true)
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to communities_path
    end
  end

  def is_matching_residence
    residence = current_member.residence
    community = Community.find(params[:community_id])
    unless community.residence == residence
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to communities_path
    end
  end

end
