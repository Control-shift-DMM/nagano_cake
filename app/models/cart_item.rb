class CartItem < ApplicationRecord
  belongs_to :customer
  belongs_to :item

  validates :amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  def calc_sub_total
    item.with_tax_price * amount
  end
end
