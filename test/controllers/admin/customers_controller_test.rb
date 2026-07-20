require "test_helper"

class Admin::CustomersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = Admin.create!(
      email: "admin@example.com",
      password: "password",
      password_confirmation: "password"
    )

    @customer = Customer.create!(
      last_name: "山田",
      first_name: "花子",
      last_name_kana: "ヤマダ",
      first_name_kana: "ハナコ",
      postal_code: "1500041",
      address: "東京都渋谷区神南1丁目",
      telephone_number: "0368694700",
      email: "customer@example.com",
      password: "password",
      password_confirmation: "password",
      is_active: true
    )
  end

  test "未ログインでは会員一覧を表示できない" do
    get admin_customers_path

    assert_redirected_to new_admin_session_path
  end

  test "ログイン後は会員一覧を表示できる" do
    sign_in_as_admin @admin

    get admin_customers_path

    assert_response :success
    assert_includes response.body, @customer.last_name
    assert_includes response.body, @customer.email
    assert_includes response.body, "有効"
  end

  test "会員詳細を表示できる" do
    sign_in_as_admin @admin

    get admin_customer_path(@customer)

    assert_response :success
    assert_includes response.body, @customer.last_name
    assert_includes response.body, @customer.postal_code
    assert_includes response.body, @customer.address
  end

  test "会員情報編集画面を表示できる" do
    sign_in_as_admin @admin

    get edit_admin_customer_path(@customer)

    assert_response :success
    assert_includes response.body, @customer.email
    assert_includes response.body, "変更を保存"
  end

  test "会員情報とステータスを更新できる" do
    sign_in_as_admin @admin

    patch admin_customer_path(@customer),
          params: {
            customer: {
              last_name: "佐藤",
              first_name: "太郎",
              last_name_kana: "サトウ",
              first_name_kana: "タロウ",
              postal_code: "1000001",
              address: "東京都千代田区千代田",
              telephone_number: "0312345678",
              email: "updated@example.com",
              is_active: false
            }
          }

    assert_redirected_to admin_customer_path(@customer)

    @customer.reload

    assert_equal "佐藤", @customer.last_name
    assert_equal "太郎", @customer.first_name
    assert_equal "updated@example.com", @customer.email
    refute @customer.is_active?
  end

  test "退会済み会員を有効に変更できる" do
    @customer.update!(is_active: false)
    sign_in_as_admin @admin

    patch admin_customer_path(@customer),
          params: {
            customer: {
              is_active: true
            }
          }

    assert_redirected_to admin_customer_path(@customer)
    assert @customer.reload.is_active?
  end

  test "不正な内容では会員情報を更新できない" do
    sign_in_as_admin @admin

    patch admin_customer_path(@customer),
          params: {
            customer: {
              last_name: ""
            }
          }

    assert_response :unprocessable_entity
    assert_equal "山田", @customer.reload.last_name
    assert_includes response.body, "入力してください"
  end
end
