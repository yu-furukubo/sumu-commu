class Admin::ExchangesController < ApplicationController
  before_action :authenticate_admin!
  before_action :check_adnmin_residence
  before_action :is_matching_login_admin, {only: [:show, :edit, :update, :destroy]}

  def index
    @residences = current_admin.residences
    @residence = Residence.find(params[:residence_id])
    @exchanges = @residence.exchanges.where('deadline > ?', Time.now).where(is_finished: false)
                .or(Exchange.where(residence_id: @residence_id_array).where(deadline: nil).where(is_finished: false))
    @exchanges_finished = @residence.exchanges.where(is_finished: true)
                          .or(Exchange.where(residence_id: @residence_id_array).where('deadline < ?', Time.now))
  end

  def show
    @residences = current_admin.residences
    @exchange = Exchange.find(params[:id])
    @exchange_comments = ExchangeComment.where(exchange_id: @exchange.id).order(created_at: "desc")
    @exchange_comments_deleted = @exchange_comments.where(is_deleted: true)
  end

  def edit
    @residences = current_admin.residences
    @exchange = Exchange.find(params[:id])
    @residence = @exchange.residence
  end

  def update
    @residences = current_admin.residences
    @exchange = Exchange.find(params[:id])
    if params[:exchange][:image_ids]
      params[:exchange][:image_ids].each do |image_id|
        image = @exchange.exchange_item_images.find(image_id)
        image.purge
      end
    end
    if @exchange.update(exchange_params)
      redirect_to admin_residence_exchange_path(params[:residence_id], @exchange)
    else
      flash.now[:alert] = "ゆずりあいの内容変更に失敗しました。"
      @residence = @exchange.residence
      render "edit"
    end
  end

  def destroy
    @residences = current_admin.residences
    @exchange = Exchange.find(params[:id])
    if @exchange.destroy
      redirect_to admin_residence_exchanges_path(params[:residence_id])
    else
      flash.now[:alert] = "ゆずりあいの削除に失敗しました。"
      @exchange_comments = ExchangeComment.where(exchange_id: @exchange.id)
      render "show"
    end
  end

  private

  def exchange_params
    params.require(:exchange).permit(:name, :description, :price, :deadline, :is_finished, exchange_item_images: [])
  end

  def is_matching_login_admin
    residences = current_admin.residences
    admin_exchanges = Exchange.where(residence_id: residences.pluck(:id))
    unless admin_exchanges.where(id: params[:id]).present?
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to admin_residence_exchanges_path(params[:residence_id])
    end
  end

end
