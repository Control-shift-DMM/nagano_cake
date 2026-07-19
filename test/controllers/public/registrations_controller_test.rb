require "test_helper"

class Public::RegistrationsControllerTest <
      ActionDispatch::IntegrationTest
  test "新規登録画面を表示できる" do
    get new_customer_registration_path

    assert_response :success
    assert_includes response.body, "新規会員登録"
  end

  test "正しい情報で会員登録できる" do
    customer_params = {
      last_name: "山田",
      first_name: "花子",
      last_name_kana: "ヤマダ",
      first_name_kana: "ハナコ",
      postal_code: "1234567",
      address: "東京都千代田区",
      telephone_number: "09012345678",
      email: "new-customer@example.com",
      password: "password",
      password_confirmation: "password"
    }

    assert_difference(
      [ "Customer.count", "Session.count" ],
      1
    ) do
      post customer_registration_path,
           params: { customer: customer_params }
    end

    customer = Customer.find_by!(
      email: "new-customer@example.com"
    )

    assert_redirected_to root_path
    assert customer.is_active?
    assert_equal customer, Session.order(:id).last.account
  end

  test "不正な情報では会員登録できない" do
    assert_no_difference(
      [ "Customer.count", "Session.count" ]
    ) do
      post customer_registration_path,
           params: {
             customer: {
               last_name: "山田",
               first_name: "花子",
               last_name_kana: "ヤマダ",
               first_name_kana: "ハナコ",
               postal_code: "1234567",
               address: "東京都千代田区",
               telephone_number: "09012345678",
               email: "invalid-customer@example.com",
               password: "password",
               password_confirmation: "different-password"
             }
           }
    end

    assert_response :unprocessable_entity
  end
end
