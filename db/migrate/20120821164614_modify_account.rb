class ModifyAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :address2, :string
    change_column :accounts, :address, :string
    add_column :accounts, :city, :string
    add_column :accounts, :rut, :string
  end
end