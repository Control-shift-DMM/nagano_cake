class Public::ItemsController < ApplicationController
  def index
    @items = Item
             .includes(:genre)
             .where(is_active: true)
             .order(:id)

             @genres = Genre.all
  end

  def show
    @item = Item.find(params[:id])
    @cart_item = CartItem.new
    @genres = Genre.all
  end
end