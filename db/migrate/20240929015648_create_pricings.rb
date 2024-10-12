class CreatePricings < ActiveRecord::Migration[7.0]
  def change
    create_table :pricings do |t|
      t.integer :flight_id
      t.integer :seat_class
      t.float :price
      t.datetime :date

      t.timestamps
    end
  end
end
