class Public::ReadsController < ApplicationController
  before_action :authenticate_member!

  def create
    member = current_member
    board = Board.find(params[:board_id])
    if Read.create(board_id: board.id, member_id: member.id)
      redirect_to public_board_path(board)
    else
      render template: "public/boards/show"
    end
  end

  def destroy
    board = Board.find(params[:board_id])
    read = Read.find_by(board_id: board.id , member_id: current_member.id)
    if read.destroy
      redirect_to public_board_path(board)
    else
      render template: "public/boards/show"
    end
  end

end
