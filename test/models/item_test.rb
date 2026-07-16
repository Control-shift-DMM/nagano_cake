require "test_helper"

class ItemTest < ActiveSupport::TestCase
  test "必要な情報があれば有効である" do
    genre = Genre.new(name: "ケーキ")
    item = Item.new(
      genre: genre,
      name: "ショートケーキ",
      introduction: "いちごを使用したケーキです",
      price: 500,
      is_active: true
    )

    assert item.valid?
  end

  test "ジャンルがなければ無効である" do
    item = Item.new(
      name: "ショートケーキ",
      introduction: "いちごを使用したケーキです",
      price: 500,
      is_active: true
    )

    assert_not item.valid?
    assert item.errors.details[:genre].present?
  end

  test "商品名がなければ無効である" do
    genre = Genre.new(name: "ケーキ")
    item = Item.new(
      genre: genre,
      name: "",
      introduction: "いちごを使用したケーキです",
      price: 500,
      is_active: true
    )

    assert_not item.valid?
    assert_equal :blank, item.errors.details[:name].first[:error]
  end

  test "商品説明がなければ無効である" do
    genre = Genre.new(name: "ケーキ")
    item = Item.new(
      genre: genre,
      name: "ショートケーキ",
      introduction: "",
      price: 500,
      is_active: true
    )

    assert_not item.valid?
    assert_equal :blank, item.errors.details[:introduction].first[:error]
  end

  test "価格が負数なら無効である" do
    genre = Genre.new(name: "ケーキ")
    item = Item.new(
      genre: genre,
      name: "ショートケーキ",
      introduction: "いちごを使用したケーキです",
      price: -100,
      is_active: true
    )

    assert_not item.valid?
    assert_equal :greater_than_or_equal_to, item.errors.details[:price].first[:error]
  end

  test "販売停止状態でも有効である" do
    genre = Genre.new(name: "ケーキ")
    item = Item.new(
      genre: genre,
      name: "ショートケーキ",
      introduction: "いちごを使用したケーキです",
      price: 500,
      is_active: false
    )

    assert item.valid?
  end

  test "税込価格の小数点以下を切り捨てる" do
    item = Item.new(price: 501)

    assert_equal 551, item.with_tax_price
  end
end
