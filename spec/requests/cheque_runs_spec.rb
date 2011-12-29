require 'spec_helper'

describe '/cheque_runs' do
  before do
    fill_in_basic_auth
  end

  it "has a form that accepts a file upload" do
    visit new_cheque_run_path
    attach_file('Cheque File', "#{Rails.root}/spec/fixtures/cheques.csv")
    click_button 'Submit'

    page.should have_css("table#cheque_run")
  end
end
