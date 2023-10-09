class Admin::CommunitiesController < ApplicationController
  def index
    @residences = current_admin.residences
    @residence_id_array = @residences.pluck(:id)
    @communities = Community.where(residence_id: @residence_id_array)
  end

  def residence_search
    @residences = current_admin.residences
    @residence = Residence.find(params[:id])
    @communities = @residence.communities
  end

  def show
    @community = Community.find(params[:id])
    @community_members = CommunityMember.where(community_id: @community.id)
    @community_comments = CommunityComment.where(community_id: @community.id)
  end

  def edit
    @community = Community.find(params[:id])
  end

  def update
    @community = Community.find(params[:id])
    if @community.update(community_params)
      redirect_to admin_community_path(@community)
    else
      render "edit"
    end
  end

  def destroy
    community = Community.find(params[:id])
    if community.destroy
      redirect_to admin_communities_path
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
