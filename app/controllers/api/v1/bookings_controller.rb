class Api::V1::BookingsController < Api::V1::BaseController
  include BookingHelper
  before_action :valid_params?, only: [:create]
  before_action :valid_flights?, only: [:create]

  def valid_params?
    schema = BookingSchema.new.call(request_params.to_h)
    return render json: {
      success: false,
      errors: schema.errors
    } unless schema.success?
  end

  def valid_flights?
    @departure_flight = Flight.find(booking_params[:departure_flight_id])
    if booking_params[:type] == "round_trip"
      @destination_flight = Flight.find(booking_params[:destination_flight_id])
      
      valid = (@departure_flight.departure_airport_id == @destination_flight.destination_airport_id) && (@departure_flight.destination_airport_id == @destination_flight.departure_airport_id)
      return render json: {
        success: false,
        errors: ["Departure flight and destination flight do not match for round trip"]
      } unless valid
    end
  end

  def create
    booking = nil
    tickets = nil
    ActiveRecord::Base.transaction do
      # LOCK & UPDATE seat availabilities
      seat_availabilities = []
      booking_seats_params.each do |data|
        # USE PRIMARY KEY
        seat_availability = SeatAvailability.where(status: 'available',
                                    flight_id: data[:flight_id],
                                    seat_code: data[:seat_code])
                              .lock
        if !seat_availability.present?
          raise ActiveRecord::Rollback, "Not available seats found"
        end

        seat_availabilities.concat(seat_availability)
      end
      seat_availabilities.each do |seat_availability|
        seat_availability.update!(status: 'hold')
      end

      # bookings
      booking = Booking.new(
        type: booking_params[:type],
        departure_flight_id: booking_params[:departure_flight_id],
        destination_flight_id: booking_params[:destination_flight_id],
        passenger_number: passengers_params.size
      )
      booking.save!

      tickets = []
      # passengers & booking_passengers & tickets
      passengers_params.each do |data|
        passenger = Passenger.find_or_initialize_by(email: data[:email])
        passenger.assign_attributes(
          name: data[:name],
          phone_number: data[:phone_number]
        )
        passenger.save!

        # booking_passengers
        passenger.booking_passengers.create!(booking: booking)
        
        # tickets
        data[:flights].each do |ticket_data|
          ticket = Ticket.new(
            status: "hold",
            flight_id: ticket_data[:flight_id],
            seat_code: ticket_data[:seat_code],
            passenger: passenger,
            booking: booking
          )
          ticket.save!
          tickets << ticket
        end
      end

      # All orders => amount of booking_direction, booking_line
      flight_ids = booking_seats_params.pluck(:flight_id)
      prices = Flight.pricings_hash(flight_ids)
      # { [flight_id, seat_code] => price }

      seat_codes = booking_seats_params.pluck(:seat_code)
      seat_classes = Seat.seat_classes_hash(seat_codes)
      # { seat_code => seat_class }

      # directions = booking_params[:booking_directions].each_with_object({}) do |direction, hash|
      #   key = direction[:flight_id]
      #   hash[key] = direction[:type]
      # end
      # { flight_id => direction_type }
      
      booking_seats = booking_seats_params.map do |booking_seat|
        {
          flight_id: booking_seat[:flight_id], # booking_direction: directions[booking_seat[:flight_id]],
          seat_code: booking_seat[:seat_code],
          seat_class: seat_classes[booking_seat[:seat_code]],
          price: prices[[booking_seat[:flight_id], seat_classes[booking_seat[:seat_code]]]]
        }
      end
      # Each flight_id for booking_directions
      seat_booking_directions = booking_seats.group_by { |booking_seat| booking_seat[:flight_id] }
                            .transform_values do |seats|
                              {
                                amount: seats.sum(0) { |s| s[:price].to_f }
                              }
                            end
      # { flight_id => { amount } }

      # Each flight_id and seat_class for booking_lines
      # seat_booking_lines = booking_seats.group_by { |booking_seat| [booking_seat[:flight_id], booking_seat[:seat_class]] }
      #                       .transform_values do |seats|
      #                         {
      #                           sub_total_amount: seats.sum { |s| s[:price] },
      #                           quantity: seats.size
      #                         }
      #                       end
      # { [flight_id, seat_class]  => { sub_total_amount, quantity } }
      seat_booking_lines = {}
      booking_seats.each do |booking_seat|
        flight_id = booking_seat[:flight_id]
        seat_class = booking_seat[:seat_class]
        price = booking_seat[:price]
      
        # Init
        seat_booking_lines[flight_id] ||= {}
        
        # Init
        seat_booking_lines[flight_id][seat_class] ||= { sub_total_amount: 0, quantity: 0 }
      
        # Sum
        seat_booking_lines[flight_id][seat_class][:sub_total_amount] += price
        seat_booking_lines[flight_id][seat_class][:quantity] += 1
      end
      
      booking_directions = []
      booking_params[:booking_directions].each do |data|
        booking_direction = BookingDirection.new(
          type: data[:type],
          flight_id: data[:flight_id],
          booking: booking
        )

        booking_direction.amount = seat_booking_directions[data[:flight_id]][:amount] + 0
        booking_direction.save!
        booking_directions << booking_direction

        booking_lines = []
        seat_booking_lines[data[:flight_id]].each do |seat_class, seat_booking_line_data|
          booking_lines << BookingLine.new(
            type: "seat_booking",
            quantity: seat_booking_line_data[:quantity],
            seat_class: seat_class,
            sub_total_amount: seat_booking_line_data[:sub_total_amount],
            booking_direction: booking_direction
          )
        end
        data[:booking_lines].each do |booking_line_data|
          booking_lines << BookingLine.new(
            type: booking_line_data[:type],
            quantity: booking_line_data[:quantity],
            seat_class: nil,
            sub_total_amount: 0,
            booking_direction: booking_direction
          )
        end
        unless BookingLine.import(booking_lines)
          raise ActiveRecord::Rollback, "Failed to save booking_lines"
        end
      end
      total_amount = booking_directions.sum { |direction| direction.amount || 0 }
      booking.update!(amount: total_amount)
    end
    return render json: {
      success: true,
      data: {
        tickets: tickets.map { |ticket| TicketSerializer.new(ticket).to_h },
        booking: BookingSerializer.new(booking).to_h
      }
    }
  rescue ActiveRecord::Rollback => e
    return render json: {
      success: false
    }
  end

  def logic
    super
  end

  private

  def request_params
    params.permit(booking: [
      :type, :departure_flight_id, :destination_flight_id,
      booking_directions: [
        :type, :flight_id, 
        booking_lines: [:type, :quantity]
      ]
    ], passengers: [
      :name, :email, :phone_number,
      flights: [:flight_id, :seat_code]
    ])
  end

  def booking_params
    request_params[:booking]
  end

  def passengers_params
    request_params[:passengers]
  end

  def booking_seats_params
    passengers_params.flat_map { |passenger| passenger[:flights] }
  end
end
