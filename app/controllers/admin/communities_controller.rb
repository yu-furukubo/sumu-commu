class Admin::CommunitiesController < ApplicationController
  before_action :authenticate_admin!
  before_action :is_matching_login_admin, {only: [:show, :edit, :update, :destroy]}

  def index
    @residences = current_admin.residences
    @residence_id_array = @residences.pluck(:id)
    @communities = Community.where(residence_id: @residence_id_array).order(created_at: "ASC")
  end

  def residence_search
    @residences = current_admin.residences
    @residence = Residence.find(params[:id])
    @communities = @residence.communities
  end

  def show
    @community = Community.find(params[:id])
    @community_members = CommunityMember.where(community_id: @community.id)
    @community_comments = CommunityComment.where(community_id: @community.id).order(created_at: "desc")
    @community_comments_deleted = @community_comments.where(is_deleted: true)
  end

  def edit
    @community = Community.find(params[:id])
    @residence = @community.residence
  end

  def update
    @community = Community.find(params[:id])
    if @community.update(community_params)
      redirect_to admin_community_path(@community)
    else
      flash.now[:alert] = "コミュニティの更新に失敗しました。"
      @residence = @community.residence
      render "edit"
    end
  end

  def destroy
    @community = Community.find(params[:id])
    if @community.destroy
      redirect_to admin_communities_path
    else
      flash.now[:notice] = "コミュニティの削除に失敗しました。"
      @community_members = CommunityMember.where(community_id: @community.id)
      @community_comments = CommunityComment.where(community_id: @community.id)
      render "show"
    end
  end

  private

  def community_params
    params.require(:community).permit(:name, :description, :residence_id, :member_id, :community_image)
  end

  def is_matching_login_admin
    residences = current_admin.residences
    admin_communities = Community.where(residence_id: residences.pluck(:id))
    unless admin_communities.where(id: params[:id]).present?
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to admin_communities_path
    end
  end

end
