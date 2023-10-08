class Admin::BoardsController < ApplicationController
  def index
    @residences = current_admin.residences
    @residence_id_array = @residences.pluck(:id)
    @boards = Board.where(residence_id: @residence_id_array)
  end

  def residence_search
    @residences = current_admin.residences
    @residence = Residence.find(params[:id])
    @boards = @residence.boards
  end

  def show
    @board = Board.find(params[:id])
    @circular_members = CircularMember.where(board_id: @board.id)
    @board_checked_members = @circular_members.where(is_checked: true)
  end

  def new
    @board = Board.new
  end

  def create
    @board = Board.new(board_params)
    @board.member_id = 0
    if @board.save
      redirect_to new_admin_board_circular_member_path(@board)
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
      redirect_to admin_board_path(@board)
    else
      render "edit"
    end
  end

  def destroy
    board = Board.find(params[:id])
    if board.destroy
      redirect_to admin_boards_path
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
