require "test_helper"

class Admin::HomesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = Admin.create!(
      email: "admin@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  test "未ログインでは管理者ログイン画面へ移動する" do
    get admin_root_path

    assert_redirected_to new_admin_session_path
  end

  test "ログイン後は管理者トップを表示できる" do
    sign_in_as_admin @admin

    get admin_root_path

    assert_response :success
    assert_includes response.body, "管理者トップ"
  end
end
