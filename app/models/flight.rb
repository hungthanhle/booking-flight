class Flight < ApplicationRecord
  belongs_to :aircraft
  belongs_to :departure_airport, foreign_key: 'departure_airport_id', class_name: 'Airport'
  belongs_to :destination_airport, foreign_key: 'destination_airport_id', class_name: 'Airport'

  has_many :seat_availabilities, dependent: :destroy
  has_many :pricings, dependent: :destroy

  # status
  has_many :tickets #, primary_key: 'ticket_id'
  has_many :booking_directions #, primary_key: 'booking_direction_id'

  validates :aircraft_id, :departure_airport_id, :destination_airport_id, :departure_date, :destination_date, presence: true
  validate :aircraft_available
  validate :range_date

  def self.ransackable_associations(*, **) = reflections.keys
  def self.ransackable_attributes(*, **) = attribute_names

  def generate_seat_availabilities
    return if SeatAvailability.find_by(flight_id: self.id).present?

    aircraft = self.aircraft
    seat_availabilities = []
    aircraft.seats&.economy&.each_with_index do |seat, index|
      seat_availabilities << SeatAvailability.new(
        flight_id: self.id,
        seat_code: seat.seat_code,
        status: "available",
        position: "E#{index}"
      )
    end
    SeatAvailability.import seat_availabilities if seat_availabilities.present?

    seat_availabilities = []
    aircraft.seats&.business&.each_with_index do |seat, index|
      seat_availabilities << SeatAvailability.new(
        flight_id: self.id,
        seat_code: seat.seat_code,
        status: "available",
        position: "B#{index}"
      )
    end
    SeatAvailability.import seat_availabilities if seat_availabilities.present?

    seat_availabilities = []
    aircraft.seats&.first_class&.each_with_index do |seat, index|
      seat_availabilities << SeatAvailability.new(
        flight_id: self.id,
        seat_code: seat.seat_code,
        status: "available",
        position: "FC#{index}"
      )
    end
    SeatAvailability.import seat_availabilities if seat_availabilities.present?
  end

  def range_date
    if destination_date.present? && departure_date.present? && destination_date <= departure_date
      errors.add(:destination_date, "must be after the departure date")
    end
  end

  def aircraft_available
    valid = true
    aircraft = Aircraft.find_by(id: self.aircraft_id)
    valid = false if !aircraft.present?

    # tìm ra flight nào sử dụng sử dụng aircraft trong thời gian đó không
    aircrafts_intime = Flight.where(aircraft_id: self.aircraft_id)
      .where("NOT( ? < departure_date OR ? > destination_date )", self.destination_date, self.departure_date)
    valid = false if aircrafts_intime.present?
    
    if !valid
      errors.add(:aircraft_available, "must be aircraft_available")
    end
  end

  def pricings_hash
    pricings.each_with_object({}) do |pricing, hash|
      hash[pricing.seat_class] = pricing.price
    end
  end

  def self.pricings_hash flight_ids=nil
    result = Pricing.where(flight_id: flight_ids).each_with_object({}) do |pricing, hash|
      key = [pricing.flight_id, pricing.seat_class]
      hash[key] = pricing.price
    end
  end
end
