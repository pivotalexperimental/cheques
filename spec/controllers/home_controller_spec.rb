require 'spec_helper'

describe HomeController do
  describe "#index" do

    context "when the basic auth credentials are supplied" do

      before do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(
            ApplicationController::USER_ID,
            ApplicationController::PASSWORD
        )
      end

      it "is successful" do
        get :index
        response.code.should == "302"
      end
    end

    context "when the basic auth credentials are not supplied" do
      it "is not successful" do
        get :index
        response.code.should == "401"
      end
    end
  end
end
