class PricingSerializer < ActiveModel::Serializer
  attributes :flight_id, :seat_class, :price, :date
end
