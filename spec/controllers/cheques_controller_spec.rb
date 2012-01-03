require 'spec_helper'

describe ChequesController do

  let(:cheque) { Cheque.create(
      payee: 'wei',
      description: 'bonus!',
      date: 1.day.ago,
      amount: 2_000_000
  ) }

  describe "#show" do

    before do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(
          ApplicationController::USER_ID,
          ApplicationController::PASSWORD
      )

      @prawn_document = double(:prawn_document)
      cheque.stub!(:to_prawn).and_return(@prawn_document)
      Cheque.stub!(:find).and_return(cheque)
    end

    it "renders a pdf binary" do
      @prawn_document.should_receive(:render)
      get :show, id: cheque.to_param, format: 'pdf'
      response.headers['Content-Type'].should == 'application/pdf'
    end

  end

end