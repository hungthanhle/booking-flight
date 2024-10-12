class ApplicationController < ActionController::Base
        include DeviseTokenAuth::Concerns::SetUserByToken
  helper ApplicationHelper
  skip_before_action :verify_authenticity_token, if: :devise_controller?
end
