class Admin::ExchangeCommentsController < ApplicationController
  def destroy
    exchange_comment = ExchangeComment.find(params[:id])
    exchange = exchange_comment.exchange
    if exchange_comment.destroy
      redirect_to admin_exchange_path(exchange)
    else
      flash.now[:notice] = "削除に失敗しました"
      render "exchanges#show"
    end
  end
end
