class Admin::ExchangeCommentsController < ApplicationController
  before_action :authenticate_admin!
  before_action :check_adnmin_residence
  before_action :is_matching_login_admin

  def update
    @residences = current_admin.residences
    @exchange = Exchange.find(params[:exchange_id])
    exchange_comment = ExchangeComment.find(params[:id])
    @exchange_comments = ExchangeComment.where(exchange_id: @exchange.id).order(created_at: "desc")
    @exchange_comments_deleted = @exchange_comments.where(is_deleted: true)
    unless exchange_comment.update(exchange_comment_params)
      flash.now[:alert] = "コメントの削除に失敗しました。"
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
     redirect_to admin_residence_exchanges_path(params[:residence_id])
    end
  end
end
