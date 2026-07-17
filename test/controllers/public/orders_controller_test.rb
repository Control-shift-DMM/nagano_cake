require "test_helper"

class Public::OrdersControllerTest < ActionDispatch::IntegrationTest

  test "注文情報入力画面が表示される" do
    customer = Customer.create!(
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

    Current.stub(:account, customer) do
      get orders_url

      assert_response :success
    end
  end

  test "注文情報一覧画面が表示される" do
    get orders_url

    assert_response :success
  end
end
