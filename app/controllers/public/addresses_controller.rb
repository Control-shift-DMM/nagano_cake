class Public::AddressesController < ApplicationController
  # before_action :authenticate_customer!

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
