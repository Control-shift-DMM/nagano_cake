class Public::CustomersController < ApplicationController
  before_action :require_customer_authentication
  def show
    @customer= Current.account
  end

  def edit
    @customer= Current.account
  end

  def update
    @customer = Current.account
    if @customer.update(customer_params)
      redirect_to customers_my_page_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def unsubscribe
    @customer = Current.account
  end

  def withdraw
    @customer = Current.account

    @customer.update(is_active: false)

    terminate_session

    redirect_to root_path, notice: "退会処理が完了しました"
  end

  private

  def customer_params
    params.require(:customer).permit(
      :last_name,
      :first_name,
      :last_name_kana,
      :first_name_kana,
      :postal_code,
      :address,
      :telephone_number,
      :email
    )
  end
end
