class AddSaslPasswordAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :sasl_password, :string
  end
end