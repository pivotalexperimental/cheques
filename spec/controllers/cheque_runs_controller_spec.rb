require 'spec_helper'

describe ChequeRunsController do

  let(:current_user) { FactoryGirl.create(:user) }

  let!(:cheque_run) do
    ChequeRun.from_csv_file Rails.root.join('spec', 'fixtures', 'cheques.csv'), current_user
  end

  before do
    basic_auth_login
    sign_in current_user
  end

  describe "#show" do

    subject { get :show, :id => cheque_run.to_param, :format => format }

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

      it "keeps the cheque run" do
        cheque_count = cheque_run.cheques.count
        expect {
          subject
        }.to_not change(ChequeRun, :count)

        Cheque.where(cheque_run_id: cheque_run.id).should have(cheque_count).cheques
      end
    end

  end

  describe "#index" do

    subject { get :index }

    it { should be_success }

    it "should only list cheque runs owned by current user" do
      other_user = FactoryGirl.create(:user)
      other_cheque_run = ChequeRun.from_csv_file Rails.root.join('spec', 'fixtures', 'cheques.csv'), other_user
      subject
      assigns(:cheque_runs).should have_exactly(current_user.cheque_runs.count).items

      current_user.cheque_runs.each { |cheque_run|
        assigns(:cheque_runs).should include(cheque_run)
      }
    end

  end

end