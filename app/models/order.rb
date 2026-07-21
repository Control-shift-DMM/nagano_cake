class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_details
  has_many :items, through: :order_details


  # enum 設定
  enum :payment_method, { credit_card: 0, transfer: 1 }
  enum :status, { waiting_for_payment: 0, payment_confirmation: 1, in_production: 2, preparation: 3, shipping: 4 }

  validates :payment_method, presence: true

  validates :address_id,
            presence: true,
            if: -> { select_address == "1" }

  validates :postal_code,
            :address,
            :name,
            presence: true,
            if: -> { select_address == "2" }

  validates :postal_code,
            format: { with: /\A\d{7}\z/ },
            allow_blank: true
end
