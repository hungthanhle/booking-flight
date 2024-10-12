class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :is_active

  def is_active # rubocop:disable Naming/PredicateName
    object.confirmed?
  end
end
