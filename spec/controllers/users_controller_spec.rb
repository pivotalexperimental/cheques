require 'spec_helper'

describe UsersController do
  render_views

  context "user is logged in" do

    let(:current_user) { FactoryGirl.create :user }

    before do
      basic_auth_login
      sign_in current_user
    end

    describe "#edit" do

      subject { get :edit, id: current_user.to_param, format: "html" }

      it { should be_success }

    end

    describe "#update" do

      subject { put :update, id: current_user.to_param, format: "html", user: {
          current_password: current_user.password,
          password: current_user.password,
          password_confirmation: current_user.password,
      }}

      it { should be_redirect }

    end

  end

end
