class Api::BaseController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Error::ErrorHandler
  protect_from_forgery unless: -> { request.format.json? }
end
