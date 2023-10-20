class Public::ReadsController < ApplicationController
  before_action :authenticate_member!

  def create
    member = current_member
    @board = Board.find(params[:board_id])
    if Read.create(board_id: @board.id, member_id: member.id)
      redirect_to public_board_path(@board)
    else
      flash.now[:notice] = "既読への変更に失敗しました。"
      @circular_members = @board.circular_members
      @board_checked_members = Read.where(board_id: @board.id, member_id: @circular_members.pluck(:member_id))
      @reads = Read.all
      @read = Read.find_by(board_id: @board.id , member_id: member.id)
      render template: "public/boards/show"
    end
  end

  def destroy
    @board = Board.find(params[:board_id])
    @read = Read.find_by(board_id: board.id , member_id: current_member.id)
    if @read.destroy
      redirect_to public_board_path(@board)
    else
      flash.now[:notice] = "未読への変更に失敗しました。"
      @circular_members = @board.circular_members
      @board_checked_members = Read.where(board_id: @board.id, member_id: @circular_members.pluck(:member_id))
      @reads = Read.all
      render template: "public/boards/show"
    end
  end

end
