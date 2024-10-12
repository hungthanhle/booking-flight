class Api::V1::BaseController < Api::BaseController
  before_action :authenticate_api_v1_user!
  
  def current_user
    current_api_v1_user
  end

  # def needs_confirmation!
  #   return render_error(401, [I18n.t("errors.exception.unauthorized")]) unless current_user.blank? || current_user.confirmed?
  # end
end
