class Admin::CircularMembersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @board = Board.find(params[:board_id])
    @residence_members = @board.residence.members
    @circular_member = CircularMember.new
    pp "=====================================", @board.member_id, @residence_members.count - 1, @board.circular_members.count
  end

  def create
    @circular_member = CircularMember.new(circular_member_params)
    @board = Board.find(params[:board_id])
    if @circular_member.save
      redirect_to admin_board_circular_members_path(@board)
    else
      flash.now[:notice] = "回覧メンバーの追加に失敗しました。"
      @members = @board.residence.members
      render "index"
    end
  end

  def add_all
    @board = Board.find(params[:board_id])
    @residence_members = @board.residence.members
    @residence_members.each do |member|
      if not CircularMember.find_by(board_id: @board.id, member_id: member.id).present? || @board.member_id == member.id
        unless CircularMember.find_or_create_by(board_id: @board.id, member_id: member.id)
          flash.now[:notice] =　"#{member}の回覧メンバー追加に失敗しました。"
          render "index"
          return
        end
      end
    end
    redirect_to admin_board_circular_members_path(@board)
  end

  def destroy
    @board = Board.find(params[:board_id])
    circular_member = @board.circular_members.find_by(member_id: params[:id])
    if circular_member.destroy
      redirect_to admin_board_circular_members_path(@board)
    else
      flash.now[:notice] = "回覧メンバーの削除に失敗しました。"
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
