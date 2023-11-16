class Admin::LostItemCommentsController < ApplicationController
  before_action :authenticate_admin!
  before_action :check_adnmin_residence
  before_action :is_matching_login_admin

  def update
    residences = current_admin.residences
    @lost_item = LostItem.find(params[:lost_item_id])
    lost_item_comment = LostItemComment.find(params[:id])
    @lost_item_comments = LostItemComment.where(lost_item_id: @lost_item.id).order(created_at: "desc")
    @lost_item_comments_deleted = @lost_item_comments.where(is_deleted: true)
    unless lost_item_comment.update(lost_item_comment_params)
      flash.now[:alert] = "コメントの削除に失敗しました。"
      render template: "admin/lost_items/show"
    end
  end

  private

  def lost_item_comment_params
    params.require(:lost_item_comment).permit(:is_deleted)
  end

  def is_matching_login_admin
    residences = current_admin.residences
    admin_lost_items = LostItem.where(residence_id: residences.pluck(:id))
    unless admin_lost_items.where(id: params[:lost_item_id]).present?
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to admin_residence_lost_items_path(params[:residence_id])
    end
  end
end
