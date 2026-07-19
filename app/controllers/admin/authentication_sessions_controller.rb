class Admin::AuthenticationSessionsController < ApplicationController
  def new
  end

  def create
    credentials = params.require(:admin).permit(:email, :password)

    admin = Admin.find_by(
      email: credentials[:email].to_s.strip.downcase
    )

    if admin&.valid_password?(credentials[:password])
      terminate_session if Current.session
      start_new_session_for(admin)

      redirect_to admin_root_path,
                  notice: "管理者としてログインしました"
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    terminate_session

    redirect_to new_admin_session_path,
                notice: "ログアウトしました",
                status: :see_other
  end
end
