class Admin::ExchangesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @residences = current_admin.residences
    @residence_id_array = @residences.pluck(:id)
    @exchanges = Exchange.where(residence_id: @residence_id_array).where('deadline > ?', Time.now)
    @exchanges_recruitment = Exchange.where(residence_id: @residence_id_array).where('deadline > ?', Time.now).where(is_finished: false)
    @exchanges_finished = Exchange.where(residence_id: @residence_id_array).where(is_finished: true)
  end

  def residence_search
    @residences = current_admin.residences
    @residence = Residence.find(params[:id])
    @exchanges = @residence.exchanges
  end

  def show
    @exchange = Exchange.find(params[:id])
    @exchange_comments = ExchangeComment.where(exchange_id: @exchange.id)
  end

  def edit
    @exchange = Exchange.find(params[:id])
    @residence = @exchange.residence
  end

  def update
    @exchange = Exchange.find(params[:id])
    if params[:exchange][:image_ids]
      params[:exchange][:image_ids].each do |image_id|
        image = @exchange.exchange_item_images.find(image_id)
        image.purge
      end
    end
    if @exchange.update(exchange_params)
      redirect_to admin_exchange_path(@exchange)
    else
      flash.now[:alert] = "ゆずりあいの内容変更に失敗しました。"
      @residence = @exchange.residence
      render "edit"
    end
  end

  def destroy
    @exchange = Exchange.find(params[:id])
    if @exchange.destroy
      redirect_to admin_exchanges_path
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

end
