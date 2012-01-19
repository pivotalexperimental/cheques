class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate
  before_filter :authenticate_user!

  USER_ID = "pivotal"
  PASSWORD = "toddy8apple"

  rescue_from ActiveRecord::RecordNotFound, :with => :root_redirect

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == USER_ID && password == PASSWORD
    end
  end

  private

  def root_redirect
    redirect_to root_path
  end

  def render_403
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/403.html", :status => 403, :layout => false }
      format.any(:zip,:pdf) { render nothing: true, status: 403 }
    end
  end

end
