class Public::LostItemsController < ApplicationController
  before_action :authenticate_member!

  def index
    @lost_items = LostItem.where(residence_id: current_member.residence.id).where('deadline > ?', Time.now)
    @lost_items_storage = LostItem.where(residence_id: current_member.residence.id).where('deadline > ?', Time.now).where(is_finished: false)
    @lost_items_finished = LostItem.where(residence_id: current_member.residence.id).where(is_finished: true)
    @lost_items_mine = @lost_items.where(member_id: current_member.id)
  end

  def show
    @lost_item = LostItem.find(params[:id])
    @lost_item_comments = LostItemComment.where(lost_item_id: @lost_item.id).order(created_at: "DESC")
    @lost_item_comment = LostItemComment.new
  end

  def new
    @lost_item = LostItem.new
  end

  def create
    @lost_item = LostItem.new(lost_item_params)

    if params[:lost_item][:deadline] == "" || params[:lost_item][:picked_up_at] == ""
      flash.now[:alert] = "拾った日時・掲載期限を入力してください。"
      render "new"
      return
    end

    if @lost_item.save
      redirect_to public_lost_item_path(@lost_item)
    else
      flash.now[:alert] = "落とし物の登録に失敗しました。"
      render "new"
    end
  end

  def edit
    @lost_item = LostItem.find(params[:id])
  end

  def update
    @lost_item = LostItem.find(params[:id])

    if params[:lost_item][:deadline] == "" || params[:lost_item][:picked_up_at] == ""
      flash.now[:alert] = "拾った日時・掲載期限を入力してください。"
      render "edit"
      return
    end

    if params[:lost_item][:image_ids]
      params[:lost_item][:image_ids].each do |image_id|
        image = @lost_item.lost_item_images.find(image_id)
        image.purge
      end
    end
    if @lost_item.update(lost_item_params)
      redirect_to public_lost_item_path(@lost_item)
    else
      flash.now[:alert] = "落とし物内容の変更に失敗しました。"
      render "edit"
    end
  end

  def destroy
    @lost_item = LostItem.find(params[:id])
    if @lost_item.destroy
      redirect_to public_lost_items_path
    else
      flash.now[:alert] = "落とし物の削除に失敗しました。"
      @lost_item_comments = LostItemComment.where(lost_item_id: @lost_item.id).order(created_at: "DESC")
      @lost_item_comment = LostItemComment.new
      render "show"
    end
  end

  private

  def lost_item_params
    params.require(:lost_item).permit(:name, :description, :picked_up_location, :picked_up_at, :storage_location, :deadline, :is_finished, :member_id, :residence_id, lost_item_images: [])
  end

end
