class SeatAvailabilitySerializer < ActiveModel::Serializer
  attributes :flight_id, :seat, :status, :position, :price
  attr_reader :pricings

  def initialize(object, pricings = nil)
    super(object)
    @pricings = pricings  # Gán giá trị vào biến tùy ý
  end

  def seat
    SeatSerializer.new(object.seat)
  end

  def price
    @pricings[object.seat.seat_class]
  end
end
