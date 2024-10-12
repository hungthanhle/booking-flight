class Admin::AdministratorsController < Admin::BaseController
  def me
    render json: {
      success: true,
      data: Admin::AdministratorSerializer.new(current_user).as_json
    }
  end

  def update
    current_user.assign_attributes(administrator_params)
    if current_user.save
      render json: {
        success: true,
        data: Admin::AdministratorSerializer.new(current_user).as_json
      }
    else
      render json: {
        success: false,
        errors: current_user.errors
      }
    end
  end

  private

    def administrator_params
      # except(:role)
      allowed_params = [:name, :password, :password_confirmation, :email]

      params[:data].slice(*allowed_params).permit! rescue {}
    end
end
