class Admin::AdministratorSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :role, :is_active

  def is_active # rubocop:disable Naming/PredicateName
    object.confirmed?
  end
end
