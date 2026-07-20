require "test_helper"

class Admin::ItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = Admin.create!(
      email: "admin@example.com",
      password: "password",
      password_confirmation: "password"
    )

    @genre = Genre.create!(name: "ケーキ")

    @item = Item.create!(
      genre: @genre,
      name: "ショートケーキ",
      introduction: "いちごを使用したケーキです",
      price: 500,
      is_active: true
    )
  end

  test "未ログインでは商品一覧を表示できない" do
    get admin_items_path

    assert_redirected_to new_admin_session_path
  end

  test "ログイン後は商品一覧を表示できる" do
    sign_in_as_admin @admin

    get admin_items_path

    assert_response :success
    assert_includes response.body, @item.name
  end

  test "商品名で検索できる" do
    sign_in_as_admin @admin

    other_item = Item.create!(
      genre: @genre,
      name: "プリン",
      introduction: "なめらかなプリンです",
      price: 300,
      is_active: true
    )

    get admin_items_path, params: { keyword: "ショート" }

    assert_response :success
    assert_includes response.body, @item.name
    refute_includes response.body, other_item.name
  end

  test "商品新規登録画面を表示できる" do
    sign_in_as_admin @admin

    get new_admin_item_path

    assert_response :success
  end

  test "商品詳細画面を表示できる" do
    sign_in_as_admin @admin

    get admin_item_path(@item)

    assert_response :success
    assert_includes response.body, @item.name
  end

  test "商品編集画面を表示できる" do
    sign_in_as_admin @admin

    get edit_admin_item_path(@item)

    assert_response :success
  end

  test "商品を新規登録できる" do
    sign_in_as_admin @admin

    uploaded_image = Rack::Test::UploadedFile.new(
      Rails.root.join("app/assets/images/default-image.jpg").to_s,
        "image/jpeg"
      )

    assert_difference("Item.count", 1) do
      post admin_items_path,
           params: {
             item: {
               genre_id: @genre.id,
               name: "モンブラン",
               introduction: "栗を使用したケーキです",
               price: 600,
               is_active: true,
               image: uploaded_image
             }
           }
    end

    created_item = Item.order(:id).last

    assert_redirected_to admin_item_path(created_item)
    assert_equal "モンブラン", created_item.name
    assert_equal 600, created_item.price
    assert created_item.is_active?
    assert created_item.image.attached?
  end

  test "不正な内容では商品を登録できない" do
    sign_in_as_admin @admin

    assert_no_difference("Item.count") do
      post admin_items_path,
           params: {
             item: {
               genre_id: @genre.id,
               name: "",
               introduction: "商品説明",
               price: 500,
               is_active: true
             }
           }
    end

    assert_response :unprocessable_entity
  end

  test "商品情報と販売ステータスを更新できる" do
    sign_in_as_admin @admin

    patch admin_item_path(@item),
          params: {
            item: {
              name: "更新後の商品名",
              introduction: "更新後の商品説明",
              genre_id: @genre.id,
              price: 700,
              is_active: false
            }
          }

    assert_redirected_to admin_item_path(@item)

    @item.reload

    assert_equal "更新後の商品名", @item.name
    assert_equal "更新後の商品説明", @item.introduction
    assert_equal 700, @item.price
    refute @item.is_active?
  end

  test "不正な内容では商品を更新できない" do
    sign_in_as_admin @admin

    patch admin_item_path(@item),
          params: {
            item: {
              name: "",
              introduction: @item.introduction,
              genre_id: @genre.id,
              price: @item.price,
              is_active: true
            }
          }

    assert_response :unprocessable_entity
    assert_equal "ショートケーキ", @item.reload.name
  end
end
