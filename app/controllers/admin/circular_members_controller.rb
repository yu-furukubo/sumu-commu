class Admin::CircularMembersController < ApplicationController
  before_action :authenticate_admin!
  before_action :is_matching_login_admin

  def index
    @board = Board.find(params[:board_id])
    @residence_members = @board.residence.members
    @circular_member = CircularMember.new
  end

  def create
    @circular_member = CircularMember.new(circular_member_params)
    @board = Board.find(params[:board_id])
    @residence_members = @board.residence.members
    unless @circular_member.save
      flash.now[:alert] = "回覧メンバーの追加に失敗しました。"
      render "index"
    end
  end

  def add_all
    @board = Board.find(params[:board_id])
    @residence_members = @board.residence.members
    @residence_members.each do |member|
      if not CircularMember.find_by(board_id: @board.id, member_id: member.id).present? || @board.member_id == member.id
        unless CircularMember.find_or_create_by(board_id: @board.id, member_id: member.id)
          flash.now[:alert] =　"#{member}の回覧メンバー追加に失敗しました。"
          render "index"
          return
        end
      end
    end
  end

  def destroy
    @board = Board.find(params[:board_id])
    circular_member = @board.circular_members.find_by(member_id: params[:member_id])
    @residence_members = @board.residence.members
    @circular_member = CircularMember.new
    unless circular_member.destroy
      flash.now[:alert] = "回覧メンバーの削除に失敗しました。"
      render "index"
    end
  end

  private

  def circular_member_params
    params.require(:circular_member).permit(:board_id, :member_id)
  end

  def is_matching_login_admin
    residences = current_admin.residences
    admin_boards = Board.where(residence_id: residences.pluck(:id))
    unless admin_boards.where(id: params[:board_id]).present?
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to admin_boards_path
    end
  end

end
