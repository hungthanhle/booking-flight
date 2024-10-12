class BookingLine < ApplicationRecord
  belongs_to :booking_direction, primary_key: 'booking_direction_id'

  enum seat_class: {
    economy: 0,     # Phổ thông
    business: 1,    # Thương gia
    first_class: 2  # Hạng nhất
  }

  self.inheritance_column = :_type_disabled
  enum type: {
    seat_booking: 0,
    extra_baggage: 1,
    meal_service: 2,
    insurance: 3
  }

  validates :type, :quantity, presence: true
end
