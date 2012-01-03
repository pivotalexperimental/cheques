module ControllerSpecHelper
  def basic_auth_login
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(
          ApplicationController::USER_ID,
          ApplicationController::PASSWORD
      )
  end
end