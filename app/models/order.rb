class Order < ApplicationRecord
  belongs_to :customer
  has_many :items, throgh: :order_details


  #enum 設定 config/ja.ymlに設定済み
  enum :payment_method, { credit_card: 0, transfer: 1 }
  enum :status, { waiting_for_payment: 0, payment_confirmation: 1 ,in_production:2, preparation:3, shipping:4}
end
