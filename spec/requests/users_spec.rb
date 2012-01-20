require 'spec_helper'

describe "/cheque_runs resource" do

  include Warden::Test::Helpers
  after { Warden.test_reset! }

  let(:user) { FactoryGirl.create(:user, first_name: "Don", last_name: "Larsen") }

  before do
    fill_in_basic_auth
    login_as user
  end

  describe '/users/:id/edit' do
    before do
      visit edit_user_path user
    end

    it_should_behave_like "a logged in user page"

    it "allows to change user password" do
      fill_in "Password", with: "new_password"
      fill_in "Password confirmation", with: "new_password"
      fill_in "Current password", with: user.password
      click_button "Update"
      page.current_path.should == root_path
      page.should have_css(".notice", text: "Password successfully updated")

      click_on "Logout"
      fill_in "Email", with: user.email
      fill_in "Password", with: "new_password"
      click_on "Sign in"
      page.current_path.should == root_path
    end

    it "disallows change of password if current password is invalid" do
      fill_in "Password", with: "new_password"
      fill_in "Password confirmation", with: "new_password"
      fill_in "Current password", with: "wrong password"
      click_button "Update"
      page.should have_css("h2", text: "Edit #{user.full_name}")
      page.should have_css("div#error_explanation li", text: "Current password is invalid")
    end

    it "disallows change of password if password confirmation doesn't match" do
      fill_in "Password", with: "new_password"
      fill_in "Password confirmation", with: "not the new_password"
      fill_in "Current password", with: user.password
      click_button "Update"
      page.should have_css("h2", text: "Edit #{user.full_name}")
      page.should have_css("div#error_explanation li", text: "Password doesn't match confirmation")
    end

  end
end
