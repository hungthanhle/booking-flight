class Api::V1::UsersController < Api::V1::BaseController
  def me
    render json: {
      success: true,
      data: UserSerializer.new(current_user).as_json
    }
  end

  def update
    current_user.assign_attributes(user_params)
    if current_user.save
      render json: {
        success: true,
        data: UserSerializer.new(current_user).as_json
      }
    else
      render json: {
        success: false,
        errors: current_user.errors
      }
    end
  end

  private

    def user_params
      allowed_params = [:name, :password, :password_confirmation, :email]

      params[:data].slice(*allowed_params).permit! rescue {}
    end
end
