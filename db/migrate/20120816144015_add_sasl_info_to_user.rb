class AddSaslInfoToUser < ActiveRecord::Migration
  def change
    add_column :users, :sasl_login, :string
    add_column :users, :sasl_password, :string
    add_column :users, :sasl_password_view, :string
    
    add_index :users, :sasl_login
  end
end