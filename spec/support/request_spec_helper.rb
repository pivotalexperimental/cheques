module RequestSpecHelper
  include ActionView::Helpers::NumberHelper

  def fill_in_basic_auth
    page.driver.browser.basic_authorize($htaccessUsername, $htaccessPassword)
  end
end
