class Public::RegistrationsController < ApplicationController
  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      terminate_session if Current.session
      start_new_session_for(@customer)

      redirect_to root_path,
                  notice: "会員登録が完了しました"
    else
      render :new, status: :unprocessable_entity
    end
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
      :email,
      :password,
      :password_confirmation
    )
  end
end
