class CreateSeats < ActiveRecord::Migration[7.0]
  def change
    create_table :seats, id: false do |t|
      t.integer :seat_code, primary_key: true, auto_increment: true
      t.integer :class
      t.integer :aircraft_id

      t.timestamps
    end
  end
end
