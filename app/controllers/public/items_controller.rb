class Public::ItemsController < ApplicationController
  def index
    @items = Item.where(is_active: true)
  end

  def show
    @item = Item.find(params[:id])
    @cart_item = CartItem.new
    @genres = Genre.all
  end
end