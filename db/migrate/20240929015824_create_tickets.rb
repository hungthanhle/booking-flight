class CreateTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :tickets, id: false do |t|
      t.integer :ticket_id, primary_key: true, auto_increment: true
      t.integer :status
      t.integer :flight_id
      t.integer :passenger_id
      t.integer :seat_code
      t.integer :booking_id

      t.timestamps
    end
  end
end
