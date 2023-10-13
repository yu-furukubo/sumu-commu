class Public::BoardsController < ApplicationController
  before_action :authenticate_member!

  def index
    @boards = Board.where(residence_id: current_member.residence.id)
    @boards_mine = @boards.where(member_id: current_member.id)
    @boards_others = @boards.where.not(member_id: current_member.id)
    @reads = Read.all
  end

  def show
    @board = Board.find(params[:id])
    @circular_members = @board.circular_members
    @board_checked_members = Read.where(board_id: @board.id, member_id: @circular_members.pluck(:member_id))
    @reads = Read.all
    @read = Read.find_by(board_id: @board.id , member_id: current_member.id)
  end

  def new
    @board = Board.new
  end

  def create
    @board = Board.new(board_params)
    if @board.save
      redirect_to public_board_path(@board)
    else
      render "new"
    end
  end

  def edit
    @board = Board.find(params[:id])
  end

  def update
    @board = Board.find(params[:id])
    if @board.update(board_params)
      redirect_to public_board_path(@board)
    else
      render "edit"
    end
  end

  def destroy
    board = Board.find(params[:id])
    if board.destroy
      redirect_to public_boards_path
    else
      flash.now[:notice] = "削除に失敗しました"
      render "show"
    end
  end

  private

  def board_params
    params.require(:board).permit(:name, :body, :residence_id, :is_circular, :member_id)
  end

end
