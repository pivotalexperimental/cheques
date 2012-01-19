require 'spec_helper'

describe ChequesController do

  let(:cheque) { FactoryGirl.create :cheque }

  describe "#show" do

    let(:user) { cheque.cheque_run.owner }

    before do
      basic_auth_login
      sign_in user
    end

    it "renders a pdf binary" do
      @prawn_document = double(:prawn_document)
      cheque.stub!(:to_prawn).and_return(@prawn_document)
      Cheque.stub!(:find).and_return(cheque)
      @prawn_document.should_receive(:render)
      get :show, id: cheque.to_param, format: 'pdf'
      response.headers['Content-Type'].should == 'application/pdf'
    end

    it "forbids access if user organization does not own cheque" do
      rival_run = FactoryGirl.create :cheque_run, owner: FactoryGirl.create(:rival)
      rival_cheque = FactoryGirl.create :cheque, cheque_run: rival_run
      get :show, :id => rival_cheque.to_param, format: 'pdf'
      response.status.should == 403
    end

  end

end