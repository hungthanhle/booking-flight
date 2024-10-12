class Admin::SeatAvailabilitySerializer < ActiveModel::Serializer
  attributes :id, :flight_id, :seat_code, :status, :position, :created_at, :updated_at
end
