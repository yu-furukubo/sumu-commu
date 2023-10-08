class Admin::CircularMembersController < ApplicationController
  def index
  end

  def new
    @board = Board.find(params[:board_id])
    @members = @board.residence.members
    @circular_member = CircularMember.new
  end

  def create
    circular_member = CircularMember.new(circular_member_params)
    board = circular_member.board
    if circular_member.save
      flash[:notice] = "You have updated book successfully."
      redirect_to new_admin_board_circular_member_path(board)
    else
      redirect_back fallback_location: root_path
    end
  end

    def destroy
    board = Board.find(params[:board_id])
    circular_member = board.circular_members.find_by(member_id: params[:id])
    if circular_member.destroy
      flash.now[:notice] = "削除に成功しました"
      redirect_to new_admin_board_circular_member_path(board)
    else
      flash.now[:notice] = "削除に失敗しました"
      render "show"
    end
  end

  private

  def circular_member_params
    params.require(:circular_member).permit(:board_id, :member_id, :is_checked)
  end

end
