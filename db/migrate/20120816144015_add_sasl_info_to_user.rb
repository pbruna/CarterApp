class AddSaslInfoToUser < ActiveRecord::Migration
  def change
    add_column :users, :sasl_login, :string, :null => false
    add_column :users, :sasl_password, :string, :null => false
    add_column :users, :sasl_password_view, :string, :null => false
    
    add_index :users, :sasl_login
  end
end