class Public::CartItemsController < ApplicationController

  before_action :require_customer_authentication

  def index
    @cart_items = current_customer.cart_items
    @total_price = 0 #合計金額　あとで調節
  end

  def update
    @cart_item = current_customer.cart_items.find(params[:id])
    if @cart_item.update(cart_item_params)
      redirect_to cart_items_path, notice: "カート内の商品を更新しました。"
    else
      redirect_to cart_items_path, alert: "カート内の商品を更新できませんでした。"
    end
  end

  def destroy
    @cart_item = current_customer.cart_items.find(params[:id])
    @cart_item.destroy
    redirect_to cart_items_path, notice: "カート内の商品を削除しました。"
  end

  def destroy_all
    current_customer.cart_items.destroy_all
    redirect_to cart_items_path, notice: "カート内の商品をすべて削除しました。"
  end

  def create
    @cart_item = current_customer.cart_items.new(cart_item_params)
    current_cart_item = current_customer.cart_items.find_by(item_id: @cart_item.item_id)
    if @cart_item.amount.nil?
      redirect_to item_path(@cart_item.item_id), alert: 'カートに商品を追加できませんでした。'
      return
    end

    if current_cart_item.nil?
      if @cart_item.save
        redirect_to cart_items_path, notice: 'カートに商品を追加しました。'
      else
        redirect_to item_path(@cart_item.item_id), alert: 'カートに商品を追加できませんでした。'
      end
    else
      current_cart_item.amount += @cart_item.amount
      if current_cart_item.update(amount: current_cart_item.amount)
        redirect_to cart_items_path, notice: 'カート内の商品を更新しました。'
      else
        redirect_to item_path(@cart_item.item_id), alert: 'カート内の商品を更新できませんでした。'
      end
    end
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:item_id, :amount)
  end
end
