class Public::CommunitiesController < ApplicationController
  before_action :authenticate_member!
  before_action :is_matching_login_member, {only: [:edit, :update, :destroy]}

  def index
    @communities = Community.where(residence_id: current_member.residence.id)
    @community_members_mine = CommunityMember.where(member_id: current_member.id)
    @communities_join = @communities.where(id: @community_members_mine.pluck(:community_id))
    @communities_not_join = @communities.where.not(id: @community_members_mine.pluck(:community_id))
    @communities_mine = @communities.where(member_id: current_member.id)
  end

  def show
    @community = Community.find(params[:id])
    @community_members = CommunityMember.where(community_id: @community.id)
    @community_comments = CommunityComment.where(community_id: @community.id).order(created_at: "DESC")
    @community_member = CommunityMember.find_by(community_id: @community.id, member_id: current_member.id)
    @community_comment = CommunityComment.new
  end

  def new
    @community = Community.new
  end

  def create
    @community = Community.new(community_params)
    if @community.save
      CommunityMember.create(community_id: @community.id, member_id: current_member.id, is_admin: true)
      redirect_to public_community_path(@community)
    else
      flash.now[:alert] = "コミュニティの作成に失敗しました。"
      render "new"
    end
  end

  def edit
    @community = Community.find(params[:id])
  end

  def update
    @community = Community.find(params[:id])
    if @community.update(community_params)
      redirect_to public_community_path(@community)
    else
      flash.now[:alert] = "コミュニティの更新に失敗しました。"
      render "edit"
    end
  end

  def destroy
    @community = Community.find(params[:id])
    if @community.destroy
      redirect_to public_communities_path
    else
      flash.now[:alert] = "コミュニティの削除に失敗しました。"
      @community_members = CommunityMember.where(community_id: @community.id)
      @community_comments = CommunityComment.where(community_id: @community.id).order(created_at: "DESC")
      @community_member = CommunityMember.find_by(community_id: @community.id, member_id: current_member.id)
      @community_comment = CommunityComment.new
      render "show"
    end
  end

  private

  def community_params
    params.require(:community).permit(:name, :description, :residence_id, :member_id, :community_image)
  end

  def is_matching_login_member
    community = Community.find(params[:id])
    unless community.member_id == current_member.id
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to public_communities_path
    end
  end

end
