class FlightSerializer < ActiveModel::Serializer
  attributes :flight_id, :aircraft, :departure_airport, :destination_airport, :departure_date, :destination_date

  def aircraft
    AircraftSerializer.new(object.aircraft)
  end

  def departure_airport
    AirportSerializer.new(object.departure_airport)
  end

  def destination_airport
    AirportSerializer.new(object.destination_airport)
  end
end
