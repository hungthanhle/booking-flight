class AirportSerializer < ActiveModel::Serializer
  attributes :name, :code, :city, :country
end
