class Admin::AirportsController < Admin::BaseController
  def index
    @q = Airport.ransack(params[:q])
    @airports = @q.result.group(:id).page(params[:page]  || 1).per(params[:per_page] || 10)  || []
    render json: {
      success: true,
      data: @airports.map { |airport| Admin::AirportSerializer.new(airport).as_json },
      current_page: @airports.current_page,
      total_pages: @airports.total_pages
    }
  end
end
