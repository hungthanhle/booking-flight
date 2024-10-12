class CreateBookingDirections < ActiveRecord::Migration[7.0]
  def change
    create_table :booking_directions, id: false do |t|
      t.integer :booking_direction_id, primary_key: true, auto_increment: true
      t.integer :booking_id
      t.integer :type
      t.integer :flight_id
      t.float :amount

      t.timestamps
    end
  end
end
