require 'spec_helper'

describe ChequeRunsController do

  let!(:cheque_run) { ChequeRun.from_csv_file Rails.root.join('spec', 'fixtures', 'cheques.csv') }

  describe "#show" do

    subject { get :show, :id => cheque_run.to_param, :format => format }

    before do
      basic_auth_login
    end

    context "html" do
      let(:format) { 'html' }

      it { should be_success }
    end

    context "zip" do
      let(:format) { 'zip' }

      it { should be_success }

      it "returns pleasantly named zip" do
        subject
        response.headers['Content-Disposition'].should match(/cheque_run_#{cheque_run.id}\.zip/i)
        response.headers['Content-Type'].should == 'application/zip'
      end

      it "deletes everything" do
        expect {
          subject
        }.to change(ChequeRun, :count).by(-1)

        Cheque.where(cheque_run_id: cheque_run.id).should have(0).cheques
      end
    end

  end

end