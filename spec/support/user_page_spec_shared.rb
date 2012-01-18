shared_examples_for "a logged in user page" do

  it "should have a username" do
    page.should have_css("#username", text: user.full_name )
  end

  it "should show the user's organization" do
    page.should have_css("#organization", text: user.organization.name )
  end

  it "should have a logout link" do
    click_link "Logout"
    current_path.should == new_user_session_path
  end

end