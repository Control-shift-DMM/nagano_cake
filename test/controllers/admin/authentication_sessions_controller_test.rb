require "test_helper"

class Admin::AuthenticationSessionsControllerTest <
      ActionDispatch::IntegrationTest
  setup do
    @admin = Admin.create!(
      email: "admin@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  test "ログイン画面を表示できる" do
    get new_admin_session_path

    assert_response :success
    assert_includes response.body, "管理者ログイン"
  end

  test "正しい情報でログインできる" do
    assert_difference("Session.count", 1) do
      sign_in_as_admin @admin
    end

    assert_redirected_to admin_root_path
    assert_equal @admin, Session.order(:id).last.account
  end

  test "誤ったパスワードではログインできない" do
    assert_no_difference("Session.count") do
      sign_in_as_admin @admin, password: "wrong-password"
    end

    assert_response :unprocessable_entity
  end

  test "ログアウトできる" do
    sign_in_as_admin @admin

    assert_difference("Session.count", -1) do
      delete destroy_admin_session_path
    end

    assert_redirected_to new_admin_session_path
  end
end
