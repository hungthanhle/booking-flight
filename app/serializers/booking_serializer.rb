class BookingSerializer < ActiveModel::Serializer
  attributes :booking_id, :status, :type, :departure_flight_id, :destination_flight_id, :passenger_number, :amount,
              :booking_directions

  def booking_directions
    object.booking_directions.map do |booking_direction|
      {
        type: booking_direction.type,
        flight_id: booking_direction.flight_id,
        amount: booking_direction.amount,
        booking_lines: booking_direction.booking_lines.map do |booking_line|
          {
            type: booking_line.type,
            seat_class: booking_line.seat_class,
            quantity: booking_line.quantity,
            sub_total_amount: booking_line.sub_total_amount
          }
        end
      }
    end
  end
end
