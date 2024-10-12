class Pricing < ApplicationRecord
  belongs_to :flight, primary_key: 'flight_id'

  enum seat_class: {
    economy: 0,     # Phổ thông
    business: 1,    # Thương gia
    first_class: 2  # Hạng nhất
  }

  validates :seat_class, :price, presence: true
end
