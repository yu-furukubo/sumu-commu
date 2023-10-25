class Admin::GenresController < ApplicationController
  before_action :authenticate_admin!

  def index
    @residences = current_admin.residences
    @residence_id_array = @residences.pluck(:id)
    @genres = Genre.where(residence_id: @residence_id_array)
    @genre = Genre.new
  end

  def residence_search
    @residences = current_admin.residences
    @residence = Residence.find(params[:id])
    @genres = @residence.genres
    @genre = Genre.new
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      redirect_to admin_genres_path
    else
      flash.now[:notice] = "ジャンルの追加に失敗しました。"
      @residences = current_admin.residences
      @residence_id_array = @residences.pluck(:id)
      @genres = Genre.where(residence_id: @residence_id_array)
      render "index"
    end
  end

  def edit
    @genre = Genre.find(params[:id])
  end

  def update
    @genre = Genre.find(params[:id])
    if @genre.update(genre_params)
      redirect_to admin_genres_path
    else
      flash[:notice] = "ジャンル名の変更に失敗しました。"
      redirect_to edit_admin_genre_path(@genre)
    end
  end

  private

  def genre_params
    params.require(:genre).permit(:name, :residence_id, :is_deleted)
  end

end
