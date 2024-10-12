class Admin::PricingSerializer < ActiveModel::Serializer
  attributes :id, :flight_id, :seat_class, :price, :date
end
