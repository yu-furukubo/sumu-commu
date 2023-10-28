class Admin::ExchangeCommentsController < ApplicationController
  before_action :authenticate_admin!
  before_action :is_matching_login_admin

  def update
    @exchange = Exchange.find(params[:exchange_id])
    exchange_comment = ExchangeComment.find(params[:id])
    if exchange_comment.update(exchange_comment_params)
      redirect_to admin_exchange_path(@exchange)
    else
      flash.now[:alert] = "コメントの削除に失敗しました。"
      @exchange_comments = ExchangeComment.where(exchange_id: @exchange.id)
      render template: "admin/exchanges/show"
    end
  end

  private

  def exchange_comment_params
    params.require(:exchange_comment).permit(:is_deleted)
  end

  def is_matching_login_admin
    residences = current_admin.residences
    admin_exchanges = Exchange.where(residence_id: residences.pluck(:id))
    unless admin_exchanges.where(id: params[:exchange_id]).present?
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to admin_exchanges_path
    end
  end
end
