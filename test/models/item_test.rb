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
    assert_includes item.errors[:genre], "must exist"
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
    assert_includes item.errors[:name], "can't be blank"
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
    assert_includes item.errors[:introduction], "can't be blank"
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
    assert_includes item.errors[:price], "must be greater than or equal to 0"
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
