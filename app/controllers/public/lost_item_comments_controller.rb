class Public::LostItemCommentsController < ApplicationController
  before_action :authenticate_member!

  def create
    @lost_item = LostItem.find(params[:lost_item_id])
    @lost_item_comment = LostItemComment.new(lost_item_comment_params)
    if @lost_item_comment.save
      redirect_to public_lost_item_path(@lost_item)
    else
      flash.now[:notice] = "コメントの投稿に失敗しました"
      @lost_item_comments = LostItemComment.where(lost_item_id: @lost_item.id).order(created_at: "DESC")
      render template: "public/lost_items/show"
    end
  end

  def update
    @lost_item = LostItem.find(params[:lost_item_id])
    lost_item_comment = LostItemComment.find(params[:id])
    if lost_item_comment.update(lost_item_comment_params)
      redirect_to public_lost_item_path(@lost_item)
    else
      flash.now[:notice] = "コメントの削除に失敗しました"
      @lost_item_comments = LostItemComment.where(lost_item_id: @lost_item.id).order(created_at: "DESC")
      @lost_item_comment = LostItemComment.new
      render template: "public/lost_items/show"
    end
  end

  # def destroy
  #   lost_item = LostItem.find(params[:lost_item_id])
  #   lost_item_comment = LostItemComment.find(params[:id])
  #   if lost_item_comment.destroy
  #     redirect_to public_lost_item_path(lost_item)
  #   else
  #     flash.now[:notice] = "更新に失敗しました"
  #     render template: "public/lost_items/show"
  #   end
  # end

  private

  def lost_item_comment_params
    params.require(:lost_item_comment).permit(:lost_item_id, :member_id, :comment, :is_deleted)
  end

end
