class Public::BoardsController < ApplicationController
  before_action :authenticate_member!
  before_action :is_matching_login_member, {only: [:edit, :update, :destroy]}
  before_action :is_matching_residence, {only: [:show]}

  def index
    @reads = Read.all
    @reads_mine = @reads.where(member_id: current_member.id)
    @boards = Board.where(residence_id: current_member.residence.id)
    @boards_read = @boards.where(id: @reads_mine.pluck(:board_id))
    @boards_not_read = @boards.where.not(id: @reads_mine.pluck(:board_id)).where.not(member_id: current_member.id)
    @boards_mine = @boards.where(member_id: current_member.id)
  end

  def show
    @board = Board.find(params[:id])
    @circular_members = @board.circular_members
    @board_checked_members = Read.where(board_id: @board.id, member_id: @circular_members.pluck(:member_id))
    @reads = Read.all
  end

  def new
    @board = Board.new
  end

  def create
    @board = Board.new(board_params)
    if @board.save
      redirect_to board_path(@board)
    else
      flash.now[:alert] = "掲示板の投稿に失敗しました。"
      render "new"
    end
  end

  def edit
    @board = Board.find(params[:id])
  end

  def update
    @board = Board.find(params[:id])
    if @board.update(board_params)
      redirect_to board_path(@board)
    else
      flash.now[:alert] = "掲示板の更新に失敗しました。"
      render "edit"
    end
  end

  def destroy
    @board = Board.find(params[:id])
    if @board.destroy
      redirect_to boards_path
    else
      flash.now[:alert] = "掲示板の削除に失敗しました。"
      @circular_members = @board.circular_members
      @board_checked_members = Read.where(board_id: @board.id, member_id: @circular_members.pluck(:member_id))
      @reads = Read.all
      @read = Read.find_by(board_id: @board.id , member_id: current_member.id)
      render "show"
    end
  end

  private

  def board_params
    params.require(:board).permit(:name, :body, :residence_id, :is_circular, :member_id)
  end

  def is_matching_login_member
    board = Board.find(params[:id])
    unless board.member_id == current_member.id
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to boards_path
    end
  end

  def is_matching_residence
    residence = current_member.residence
    board = Board.find(params[:id])
    unless board.residence == residence
     flash[:alert] = "そのURLにはアクセスできません。"
     redirect_to boards_path
    end
  end

end
