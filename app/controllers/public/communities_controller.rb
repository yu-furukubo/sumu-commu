class Public::CommunitiesController < ApplicationController
  before_action :authenticate_member!

  def index
    @communities = Community.where(residence_id: current_member.residence.id)
    @community_members_mine = CommunityMember.where(member_id: current_member.id)
    @communities_mine = @communities.where(id: @community_members_mine.pluck(:community_id))
    @communities_others = @communities.where.not(id: @community_members_mine.pluck(:community_id))
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
      render "edit"
    end
  end

  def destroy
    community = Community.find(params[:id])
    if community.destroy
      redirect_to public_communities_path
    else
      flash.now[:notice] = "削除に失敗しました"
      render "show"
    end
  end

  private

  def community_params
    params.require(:community).permit(:name, :description, :residence_id, :member_id)
  end

end
