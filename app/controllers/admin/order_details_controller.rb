class Admin::OrderDetailsController < Admin::ApplicationController
  before_action :set_order_detail, only: :update

  def update
    if @order_detail.update(order_detail_params)
      update_order_status
      redirect_to admin_order_path(@order_detail.order),
                  notice: "製作ステータスを更新しました"
    else
      redirect_to admin_order_path(@order_detail.order),
                  alert: "製作ステータスを更新できませんでした"
    end
  end

  private

  def set_order_detail
    @order_detail = OrderDetail.find(params[:id])
  end

  def order_detail_params
    params.require(:order_detail).permit(:making_status)
  end

  def update_order_status
    order = @order_detail.order

    if @order_detail.in_production?
      order.update(status: :in_production)
    elsif order.order_details.all?(&:complete?)
      order.update(status: :preparation)
    end
  end
end
