class Admin::FlightSerializer < ActiveModel::Serializer
  attributes :flight_id, :aircraft_id, :departure_airport_id, :destination_airport_id, :departure_date, :destination_date,
            :created_at, :updated_at
end
