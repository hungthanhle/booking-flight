class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions, id: false do |t|
      t.integer :transaction_id, primary_key: true, auto_increment: true
      t.integer :status
      t.integer :type
      t.integer :booking_id
      t.float :amount
      t.integer :method
      t.float :fee

      t.timestamps
    end
  end
end
