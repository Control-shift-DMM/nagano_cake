class Admin::OrdersController < Admin::ApplicationController
  before_action :set_order, only: [ :show, :update ]

  def show
  end

  def update
    if @order.update(order_params)
      update_order_details_status
      redirect_to admin_order_path(@order),
                  notice: "注文ステータスを更新しました"
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order.includes(:customer, order_details: :item)
                  .find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status)
  end

  def update_order_details_status
    return unless @order.payment_confirmation?

    @order.order_details.update_all(
      making_status: OrderDetail.making_statuses[:waiting_for_creation],
      updated_at: Time.current
    )
  end
end
