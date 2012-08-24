class AddFieldsToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :active, :boolean
    add_column :invoices, :plan_id, :integer
    add_column :invoices, :due_date, :date
    add_column :invoices, :close_date, :date
    add_column :invoices, :total, :integer
    add_column :invoices, :date, :date
    
    add_index :invoices, :plan_id
  end
end