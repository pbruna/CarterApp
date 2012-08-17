class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :id
      t.string :name
      t.string :sasl_login
      t.string :sasl_password_view
      t.boolean :active
      t.integer :plan_id
      t.integer :address
      t.string :country

      t.timestamps
    end
    add_index :accounts, :plan_id
  end
end