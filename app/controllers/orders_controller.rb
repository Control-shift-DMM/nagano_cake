class OrdersController < ApplicationController
  def new
    @order = Current.customer.orders.new
    # ログイン顧客が登録してる配送先のレコード全取得
    @addresses = Current.customer.addresses
  end

  def confirm
    @order = Current.customer.orders.new(order_params)
    set_order
  end

  def complete
  end

  def create
  end

  def index
  end

  def show
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

  # 郵便番号・住所・宛名をセットする処理
  def set_order
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
