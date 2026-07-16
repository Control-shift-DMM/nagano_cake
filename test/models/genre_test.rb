require "test_helper"

class GenreTest < ActiveSupport::TestCase
  test "ジャンル名があれば有効である" do
    genre = Genre.new(name: "ケーキ")

    assert genre.valid?
  end

  test "ジャンル名がなければ無効である" do
    genre = Genre.new(name: "")

    assert_not genre.valid?
    assert_includes genre.errors[:name], "can't be blank"
  end
end
