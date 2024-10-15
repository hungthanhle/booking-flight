class SeatAvailability < ApplicationRecord
  self.primary_keys = :flight_id, :seat_code, :status

  belongs_to :flight, primary_key: 'flight_id'
  belongs_to :seat, foreign_key: 'seat_code', primary_key: 'seat_code'

  enum status: {
    available: 0,     # Chỗ ngồi có sẵn
    booked: 1,        # Chỗ ngồi đã được đặt
    hold: 2,          # Chỗ ngồi đang được giữ
    unavailable: 3,   # Chỗ ngồi không có sẵn
    checked_in: 4,    # Hành khách đã làm thủ tục
    cancelled: 5      # Chỗ ngồi đã bị hủy
  }

  validates :seat_code, :status, :position, presence: true
end
