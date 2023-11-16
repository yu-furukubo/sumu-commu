class Admin::BoardsController < ApplicationController
  before_action :authenticate_admin!
  before_action :check_adnmin_residence
  before_action :is_matching_login_admin, {only: [:show, :edit, :update, :destroy]}

  def index
    @residences = current_admin.residences
    @residence = Residence.find(params[:residence_id])
    @boards = @residence.boards.order(created_at: "ASC")
    @reads = Read.all
  end

  def show
    @residences = current_admin.residences
    @board = Board.find(params[:id])
    @circular_members = CircularMember.where(board_id: @board.id)
    @board_checked_members = Read.where(board_id: @board.id, member_id: @circular_members.pluck(:member_id))
  end

  def new
    @residences = current_admin.residences
    @board = Board.new
    @residence = Residence.find(params[:residence_id])
  end

  def create
    @board = Board.new(board_params)
    @board.member_id = 0
    if @board.save
      redirect_to admin_residence_board_path(params[:residence_id], @board)
    else
      flash.now[:alert] = "掲示板の投稿に失敗しました。"
      @residence = Residence.find(params[:residence_id])
      render "new"
    end
  end

  def edit
    @residences = current_admin.residences
    @board = Board.find(params[:id])
    @residence = @board.residence
  end

  def update
    @board = Board.find(params[:id])
    if @board.update(board_params)
      redirect_to admin_residence_board_path(params[:residence_id], @board)
    else
      flash.now[:alert] = "掲示板の更新に失敗しました。"
      @residence = @board.residence
      render "edit"
    end
  end

  def destroy
    @board = Board.find(params[:id])
    if @board.destroy
      redirect_to admin_residence_boards_path
    else
      flash.now[:alert] = "掲示板の削除に失敗しました。"
      @circular_members = CircularMember.where(board_id: @board.id)
      @board_checked_members = Read.where(board_id: @board.id, member_id: @circular_members.pluck(:member_id))
      render "show"
    end
  end

  private

  def board_params
    params.require(:board).permit(:name, :body, :residence_id, :is_circular, :member_id)
  end

  def is_matching_login_admin
    residences = current_admin.residences
    admin_boards = Board.where(residence_id: residences.pluck(:id))
    unless admin_boards.where(id: params[:id]).present?
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to admin_residence_boards_path
    end
  end

end
