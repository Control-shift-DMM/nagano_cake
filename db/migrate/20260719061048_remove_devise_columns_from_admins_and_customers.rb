class RemoveDeviseColumnsFromAdminsAndCustomers < ActiveRecord::Migration[8.1]
  def up
    remove_index :admins,
                 name: "index_admins_on_reset_password_token"

    remove_column :admins, :encrypted_password
    remove_column :admins, :reset_password_token
    remove_column :admins, :reset_password_sent_at
    remove_column :admins, :remember_created_at

    remove_index :customers,
                 name: "index_customers_on_reset_password_token"

    remove_column :customers, :encrypted_password
    remove_column :customers, :reset_password_token
    remove_column :customers, :reset_password_sent_at
    remove_column :customers, :remember_created_at
  end

  def down
    add_column :admins,
               :encrypted_password,
               :string,
               null: false,
               default: ""
    add_column :admins, :reset_password_token, :string
    add_column :admins, :reset_password_sent_at, :datetime
    add_column :admins, :remember_created_at, :datetime

    add_index :admins,
              :reset_password_token,
              unique: true

    add_column :customers,
               :encrypted_password,
               :string,
               null: false,
               default: ""
    add_column :customers, :reset_password_token, :string
    add_column :customers, :reset_password_sent_at, :datetime
    add_column :customers, :remember_created_at, :datetime

    add_index :customers,
              :reset_password_token,
              unique: true
  end
end
