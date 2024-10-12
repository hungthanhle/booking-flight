class TicketSerializer < ActiveModel::Serializer
  attributes :ticket_id, :status, :flight_id, :seat, :passenger, :booking_id

  def passenger
    {
      name: object.passenger.name,
      email: object.passenger.email,
      phone_number: object.passenger.phone_number
    }
  end

  def seat
    seat_availability = SeatAvailability.find_by(flight_id: object.flight_id, seat_code: object.seat_code)
    
    SeatSerializer.new(object.seat).serializable_hash.merge({
      position: seat_availability&.position,
      status: seat_availability&.status
    })
  end
end
