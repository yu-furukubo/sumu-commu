class Public::CommunityMembersController < ApplicationController
  before_action :authenticate_member!

  def index
    @community = Community.find(params[:community_id])
    @community_members = @community.community_members
    @community_member = @community_members.find_by(member_id: current_member.id)
  end

  def create
    community = Community.find(params[:community_id])
    member = current_member
    if CommunityMember.create(community_id: community.id, member_id: member.id)
      redirect_to public_community_path(community)
    else
      flash.now[:notice] = "メンバーの追加に失敗しました"
      render "index"
    end
  end

  def update
    @community = Community.find(params[:community_id])
    @community_member = CommunityMember.find(params[:id])
    if @community_member.update(community_member_params)
      redirect_to public_community_path(@community)
    else
      flash.now[:notice] = "更新に失敗しました"
      render "index"
    end
  end

  def destroy
    community = Community.find(params[:community_id])
    community_member = CommunityMember.find_by(member_id: params[:id])
    if community_member.destroy
      redirect_to public_community_path(community)
    else
      flash.now[:notice] = "削除に失敗しました"
      render "index"
    end
  end

  private

  def community_member_params
    params.require(:community_member).permit(:is_admin)
  end
end
