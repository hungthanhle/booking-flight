class Api::V1::FlightsController < Api::V1::BaseController
  skip_before_action :authenticate_api_v1_user!, only: [:index, :show, :seat_availabilities, :pricings]
  before_action :load_flight, only: [:show, :seat_availabilities, :pricings]
  
  def index
    @q = Flight.includes(:aircraft, :departure_airport, :destination_airport).ransack(search_params)
    @flights = @q.result.page(params[:page]  || 1).per(params[:per_page] || 10) || []
    render json: {
      success: true,
      data: @flights.map { |flight| FlightSerializer.new(flight).as_json },
      current_page: @flights.current_page,
      total_pages: @flights.total_pages
    }
  end

  def show
    render json: {
      success: true,
      data: FlightSerializer.new(@flight).as_json
    }
  end

  def seat_availabilities
    @seat_availabilities = @flight.seat_availabilities.includes(:seat)
                              .page(params[:page]  || 1).per(params[:per_page] || 10) || []
    @pricings = @flight.pricings_hash
    
    render json: {
      success: true,
      data: @seat_availabilities.map { |seat_availability| SeatAvailabilitySerializer.new(seat_availability, @pricings).as_json },
      current_page: @seat_availabilities.current_page,
      total_pages: @seat_availabilities.total_pages
    }
  end

  def pricings
    @pricings = @flight.pricings || []
    render json: {
      success: true,
      data: @pricings.map { |pricing| PricingSerializer.new(pricing).as_json }
    }
  end

  private
  
  def search_params
    allowed_params = [
      :departure_airport_name_i_cont,
      :departure_airport_code_i_cont,
      :departure_airport_city_i_cont,
      :departure_airport_country_i_cont,
      :destination_airport_name_i_cont,
      :destination_airport_code_i_cont,
      :destination_airport_city_i_cont,
      :destination_airport_country_i_cont,
      :departure_date_eq,
      :destination_date_eq
    ]
  
    # Lấy các tham số cho phép từ params[:q]
    params[:q].slice(*allowed_params).permit! rescue {}
  end
  
  def load_flight
    @flight = Flight.find(params[:id])
  end
end
