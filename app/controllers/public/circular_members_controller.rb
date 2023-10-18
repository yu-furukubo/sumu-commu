class Public::CircularMembersController < ApplicationController
  before_action :authenticate_member!

  def index
    @board = Board.find(params[:board_id])
    @members = @board.residence.members
    @circular_member = CircularMember.new
  end

  def create
    @circular_member = CircularMember.new(circular_member_params)
    board = circular_member.board
    if @circular_member.save
      redirect_to public_board_circular_members_path(board)
    else
      flash.now[:notice] = "回覧メンバーの追加に失敗しました"
      @board = Board.find(params[:board_id])
      @members = @board.residence.members
      render "index"
    end
  end

  def destroy
    @board = Board.find(params[:board_id])
    circular_member = board.circular_members.find_by(member_id: params[:id])
    if circular_member.destroy
      redirect_to public_board_circular_members_path(board)
    else
      flash.now[:notice] = "回覧メンバーの削除に失敗しました"
      @members = @board.residence.members
      @circular_member = CircularMember.new
      render "index"
    end
  end

  private

  def circular_member_params
    params.require(:circular_member).permit(:board_id, :member_id)
  end

end
