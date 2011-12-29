class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate

  USER_ID = "pivotal"
  PASSWORD = "toddy8apple"

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == USER_ID && password == PASSWORD
    end
  end

end
