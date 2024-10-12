class Admin::AirportSerializer < ActiveModel::Serializer
  attributes :id, :name, :code, :city, :country, :created_at, :updated_at
end
