class Session < ApplicationRecord
  belongs_to :account, polymorphic: true
end
