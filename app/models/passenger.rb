class Passenger < ApplicationRecord
  has_many :booking_passengers
  has_many :bookings, through: :booking_passengers
  has_many :tickets #, primary_key: 'ticket_id'

  validates :name, :email, :phone_number, presence: true
end
