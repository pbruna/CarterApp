class ModifyUsersPostAccount < ActiveRecord::Migration
  def change
    remove_column :users, :sasl_login
    remove_column :users, :sasl_password
    remove_column :users, :sasl_password_view
    remove_column :users, :plan_id
    add_column :users, :account_id, :integer
    
    add_index :users, :account_id
  end
end