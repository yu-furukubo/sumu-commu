class Admin::LostItemsController < ApplicationController
  before_action :authenticate_admin!
  before_action :check_adnmin_residence
  before_action :is_matching_login_admin, {only: [:show, :edit, :update, :destroy]}

  def index
    @residences = current_admin.residences
    @residence = Residence.find(params[:residence_id])
    @lost_items = @residence.lost_items.where(is_finished: false).order(picked_up_at: "DESC")
    @lost_items_finished = @residence.lost_items.where(is_finished: true).order(picked_up_at: "DESC")
  end

  def show
    @residences = current_admin.residences
    @lost_item = LostItem.find(params[:id])
    @lost_item_comments = LostItemComment.where(lost_item_id: @lost_item.id).order(created_at: "desc")
    @lost_item_comments_deleted = @lost_item_comments.where(is_deleted: true)
  end

  def new
    @residences = current_admin.residences
    @lost_item = LostItem.new
    @residence = Residence.find(params[:lost_item][:residence_id])
  end

  def create
    @lost_item = LostItem.new(lost_item_params)
    @lost_item.member_id = 0
    if @lost_item.save
      redirect_to admin_residence_lost_item_path(params[:residence_id], @lost_item)
    else
      flash.now[:alert] = "落とし物の登録に失敗しました。"
      @residences = current_admin.residences
      @residence = Residence.find(params[:lost_item][:residence_id])
      render "new"
    end
  end

  def edit
    @residences = current_admin.residences
    @lost_item = LostItem.find(params[:id])
    @residence = @lost_item.residence
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
      redirect_to admin_residence_lost_item_path(params[:residence_id], @lost_item)
    else
      flash.now[:alert] = "落とし物内容の変更に失敗しました。"
      @residences = current_admin.residences
      @residence = @lost_item.residence
      render "edit"
    end
  end

  def destroy
    @lost_item = LostItem.find(params[:id])
    if @lost_item.destroy
      redirect_to admin_residence_lost_items_path(params[:residence_id])
    else
      flash.now[:alert] = "落とし物の削除に失敗しました。"
      @residences = current_admin.residences
      @lost_item_comments = LostItemComment.where(lost_item_id: @lost_item.id)
      render "show"
    end
  end

  private

  def lost_item_params
    params.require(:lost_item).permit(:name, :description, :picked_up_location, :picked_up_at, :storage_location, :is_finished, :residence_id, lost_item_images: [])
  end

  def is_matching_login_admin
    residences = current_admin.residences
    admin_lost_items = LostItem.where(residence_id: residences.pluck(:id))
    unless admin_lost_items.where(id: params[:id]).present?
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to admin_residence_lost_items_path(params[:residence_id])
    end
  end
end
