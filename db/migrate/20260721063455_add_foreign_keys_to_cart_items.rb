class AddForeignKeysToCartItems < ActiveRecord::Migration[8.1]
  def change
    add_foreign_key :cart_items, :customers
    add_foreign_key :cart_items, :items
  end
end
