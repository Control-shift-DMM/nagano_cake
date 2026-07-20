require "test_helper"

class Admin::GenresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = Admin.create!(
      email: "admin@example.com",
      password: "password",
      password_confirmation: "password"
    )

    @genre = Genre.create!(name: "ケーキ")
  end

  test "未ログインではジャンル一覧を表示できない" do
    get admin_genres_path

    assert_redirected_to new_admin_session_path
  end

  test "ログイン後はジャンル一覧を表示できる" do
    sign_in_as_admin @admin

    get admin_genres_path

    assert_response :success
  end

  test "ログイン後はジャンル編集画面を表示できる" do
    sign_in_as_admin @admin

    get edit_admin_genre_path(@genre)

    assert_response :success
  end

  test "ジャンルを新規登録できる" do
    sign_in_as_admin @admin

    assert_difference("Genre.count", 1) do
      post admin_genres_path,
           params: { genre: { name: "焼き菓子" } }
    end

    assert_redirected_to admin_genres_path
  end

  test "空欄のジャンルは登録できない" do
    sign_in_as_admin @admin

    assert_no_difference("Genre.count") do
      post admin_genres_path,
           params: { genre: { name: "" } }
    end

    assert_response :unprocessable_entity
  end

  test "ジャンル名を更新できる" do
    sign_in_as_admin @admin

    patch admin_genre_path(@genre),
          params: { genre: { name: "和菓子" } }

    assert_redirected_to admin_genres_path
    assert_equal "和菓子", @genre.reload.name
  end

  test "空欄ではジャンル名を更新できない" do
    sign_in_as_admin @admin

    patch admin_genre_path(@genre),
          params: { genre: { name: "" } }

    assert_response :unprocessable_entity
    assert_equal "ケーキ", @genre.reload.name
  end
end
