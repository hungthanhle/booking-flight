class Api::V1::RegistrationsController < DeviseTokenAuth::RegistrationsController
  # Registrations
  before_action :configure_permitted_parameters, only: [:create]

  def create
    super
  end

  private

  def render_create_error_missing_confirm_success_url
    response = {
      success: false,
      data:   resource_data
    }
    message = I18n.t('devise_token_auth.registrations.missing_confirm_success_url')
    render_error(422, message, response)
  end

  def render_create_error_redirect_url_not_allowed
    response = {
      success: false,
      data:   resource_data
    }
    message = I18n.t('devise_token_auth.registrations.redirect_url_not_allowed', redirect_url: @redirect_url)
    render_error(422, message, response)
  end

  def render_create_success
    render json: {
      success: true,
      data: UserSerializer.new(@resource).as_json
    }
  end

  def render_create_error
    render json: {
      success: false,
      data: resource_data,
      errors: resource_errors
    }, status: :ok
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
