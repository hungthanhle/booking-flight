class Admin::PasswordsController < DeviseTokenAuth::PasswordsController
  def update
    # make sure user is authorized
    if require_client_password_reset_token? && resource_params[:reset_password_token]
      @resource = resource_class.with_reset_password_token(resource_params[:reset_password_token])
      return render_update_error_unauthorized unless @resource

      @token = @resource.create_token
    else
      @resource = set_user_by_token
    end

    return render_update_error_unauthorized unless @resource

    # ensure that password params were sent
    unless password_resource_params[:password] && password_resource_params[:password_confirmation]
      return render_update_error_missing_password
    end

    if @resource.send(resource_update_method, password_resource_params)
      @resource.allow_password_change = false if recoverable_enabled?

      @resource.save!

      yield @resource if block_given?

      return render_update_success
    else
      return render_update_error
    end
  end

  def edit
    # if a user is not found, return nil
    @resource = resource_class.with_reset_password_token(resource_params[:reset_password_token])

    if @resource && @resource.reset_password_period_valid?
      # ensure that user is confirmed
      @resource.skip_confirmation! if confirmable_enabled? && !@resource.confirmed_at
      # allow user to change password once without current_password
      @resource.allow_password_change = true if recoverable_enabled?

      @resource.save!

      yield @resource if block_given?

      render json: {
        success: true,
        data: {
          reset_password_token: resource_params[:reset_password_token]
        }
      }
    else
      render json: {
        success: false,
        errors: [I18n.t("errors.exception.token_invalid")]
      }
    end
  end

  def render_update_error_unauthorized
    render json: {
      success: false,
      errors: [I18n.t("errors.exception.token_invalid")]
    }
  end
end
