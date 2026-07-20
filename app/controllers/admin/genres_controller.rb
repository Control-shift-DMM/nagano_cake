class Admin::GenresController < Admin::ApplicationController
  before_action :set_genre, only: [ :edit, :update ]

  def index
    @genres = Genre.order(:id)
    @genre = Genre.new
  end

  def create
    @genre = Genre.new(genre_params)

    if @genre.save
      redirect_to admin_genres_path, notice: "ジャンルを追加しました"
    else
      @genres = Genre.order(:id)
      render :index, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @genre.update(genre_params)
      redirect_to admin_genres_path, notice: "ジャンルを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_genre
    @genre = Genre.find(params[:id])
  end

  def genre_params
    params.require(:genre).permit(:name)
  end
end
