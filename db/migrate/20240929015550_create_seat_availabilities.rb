class CreateSeatAvailabilities < ActiveRecord::Migration[7.0]
  def change
    create_table :seat_availabilities do |t|
      t.integer :flight_id
      t.integer :seat_code
      t.integer :status
      t.string :position

      t.timestamps
    end
  end
end
