class Admin::LostItemCommentsController < ApplicationController
  def destroy
    lost_item_comment = LostItemComment.find(params[:id])
    lost_item = lost_item_comment.lost_item
    if lost_item_comment.destroy
      redirect_to admin_lost_item_path(lost_item)
    else
      flash.now[:notice] = "削除に失敗しました"
      render template: "admin/lost_items/show"
    end
  end
end
