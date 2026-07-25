class Public::OrdersController < ApplicationController
  before_action :require_customer_authentication
  before_action :check_cart_item_empty, only: [:new]
  before_action :set_order_and_cart_items ,only: [:confirm ,:create]

  #注文情報入力画面
  def new
    @order = current_customer.orders.new
    # ログイン顧客が登録してる配送先のレコード全取得
    @addresses = current_customer.addresses
  end

  #注文情報確認画面
  def confirm
    set_order_address

    unless @order.valid?(:confirm)
      @addresses = current_customer.addresses
      render :new, status: :unprocessable_entity
      return
    end
  end

  #サンクスページ
  def complete
    redirect_to root_path unless session[:order_completed]
    session.delete(:order_completed)
  end

  #注文情報確認画面 → 注文確定処理
  def create
    ActiveRecord::Base.transaction do
      @order.save!
      @cart_items.each do |cart_item|
        @order.order_details.create!(
          item_id: cart_item.item_id,
          price: cart_item.item.with_tax_price,
          amount: cart_item.amount
        )
      end

      @cart_items.destroy_all
      # raise StandardError, "わざと例外を発生"
    end
    
    session[:order_completed] = true
    redirect_to complete_orders_path

  # save・create処理で例外が発生した場合値をロールバックしこの処理を実行(トランザクション処理)
  # インデントはdef createと同じ位置が正常位置
  rescue ActiveRecord::RecordInvalid
    flash[:alert] = "注文に失敗しました。"
    redirect_to new_order_path
  end

  #注文情報一覧画面
  def index
    @orders = current_customer.orders
                              .includes(order_details: :item)
                              .order(created_at: :desc)
  end

  #注文情報詳細画面
  def show
    @order = current_customer.orders
                             .includes(order_details: :item)
                             .find(params[:id])
  end

  private
  def order_params
    params.require(:order).permit(
      :payment_method,
      :postal_code,
      :address,
      :name,
      :select_address,
      :address_id
    )
  end

  # カート内商品が空であるか確認
  def check_cart_item_empty
    if current_customer.cart_items.empty?
      redirect_to cart_items_path alert: "カート内の商品が空です"
    end
  end

  # confirm、create処理の前にorderとcart_itemsをセット
  def set_order_and_cart_items
    @order = current_customer.orders.new(order_params)
    @cart_items = current_customer.cart_items.includes(:item)

    @order.shipping_cost = 800
    @order.total_payment = @cart_items.sum(&:calc_sub_total) + @order.shipping_cost
  end

  # 郵便番号・住所・宛名をセットする処理
  def set_order_address
    case params[:order][:select_address]
    when "0"  #ご自身の住所の場合 値の上書き
      @order.postal_code = current_customer.postal_code
      @order.address     = current_customer.address
      @order.name        = "#{current_customer.last_name}#{current_customer.first_name}"

    when "1" #登録済み住所の場合 値の上書き

      if params[:order][:address_id].blank?
        @order.errors.add(:address_id, "を選択してください")
        return
      end

      address = current_customer.addresses.find(params[:order][:address_id])

      @order.postal_code = address.postal_code
      @order.address     = address.address
      @order.name        = address.name

    when "2" #新しいお届け先の場合
      # order_paramsで既に代入済み
    end

  end
end
