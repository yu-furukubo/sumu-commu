class Public::ReadsController < ApplicationController
  before_action :authenticate_member!

  def create
    member = current_member
    board = Board.find(params[:board_id])
    board_member = board.circular_members.find_by(member_id: member.id)
    if Read.create(board_id: board.id, member_id: member.id)
      if board.is_circular = true && board.circular_members.includes(current_member)
        board_member.update(is_checked: true)
      end
      redirect_to public_board_path(board)
    else
      render template: "public/boards/show"
    end
  end

  def destroy
    board = Board.find(params[:board_id])
    read = Read.find_by(board_id: board.id , member_id: current_member.id)
    board_member = board.circular_members.find_by(member_id: current_member.id)
    if read.destroy
      if board.is_circular = true && board.circular_members.includes(current_member)
        board_member.update(is_checked: false)
      end
      redirect_to public_board_path(board)
    else
      render template: "public/boards/show"
    end
  end

end
