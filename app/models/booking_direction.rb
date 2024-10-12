class BookingDirection < ApplicationRecord
  belongs_to :booking, primary_key: 'booking_id'
  belongs_to :flight, primary_key: 'flight_id'
  has_many :booking_lines #, primary_key: 'line_id'

  accepts_nested_attributes_for :booking_lines

  self.inheritance_column = :_type_disabled
  enum type: {
    departure: 0,
    return: 1
  }

  validates :type, presence: true
end
