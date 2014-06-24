module ControllerSpecHelper
  def basic_auth_login
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(
          $htaccessUsername,
          $htaccessPassword
      )
  end
end
