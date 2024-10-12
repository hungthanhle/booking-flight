class ChangeColumnNameClassToSeatClassSeats < ActiveRecord::Migration[7.0]
  def change
    rename_column :seats, :class, :seat_class
  end
end
