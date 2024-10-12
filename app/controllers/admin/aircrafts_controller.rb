class Admin::AircraftsController < Admin::BaseController
  def index
    @q = Aircraft.ransack(params[:q])
    @aircrafts = @q.result.page(params[:page]  || 1).per(params[:per_page] || 10) || []
    render json: {
      success: true,
      data: @aircrafts.map { |aircraft| Admin::AircraftSerializer.new(aircraft).as_json },
      current_page: @aircrafts.current_page,
      total_pages: @aircrafts.total_pages
    }
  end
end
