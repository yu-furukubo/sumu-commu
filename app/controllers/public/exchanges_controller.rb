class Public::ExchangesController < ApplicationController
  before_action :authenticate_member!

  def index
    @exchanges = Exchange.where(residence_id: current_member.residence.id)
    @exchanges_mine = @exchanges.where(member_id: current_member.id)
    @exchanges_others = @exchanges.where.not(member_id: current_member.id)
  end

  def show
    @exchange = Exchange.find(params[:id])
    @exchange_comments = ExchangeComment.where(exchange_id: @exchange.id).order(created_at: "DESC")
    @exchange_comment = ExchangeComment.new
  end

  def new
    @exchange = Exchange.new
  end

  def create
    @exchange = Exchange.new(exchange_params)
    if @exchange.save
      redirect_to public_exchange_path(@exchange)
    else
      render "new"
    end
  end

  def edit
    @exchange = Exchange.find(params[:id])
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
      redirect_to public_exchange_path(@exchange)
    else
      render "edit"
    end
  end

  def destroy
    exchange = Exchange.find(params[:id])
    if exchange.destroy
      redirect_to public_exchanges_path
    else
      flash.now[:notice] = "削除に失敗しました"
      render "show"
    end
  end

  private

  def exchange_params
    params.require(:exchange).permit(:name, :description, :price, :deadline, :is_finished, :member_id, :residence_id, exchange_item_images: [])
  end

end
