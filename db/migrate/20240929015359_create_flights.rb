class CreateFlights < ActiveRecord::Migration[7.0]
  def change
    create_table :flights, id: false do |t|
      t.integer :flight_id, primary_key: true, auto_increment: true
      t.integer :aircraft_id
      t.integer :departure_airport_id
      t.integer :destination_airport_id
      t.datetime :departure_date
      t.datetime :destination_date

      t.timestamps
    end
  end
end
