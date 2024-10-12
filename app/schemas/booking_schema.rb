require 'dry-validation'

class BookingSchema < Dry::Validation::Contract
  params do
    required(:booking).hash do
      required(:type).filled(:string, included_in?: ['one_way', 'round_trip'])
      required(:departure_flight_id).filled(:integer)
      optional(:destination_flight_id).filled(:integer)

      required(:booking_directions).array(:hash) do
        required(:type).filled(:string, included_in?: ['departure', 'return'])
        required(:flight_id).filled(:integer)

        required(:booking_lines).array(:hash) do
          required(:type).filled(:string, included_in?: ['extra_baggage',  'meal_service', 'insurance'])
          required(:quantity).filled(:integer)
        end
      end
    end

    required(:passengers).value(:array, min_size?: 1).each do
      hash do
        required(:name).filled(:string)
        required(:email).filled(:string)
        required(:phone_number).filled(:string)

        required(:flights).array(:hash) do
          required(:flight_id).filled(:integer)
          required(:seat_code).filled(:integer)
        end
      end
    end
  end

  # Custom rule
  rule(:booking) do
    booking_type = values[:booking][:type]
    departure_flight_id = values[:booking][:departure_flight_id]
    destination_flight_id = values[:booking][:destination_flight_id]

    # If type is 'one_way', ensure specific conditions
    if booking_type == 'one_way'
      booking_directions = values[:booking][:booking_directions]

      # Ensure there's only one direction with type 'departure'
      if booking_directions&.size != 1 || booking_directions.first[:type] != 'departure'
        key(:booking).failure('must have only one departure direction for one_way bookings')
      end

      # Ensure passengers' flights match departure_flight_id
      if booking_directions.first[:flight_id] != departure_flight_id
        key(:booking).failure('must have exactly one flight_id matching departure_flight_id')
      end

      # Ensure passengers' flights match departure_flight_id
      values[:passengers].each do |passenger|
        flights = passenger[:flights]
        if flights&.size != 1 || flights.first[:flight_id] != departure_flight_id
          key(:passengers).failure('must have exactly one flight matching departure_flight_id for one_way booking')
        end
      end
    
    elsif booking_type == 'round_trip' # Nếu type là 'round_trip', đảm bảo các điều kiện cụ thể
      # Đảm bảo có destination_flight_id
      if destination_flight_id.nil?
        key(:booking).failure('must have destination_flight_id for round_trip bookings')
      end

      booking_directions = values[:booking][:booking_directions]

      # Đảm bảo có 2 booking_directions: một cho departure và một cho return
      if booking_directions&.size != 2
        key(:booking).failure('must have exactly two booking directions for round_trip bookings')
      else
        departure_direction = booking_directions.find { |d| d[:type] == 'departure' }
        return_direction = booking_directions.find { |d| d[:type] == 'return' }

        # Kiểm tra flight_id cho mỗi direction
        if departure_direction.nil? || departure_direction[:flight_id] != departure_flight_id
          key(:booking).failure('must have a departure direction with flight_id matching departure_flight_id')
        end

        if return_direction.nil? || return_direction[:flight_id] != destination_flight_id
          key(:booking).failure('must have a return direction with flight_id matching destination_flight_id')
        end
      end

      # Đảm bảo mỗi hành khách có hai chuyến bay
      values[:passengers].each do |passenger|
        flights = passenger[:flights]
        if flights&.size != 2 ||
          !flights.any? { |f| f[:flight_id] == departure_flight_id } ||
          !flights.any? { |f| f[:flight_id] == destination_flight_id }
          key(:passengers).failure('each passenger must have one flight for departure_flight_id and one for destination_flight_id for round_trip booking')
        end
      end
    end
  end

  rule(:passengers).each do |index|
    flights = value[:flights]

    # Kiểm tra trùng lặp seat_code trong cùng flight_id
    duplicates = flights.group_by { |f| f[:flight_id] }
                        .transform_values { |seats| seats.map { |s| s[:seat_code] } }
                        .select { |_flight_id, seat_codes| seat_codes.uniq.size != seat_codes.size }

    if duplicates.any?
      key([:passengers, index, :flights]).failure("must have unique seat_code for the same flight_id")
    end
  end
end
