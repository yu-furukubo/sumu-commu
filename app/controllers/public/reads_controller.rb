class Public::ReadsController < ApplicationController
  before_action :authenticate_member!

  def create
    member = current_member
    @board = Board.find(params[:board_id])
    @circular_members = @board.circular_members
    @board_checked_members = Read.where(board_id: @board.id, member_id: @circular_members.pluck(:member_id))
    @reads = Read.all
    @read = Read.find_by(board_id: @board.id , member_id: member.id)
    unless Read.create(board_id: @board.id, member_id: member.id)
      flash.now[:alert] = "既読への変更に失敗しました。"
      render template: "public/boards/show"
    end
  end

  def destroy
    @board = Board.find(params[:board_id])
    @read = Read.find_by(board_id: @board.id , member_id: current_member.id)
    @circular_members = @board.circular_members
    @board_checked_members = Read.where(board_id: @board.id, member_id: @circular_members.pluck(:member_id))
    @reads = Read.all
    unless @read.destroy
      flash.now[:alert] = "未読への変更に失敗しました。"
      render template: "public/boards/show"
    end
  end

end
