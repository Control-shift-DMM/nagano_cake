class Public::CartItemsController < ApplicationController
  def index
    @cart_items = current_customer.cart_items
    @total_price = 0 #合計金額　あとで調節
  end

  def update
    # 数量変更の処理
  end

  def destroy
    # 1件削除の処理
  end

  def destroy_all
    # 全削除の処理
  end

  def create
    @cart_item = current_customer.cart_items.new(cart_item_params)
    if @cart_item.save
      redirect_to cart_items_path, notice: 'カートに商品を追加しました。'
    else
      redirect_to items_path, alert: 'カートに商品を追加できませんでした。'
    end
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:item_id, :amount)
  end
end
