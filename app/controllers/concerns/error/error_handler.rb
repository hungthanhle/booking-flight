module Error
  module ErrorHandler
    extend ActiveSupport::Concern
    include ResponseHelper

    included do
      rescue_from StandardError do |e|
        # Sentry.capture_exception(e)
        handle_500(:standard_error)
      end
      # rescue_from CanCan::AccessDenied do |e|
      #   render_error(403, [I18n.t("errors.exception.access_denied")])
      # end
      rescue_from ActiveRecord::RecordNotFound do |e|
        handle_404(:record_not_found)
      end
      rescue_from ActionController::InvalidAuthenticityToken do |e|
        handle_400(:invalid_authenticity_token)
      end
      rescue_from ActionController::RoutingError do |e|
        handle_404(:routing_error)
      end
    end

    private

    def handle_500(key)
      render_error(500, [I18n.t("errors.exception.#{key}")])
    end

    def handle_404(key)
      render_error(404, [I18n.t("errors.exception.#{key}")])
    end

    def handle_400(key)
      render_error(400, [I18n.t("errors.exception.#{key}")])
    end
  end
end
