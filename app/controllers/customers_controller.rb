class CustomersController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]

  def new
    @customer = Customer.new
  end

  def create
     @customer = Customer.new(customer_params)
    if @customer.save
      start_new_session_for(@customer)
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
  end

  def show
  end

  def edit
  end

  private

  def customer_params
    params.require(:customer).permit(:sur_name, :name, :sur_name_kana, :name_kana, :email, :post_code, :address, :tel, :password, :password_confirmation)
  end
end
