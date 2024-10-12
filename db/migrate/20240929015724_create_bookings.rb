class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings, id: false do |t|
      t.integer :booking_id, primary_key: true, auto_increment: true
      t.integer :status
      t.integer :type
      t.integer :departure_flight_id
      t.integer :destination_flight_id
      t.integer :passengers
      t.float :amount

      t.timestamps
    end
  end
end
