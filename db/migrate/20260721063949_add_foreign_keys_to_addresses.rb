class AddForeignKeysToAddresses < ActiveRecord::Migration[8.1]
  def change
    add_foreign_key :addresses, :customers
  end
end
