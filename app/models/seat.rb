class Seat < ApplicationRecord
  belongs_to :aircraft
  has_many :seat_availabilities

  validates :seat_class, :aircraft_id, presence: true

  enum seat_class: {
    economy: 0,     # Phổ thông
    business: 1,    # Thương gia
    first_class: 2  # Hạng nhất
  }

  def self.seat_classes_hash seat_codes=nil
    self.where(seat_code: seat_codes).each_with_object({}) do |seat, hash|
      key = seat.seat_code
      hash[key] = seat.seat_class
    end
  end
end
