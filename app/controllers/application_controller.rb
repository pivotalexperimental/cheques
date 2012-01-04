class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate

  USER_ID = "pivotal"
  PASSWORD = "toddy8apple"

  rescue_from ActiveRecord::RecordNotFound, :with => :new_cheque_run_redirect

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == USER_ID && password == PASSWORD
    end
  end

  private

  def new_cheque_run_redirect
    redirect_to new_cheque_run_path
  end

end
