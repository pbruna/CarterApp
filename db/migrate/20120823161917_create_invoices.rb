class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :account_id

      t.timestamps
    end
    add_index :invoices, :account_id
  end
end