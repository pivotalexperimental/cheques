require 'spec_helper'

describe "/" do
  before do
    fill_in_basic_auth
  end

  it "redirects to /cheque_runs/new" do
    visit '/'
    page.current_path.should == new_cheque_run_path
  end
end
