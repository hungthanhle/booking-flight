class Admin::BaseController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Error::ErrorHandler
  protect_from_forgery unless: -> { request.format.json? }

  before_action :authenticate_admin_administrator!

  def current_user
    current_admin_administrator
  end
end
