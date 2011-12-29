require 'spec_helper'

describe '/cheque_runs' do
  before do
    fill_in_basic_auth
  end

  it "has a form that accepts a file upload, parse the file and display cheques in a table" do
    visit new_cheque_run_path
    attach_file('Cheque File', "#{Rails.root}/spec/fixtures/cheques.csv")
    click_button 'Submit'

    page.should have_css("table#cheque_run tr", :count => 16)
  end
end
