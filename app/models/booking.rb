class Booking < ApplicationRecord
  belongs_to :departure_flight, foreign_key: 'departure_flight_id', class_name: 'Flight', primary_key: 'flight_id'
  belongs_to :destination_flight, foreign_key: 'destination_flight_id', class_name: 'Flight', primary_key: 'flight_id', optional: true

  has_many :booking_passengers
  has_many :passengers, through: :booking_passengers
  has_many :transactions
  has_many :booking_directions #, primary_key: 'line_id'
  has_many :tickets #, primary_key: 'ticket_id'

  accepts_nested_attributes_for :tickets, :booking_passengers, :booking_directions

  self.inheritance_column = :_type_disabled
  # he single-table inheritance mechanism failed to locate the subclass: 'one_way'. This error is raised because the column 'type' is reserved for storing the class in case of inheritance. Please rename this column if you didn't intend it to be used for storing the inheritance class or overwrite Booking.inheritance_column to use another column for that information.
  enum type: {
    one_way: 0,     # Đặt chỗ một chiều
    round_trip: 1,  # Đặt chỗ khứ hồi
    multi_city: 2   # Đặt chỗ nhiều thành phố
  }

  enum status: {
    pending: 0,     # Đơn đặt chỗ đang chờ xử lý
    completed: 1,   # Đơn đặt chỗ đã hoàn thành
    canceled: 2,    # Đơn đặt chỗ đã bị hủy
    failed: 3,      # Đơn đặt chỗ không thành công
    confirmed: 4    # Đơn đặt chỗ đã được xác nhận
  }

  validates :status, :type, :departure_flight_id, presence: true
end
