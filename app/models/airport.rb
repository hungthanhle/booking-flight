class Airport < ApplicationRecord
  has_many :departure_flights, foreign_key: 'departure_airport_id', class_name: 'Flight'
  has_many :arrival_flights, foreign_key: 'destination_airport_id', class_name: 'Flight'

  validates :name, :city, :country, presence: true

  ransack_alias :search, :name_or_code_or_country_or_city

  def self.ransackable_associations(*, **) = reflections.keys
  def self.ransackable_attributes(*, **) = attribute_names
end
