class Admin::BoardsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @residences = current_admin.residences
    @residence_id_array = @residences.pluck(:id)
    @boards = Board.where(residence_id: @residence_id_array).order(created_at: "ASC")
    @reads = Read.all
  end

  def residence_search
    @residences = current_admin.residences
    @residence = Residence.find(params[:id])
    @boards = @residence.boards
    @reads = Read.all
  end

  def show
    @board = Board.find(params[:id])
    @circular_members = CircularMember.where(board_id: @board.id)
    @board_checked_members = Read.where(board_id: @board.id, member_id: @circular_members.pluck(:member_id))
  end

  def new
    @board = Board.new
    @residence = Residence.find(params[:board][:residence_id])
  end

  def create
    @board = Board.new(board_params)
    @board.member_id = 0
    if @board.save
      redirect_to admin_board_path(@board)
    else
      flash.now[:alert] = "掲示板の作成に失敗しました。"
      @residence = Residence.find(params[:board][:residence_id])
      render "new"
    end
  end

  def edit
    @board = Board.find(params[:id])
    @residence = @board.residence
  end

  def update
    @board = Board.find(params[:id])
    if @board.update(board_params)
      redirect_to admin_board_path(@board)
    else
      flash.now[:alert] = "掲示板の更新に失敗しました。"
      @residence = @board.residence
      render "edit"
    end
  end

  def destroy
    @board = Board.find(params[:id])
    if @board.destroy
      redirect_to admin_boards_path
    else
      flash.now[:alert] = "削除に失敗しました。"
      @circular_members = CircularMember.where(board_id: @board.id)
      @board_checked_members = Read.where(board_id: @board.id, member_id: @circular_members.pluck(:member_id))
      render "show"
    end
  end

  private

  def board_params
    params.require(:board).permit(:name, :body, :residence_id, :is_circular, :member_id)
  end

end
