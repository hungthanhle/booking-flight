class CreatePassengers < ActiveRecord::Migration[7.0]
  def change
    create_table :passengers, id: false do |t|
      t.integer :passenger_id, primary_key: true, auto_increment: true
      t.string :name
      t.string :email
      t.string :phone_number

      t.timestamps
    end
  end
end
