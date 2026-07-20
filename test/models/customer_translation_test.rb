require "test_helper"

class CustomerTranslationTest < ActiveSupport::TestCase
  test "顧客属性名が日本語で表示される" do
    customer = Customer.new

    customer.validate

    assert_includes customer.errors.full_messages, "姓を入力してください"
    assert_includes customer.errors.full_messages, "名を入力してください"
    assert_includes customer.errors.full_messages, "姓カナを入力してください"
    assert_includes customer.errors.full_messages, "名カナを入力してください"
    assert_includes customer.errors.full_messages, "郵便番号を入力してください"
    assert_includes customer.errors.full_messages, "住所を入力してください"
    assert_includes customer.errors.full_messages, "電話番号を入力してください"
    assert_includes customer.errors.full_messages, "メールアドレスを入力してください"
  end
end
