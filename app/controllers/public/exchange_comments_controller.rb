class Public::ExchangeCommentsController < ApplicationController
  before_action :authenticate_member!

  def create
    exchange = Exchange.find(params[:exchange_id])
    exchange_comment = ExchangeComment.new(exchange_comment_params)
    if exchange_comment.save
      redirect_to public_exchange_path(exchange)
    else
      flash.now[:notice] = "コメントの投稿に失敗しました"
      render template: "public/exchanges/show"
    end
  end

  def update
    exchange = Exchange.find(params[:exchange_id])
    exchange_comment = ExchangeComment.find(params[:id])
    if exchange_comment.update(exchange_comment_params)
      redirect_to public_exchange_path(exchange)
    else
      flash.now[:notice] = "コメントの更新に失敗しました"
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

end
