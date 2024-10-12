class RenamePassengersToPassengerNumberInBookings < ActiveRecord::Migration[7.0]
  def change
    rename_column :bookings, :passengers, :passenger_number
  end
end
