class Public::CommunityMembersController < ApplicationController
  before_action :authenticate_member!
  before_action :is_matching_login_member, {only: [:update]}
  before_action :is_matching_residence, {except: [:update]}

  def index
    @community = Community.find(params[:community_id])
    @community_members = @community.community_members
    @community_member = @community_members.find_by(member_id: current_member.id)
  end

  def create
    @community = Community.find(params[:community_id])
    @community_members = @community.community_members
    @community_comments = @community.community_comments.order(created_at: "DESC")
    @community_comment = CommunityComment.new
    if @community.member == current_member
      unless CommunityMember.create(community_id: @community.id, member_id: current_member.id, is_admin: true)
        flash.now[:alert] = "コミュニティへの参加に失敗しました。"
        render "index"
        return
      end
      return
    end
    unless CommunityMember.create(community_id: @community.id, member_id: current_member.id)
      flash.now[:alert] = "コミュニティへの参加に失敗しました。"
      render "index"
    end
  end

  def update
    @community = Community.find(params[:community_id])
    community_member = @community.community_members.find(params[:id])
    unless community_member.update(community_member_params)
      flash.now[:alert] = "コミュニティメンバーの権限変更に失敗しました。"
      @community_members = @community.community_members
      @community_member = @community_members.find_by(member_id: current_member.id)
      render "index"
    end
  end

  def destroy
    @community = Community.find(params[:community_id])
    community_member = CommunityMember.find(params[:id])
    @community_members = @community.community_members
    @community_comments = @community.community_comments.order(created_at: "desc")
    @community_comments_deleted = @community_comments.where(is_deleted: true)
    unless community_member.destroy
      flash.now[:alert] = "コミュニティメンバーの削除に失敗しました。"
      render "index"
    end
  end

  def quit
    @community = Community.find(params[:community_id])
    community_member =  @community.community_members.find_by(member_id: current_member.id)
    @community_members = @community.community_members
    @community_comments = @community.community_comments.order(created_at: "DESC")
    @community_comments_deleted = @community_comments.where(is_deleted: true)
    unless community_member.destroy
      flash.now[:alert] = "コミュニティからの脱退に失敗しました。"
      render "index"
    end
  end

  private

  def community_member_params
    params.require(:community_member).permit(:is_admin)
  end

  def is_matching_login_member
    community = Community.find(params[:community_id])
    community_admin = community.community_members.where(is_admin: true)
    unless community_admin.find_by(member_id: current_member.id).present?
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
