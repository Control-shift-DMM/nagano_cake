class OrderDetail < ApplicationRecord
  belongs_to :item
  belongs_to :order

  enum :making_status, { discontinued: 0, waiting_for_creation: 1, in_production:2, complete:3 }
end
