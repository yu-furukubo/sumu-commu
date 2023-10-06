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
  end

  def new
    @board = Board.new
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
      redirect_to admin_borads_path
    else
      flash.now[:notice] = "削除に失敗しました"
      render "show"
    end
  end

  private

  def board_params
    params.require(:board).permit(:name, :body)
  end

end
