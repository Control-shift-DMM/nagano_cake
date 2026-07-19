class OrdersController < ApplicationController
  before_action :set_order_and_cart_items ,only: [:confirm ,:create]
  before_action :set_payment_info ,only: [:confirm ,:create]
  def new
    @order = Current.customer.orders.new
    # ログイン顧客が登録してる配送先のレコード全取得
    @addresses = Current.customer.addresses
  end

  def confirm
    set_order_element
  end

  def complete
  end

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
    end
    redirect_to complete_orders_path

    # save・create処理で例外が発生したロールバックしこの処理を実行
    rescue ActiveRecord::RecordInvalid
      # データ作成失敗時リダイレクト
      redirect_to new_order_path
    end
  end

  def index
    @orders = Current.customer.orders
                              .includes(order_details: :item)
                              .order(created_at: :desc)
  end

  def show
    @order = Current.customer.orders
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

  def set_order_and_cart_items
    @order = Current.customer.orders.new(order_params)
    @cart_items = Current.customer.cart_items.includes(:item)
  end

  def set_payment_info
    @order.shipping_cost = 800
    @order.total_payment = @cart_items.sum(&:sub_total_method) + @order.shipping_cost
  end

  # 郵便番号・住所・宛名をセットする処理
  def set_order_element
    case params[:order][:select_address]
    when "0"  #ご自身の住所の場合 値の上書き
      @order.postal_code = Current.customer.postal_code
      @order.address     = Current.customer.address
      @order.name        = "#{Current.customer.last_name}#{Current.customer.first_name}"

    when "1" #登録済み住所の場合 値の上書き
      address = Current.customer.addresses.find(params[:order][:address_id])

      @order.postal_code = address.postal_code
      @order.address     = address.address
      @order.name        = address.name

    when "2" #新しいお届け先の場合
      # order_paramsで既に代入済み
    end

  end
end
