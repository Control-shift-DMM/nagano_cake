class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :name, null: false
      t.strign :postal_code , null: false
      t.string :address , null:false
      t.integer :payment_method , null: false
      t.integer :shipping_cost , null: false
      t.integer :total_payment, null: false
      t.integer :status , null: false , default: 0
      t.timestamps , null: false
    end
  end
end
