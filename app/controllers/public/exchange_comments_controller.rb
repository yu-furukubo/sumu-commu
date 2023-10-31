class Public::ExchangeCommentsController < ApplicationController
  before_action :authenticate_member!
  before_action :is_matching_login_member, {only: [:update]}
  before_action :is_matching_residence, {only: [:create]}

  def create
    @exchange = Exchange.find(params[:exchange_id])
    @exchange_comment = ExchangeComment.new(exchange_comment_params)
    @exchange_comments = ExchangeComment.where(exchange_id: @exchange.id).order(created_at: "DESC")
    if params[:exchange_comment][:comment] == ""
      flash.now[:alert] = "コメントを１文字以上入力してください。"
      return
    end
    unless @exchange_comment.save
      flash.now[:alert] = "コメントの投稿に失敗しました。"
      render template: "public/exchanges/show"
    end
  end

  def update
    @exchange = Exchange.find(params[:exchange_id])
    exchange_comment = ExchangeComment.find(params[:id])
    @exchange_comments = ExchangeComment.where(exchange_id: @exchange.id).order(created_at: "DESC")
    @exchange_comment = ExchangeComment.new
    unless exchange_comment.update(exchange_comment_params)
      flash.now[:alert] = "コメントの削除に失敗しました。"
      render template: "public/exchanges/show"
    end
  end

  # def destroy
  #   exchange = Exchange.find(params[:exchange_id])
  #   exchange_comment = ExchangeComment.find(params[:id])
  #   if exchange_comment.destroy
  #     redirect_to public_exchange_path(exchange)
  #   else
  #     flash.now[:notice] = "更新に失敗しました"
  #     render template: "public/exchanges/show"
  #   end
  # end

  private

  def exchange_comment_params
    params.require(:exchange_comment).permit(:exchange_id, :member_id, :comment, :is_deleted)
  end

  def is_matching_login_member
    exchange = Exchange.find(params[:exchange_id])
    unless exchange.member_id == current_member.id
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to public_exchanges_path
    end
  end

   def is_matching_residence
    residence = current_member.residence
    exchange = Exchange.find(params[:exchange_id])
    unless exchange.residence == residence
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to public_exchanges_path
    end
  end

end
