class CreateBookingLines < ActiveRecord::Migration[7.0]
  def change
    create_table :booking_lines, id: false do |t|
      t.integer :line_id, primary_key: true, auto_increment: true
      t.integer :booking_direction_id
      t.integer :type
      t.integer :seat_class
      t.integer :quantity
      t.float :sub_total_amount

      t.timestamps
    end
  end
end
