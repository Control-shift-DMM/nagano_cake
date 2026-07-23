class Public::CustomersController < ApplicationController
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
      :is_active
    )
  end
end
