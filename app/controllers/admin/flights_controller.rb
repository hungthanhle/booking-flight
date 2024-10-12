class Admin::FlightsController < Admin::BaseController
  before_action :load_flight, only: [:show, :seat_availabilities, :create_update_price, :pricings, :destroy]
  
  def index
    @q = Flight.ransack(params[:q])
    @flights = @q.result.page(params[:page]  || 1).per(params[:per_page] || 10) || []
    render json: {
      success: true,
      data: @flights.map { |flight| Admin::FlightSerializer.new(flight).as_json },
      current_page: @flights.current_page,
      total_pages: @flights.total_pages
    }
  end

  def show
    render json: {
      success: true,
      data: Admin::FlightSerializer.new(@flight).as_json
    }
  end

  def seat_availabilities
    @seat_availabilities = @flight.seat_availabilities
                              .page(params[:page]  || 1).per(params[:per_page] || 10) || []
    render json: {
      success: true,
      data: @seat_availabilities.map { |seat_availability| Admin::SeatAvailabilitySerializer.new(seat_availability).as_json },
      current_page: @seat_availabilities.current_page,
      total_pages: @seat_availabilities.total_pages
    }
  end

  def pricings
    @pricings = @flight.pricings || []
    render json: {
      success: true,
      data: @pricings.map { |pricing| Admin::PricingSerializer.new(pricing).as_json }
    }
  end

  def create_update_price
    @pricing = @flight.pricings.find_or_initialize_by(seat_class: pricing_params[:seat_class]) # Sửa thành find_or_initialize_by
    @pricing.assign_attributes(pricing_params)
    if @pricing.save
      render json: {
        success: true,
        data: Admin::PricingSerializer.new(@pricing).as_json
      }
    else
      render json: {
        success: false,
        errors: @pricing.errors.full_messages # Trả về thông báo lỗi nếu không thành công
      }, status: :unprocessable_entity
    end
  end

  def create
    @flight = Flight.new
    @flight.assign_attributes(flight_params)
    if @flight.valid?
      @flight.save!
      @flight.generate_seat_availabilities
      render json: {
        success: true,
        data: Admin::FlightSerializer.new(@flight).as_json
      }
    else
      render json: {
        success: false
      }
    end
  end

  def destroy
    if Booking.find_by(flight_id: @flight.id).present?
      render json: {
        success: false,
        errors: ["Booked"]
      }
    else
      @flight.destroy
      render json: {
        success: true
      }
    end
  end

  private
  
  def load_flight
    @flight = Flight.find(params[:id])
  end

  def pricing_params
    allowed_params = [:seat_class, :price, :date]

    params.slice(*allowed_params).permit! rescue {}
  end

  def flight_params
    params.require(:flight).permit(:aircraft_id, :departure_airport_id, :destination_airport_id, :departure_date, :destination_date)
  end
end
