module RequestSpecHelper
  def fill_in_basic_auth
    page.driver.browser.basic_authorize(ApplicationController::USER_ID, ApplicationController::PASSWORD)
  end
end
