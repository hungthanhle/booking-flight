class Ticket < ApplicationRecord
  belongs_to :flight, primary_key: 'flight_id'
  belongs_to :passenger, primary_key: 'passenger_id'
  belongs_to :booking, primary_key: 'booking_id'
  belongs_to :seat, foreign_key: 'seat_code', primary_key: 'seat_code'

  enum status: {
    available: 0,    # Vé đang có sẵn
    booked: 1,       # Vé đã được đặt
    hold: 2,         # Vé đang được giữ
    unavailable: 3,  # Vé không có sẵn
    checked_in: 4,    # Hành khách đã check-in
    canceled: 5,     # Vé đã bị hủy
    refunded: 6     # Vé đã được hoàn tiền
  }

  validates :status, :seat_code, presence: true
end
