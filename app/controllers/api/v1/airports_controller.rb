class Api::V1::AirportsController < Api::V1::BaseController
  skip_before_action :authenticate_api_v1_user!, only: [:index]

  def index
    @q = Airport.ransack(name_or_code_or_country_or_city_i_cont: params[:search])
    @airports = @q.result.page(params[:page]  || 1).per(params[:per_page] || 10) || []
    render json: {
      success: true,
      data: @airports.map { |airport| AirportSerializer.new(airport).as_json },
      current_page: @airports.current_page,
      total_pages: @airports.total_pages
    }
  end
end
