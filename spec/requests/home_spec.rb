require 'spec_helper'

describe "/" do
  before do
    page.driver.browser.basic_authorize(ApplicationController::USER_ID, ApplicationController::PASSWORD)
  end

  it "has a form that accepts a file upload" do
    visit '/'
    attach_file('Cheque File', "#{Rails.root}/spec/fixtures/cheques.csv")
    click_button 'Submit'

    page.should have_css("table")
  end
end
