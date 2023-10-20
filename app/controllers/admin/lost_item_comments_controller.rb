class Admin::LostItemCommentsController < ApplicationController
  before_action :authenticate_admin!

  def update
    @lost_item = LostItem.find(params[:lost_item_id])
    lost_item_comment = LostItemComment.find(params[:id])
    if lost_item_comment.update(lost_item_comment_params)
      redirect_to admin_lost_item_path(@lost_item)
    else
      flash.now[:notice] = "コメントの削除に失敗しました。"
      @lost_item_comments = LostItemComment.where(lost_item_id: @lost_item.id)
      render template: "admin/lost_items/show"
    end
  end

  private

  def lost_item_comment_params
    params.require(:lost_item_comment).permit(:is_deleted)
  end
end
