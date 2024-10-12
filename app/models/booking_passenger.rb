class BookingPassenger < ApplicationRecord
  belongs_to :booking, primary_key: 'booking_id'
  belongs_to :passenger, primary_key: 'passenger_id'
end
