# frozen_string_literal: true

class Api::V1::SessionsController < DeviseTokenAuth::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  # protected

  #   def after_sign_in_path_for(resource)
  #   end

  private
  def render_create_success
    data = @resource.token_validation_response
    data.merge!(UserSerializer.new(@resource).as_json)
    render json: {
      success: true,
      data: resource_data(resource_json: data),
    }
  end

  def create_and_assign_token
    lifespan = params[:remember_me] ? DeviseTokenAuth.token_lifespan : 1.day
    if @resource.respond_to?(:with_lock)
      @resource.with_lock do
        @token = @resource.create_token(lifespan: lifespan)
        @resource.save!
      end
    else
      @token = @resource.create_token(lifespan: lifespan)
      @resource.save!
    end
  end

  def render_create_error_bad_credentials
    render json: {
      success: false,
      errors: [I18n.t('devise_token_auth.sessions.bad_credentials')],
    }
  end
end
