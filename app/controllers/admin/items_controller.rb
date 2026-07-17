class Admin::ItemsController < Admin::ApplicationController
  before_action :set_item, only: [ :show, :edit, :update ]

  def index
    @keyword = params[:keyword].to_s.strip
    @items = Item.includes(:genre).order(:id)

    if @keyword.present?
      escaped_keyword = Item.sanitize_sql_like(@keyword)
      @items = @items.where("items.name LIKE ?", "%#{escaped_keyword}%")
    end
  end

  def new
    @item = Item.new
    @genres = Genre.order(:id)
  end

  def create
    @item = Item.new(item_params)

    if @item.save
      redirect_to admin_item_path(@item), notice: "商品を登録しました"
    else
      @genres = Genre.order(:id)
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
    @genres = Genre.order(:id)
  end

  def update
    if @item.update(item_params)
      redirect_to admin_item_path(@item), notice: "商品情報を更新しました"
    else
      @genres = Genre.order(:id)
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(
      :genre_id,
      :name,
      :introduction,
      :price,
      :is_active,
      :image
    )
  end
end
