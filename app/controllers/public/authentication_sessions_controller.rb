class Public::AuthenticationSessionsController < ApplicationController
  def new
  end

  def create
    credentials = params.require(:customer).permit(:email, :password)

    customer = Customer.find_by(
      email: credentials[:email].to_s.strip.downcase
    )

    if customer&.is_active? &&
       customer.valid_password?(credentials[:password])
      terminate_session if Current.session
      start_new_session_for(customer)

      redirect_to root_path,
                  notice: "ログインしました"
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    terminate_session

    redirect_to new_customer_session_path,
                notice: "ログアウトしました",
                status: :see_other
  end
end
