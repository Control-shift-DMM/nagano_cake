require "test_helper"

class Public::AuthenticationSessionsControllerTest <
      ActionDispatch::IntegrationTest
  setup do
    @customer = Customer.create!(
      last_name: "山田",
      first_name: "太郎",
      last_name_kana: "ヤマダ",
      first_name_kana: "タロウ",
      postal_code: "1234567",
      address: "東京都千代田区",
      telephone_number: "09012345678",
      email: "customer@example.com",
      password: "password",
      password_confirmation: "password",
      is_active: true
    )
  end

  test "ログイン画面を表示できる" do
    get new_customer_session_path

    assert_response :success
    assert_includes response.body, "会員ログイン"
  end

  test "正しい情報でログインできる" do
    assert_difference("Session.count", 1) do
      sign_in_as_customer @customer
    end

    assert_redirected_to root_path
    assert_equal @customer, Session.order(:id).last.account
  end

  test "誤ったパスワードではログインできない" do
    assert_no_difference("Session.count") do
      sign_in_as_customer @customer, password: "wrong-password"
    end

    assert_response :unprocessable_entity
  end

  test "退会済みの会員はログインできない" do
    @customer.update!(is_active: false)

    assert_no_difference("Session.count") do
      sign_in_as_customer @customer
    end

    assert_response :unprocessable_entity
  end

  test "ログアウトできる" do
    sign_in_as_customer @customer

    assert_difference("Session.count", -1) do
      delete destroy_customer_session_path
    end

    assert_redirected_to new_customer_session_path
  end
end
