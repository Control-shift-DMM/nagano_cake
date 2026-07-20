class Item < ApplicationRecord
  belongs_to :genre

  has_one_attached :image

  validates :name, presence: true
  validates :introduction, presence: true
  validates :price,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :is_active, inclusion: { in: [ true, false ] }

  has_many :orders, through: :order_details

  def with_tax_price
    (price * 1.1).floor
  end
end
