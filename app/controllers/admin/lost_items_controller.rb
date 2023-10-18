class Admin::LostItemsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @residences = current_admin.residences
    @residence_id_array = @residences.pluck(:id)
    @lost_items = LostItem.where(residence_id: @residence_id_array)
  end

  def residence_search
    @residences = current_admin.residences
    @residence = Residence.find(params[:id])
    @lost_items = @residence.lost_items
  end

  def show
    @lost_item = LostItem.find(params[:id])
    @lost_item_comments = LostItemComment.where(lost_item_id: @lost_item.id)
  end

  def new
    @lost_item = LostItem.new
    @residence = Residence.find(params[:lost_item][:residence_id])
  end

  def create
    @lost_item = LostItem.new(lost_item_params)
    @lost_item.member_id = 0
    if @lost_item.save
      redirect_to admin_lost_item_path(@lost_item)
    else
      render "new"
    end
  end

  def edit
    @lost_item = LostItem.find(params[:id])
  end

  def update
    @lost_item = LostItem.find(params[:id])
    if params[:lost_item][:image_ids]
      params[:lost_item][:image_ids].each do |image_id|
        image = @lost_item.lost_item_images.find(image_id)
        image.purge
      end
    end
    if @lost_item.update(lost_item_params)
      redirect_to admin_lost_item_path(@lost_item)
    else
      render "edit"
    end
  end

  def destroy
    lost_item = LostItem.find(params[:id])
    if lost_item.destroy
      redirect_to admin_lost_items_path
    else
      flash.now[:notice] = "削除に失敗しました"
      render "show"
    end
  end

  private

  def lost_item_params
    params.require(:lost_item).permit(:name, :description, :picked_up_location, :picked_up_at, :storage_location, :deadline, :is_finished, :residence_id, lost_item_images: [])
  end
end
