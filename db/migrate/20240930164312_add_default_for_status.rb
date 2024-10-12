class AddDefaultForStatus < ActiveRecord::Migration[7.0]
  def change
    # available
    change_column_default :seat_availabilities, :status, 0
    change_column_default :tickets, :status, 0

    # pending
    change_column_default :bookings, :status, 0
    change_column_default :transactions, :status, 0
  end
end
