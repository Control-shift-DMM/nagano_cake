class Public::ItemsController < ApplicationController
  def index
    @items = Item
             .includes(:genre)
             .where(is_active: true)
             .order(:id)
  end

  def show
    @item = Item.find(params[:id])
  end
end