class Aircraft < ApplicationRecord
  has_many :seats
  has_many :flights

  validates :name, presence: true

  def self.ransackable_associations(*, **) = reflections.keys
  def self.ransackable_attributes(*, **) = attribute_names
end
