class CreateEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :entries, id: false do |t|
      t.integer :entry_id, primary_key: true, auto_increment: true
      t.integer :account_number
      t.string :sign
      t.float :amount
      t.integer :transaction_id

      t.timestamps
    end
  end
end
