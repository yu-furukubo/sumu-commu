class Public::LostItemCommentsController < ApplicationController
  before_action :authenticate_member!
  before_action :is_matching_login_member, {only: [:update]}
  before_action :is_matching_residence, {only: [:create]}

  def create
    @lost_item = LostItem.find(params[:lost_item_id])
    @lost_item_comment = LostItemComment.new(lost_item_comment_params)
    if @lost_item_comment.save
      redirect_to public_lost_item_path(@lost_item)
    else
      if params[:lost_item_comment][:comment] == ""
        flash.now[:alert] = "コメントを１文字以上入力してください。"
      else
        flash.now[:alert] = "コメントの投稿に失敗しました。"
      end
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
      flash.now[:alert] = "コメントの削除に失敗しました。"
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

  def is_matching_login_member
    lost_item = LostItem.find(params[:lost_item_id])
    unless lost_item.member_id == current_member.id
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to public_lost_items_path
    end
  end

  def is_matching_residence
    residence = current_member.residence
    lost_item = LostItem.find(params[:lost_item_id])
    unless lost_item.residence == residence
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to public_lost_items_path
    end
  end

end
