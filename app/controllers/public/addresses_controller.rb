class Public::AddressesController < ApplicationController
  # Deviseの標準認証（後で戻す可能性があるので念のため残す）
  # before_action :authenticate_customer!

  before_action :require_customer_authentication
  
  def index
    @address = Address.new
    @addresses = current_customer.addresses
  end

  def create
    @address = Address.new(address_params)
    @address.customer_id = current_customer.id

    if @address.save
      redirect_to addresses_path, notice: "配送先を登録しました。"
    else
      @addresses = current_customer.addresses
      render :index
    end
  end

  def edit
  end

  private

  def address_params
    params.require(:address).permit(:postal_code, :address, :name)
  end
  
end
