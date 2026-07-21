class Admin::HomesController < Admin::ApplicationController
  def top
    @orders = Order.includes(:customer, :order_details)
                   .order(created_at: :desc)
  end
end
