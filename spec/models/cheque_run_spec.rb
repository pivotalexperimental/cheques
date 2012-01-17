require 'spec_helper'

describe ChequeRun do

  let(:user) { FactoryGirl.create(:user) }

  describe ".from_csv_string" do
    context "when encounters a line of invalid string" do
      before do
        @csv_string = <<CSV_DATA
Date,Chq No,Name,Description,Amount

4-Nov-2011,,,,
CSV_DATA
      end

      it "ignores lines without a payee or an amount" do
        cheque_run = ChequeRun.from_csv_string @csv_string, user
        cheque_run.cheques.size.should == 0
      end
    end

    context "when csv string is valid" do
      before do
        @csv_string = <<CSV_DATA
Date,Chq No,Name,Description,Amount

4-Nov-2011,788981,IRAS,201012345D,-1160
4-Nov-2011,788987,Abhaya Shenoy REIMB,,-67.4
4-Nov-2011,788979,BBH (Hachi),,-3250
CSV_DATA
      end

      it "creates a cheque_run together with cheques from the csv string passed in" do
        lambda {
          cheque_run = ChequeRun.from_csv_string @csv_string, user

          cheque_run.cheques.size.should == 3

          cheque = cheque_run.cheques.first
          cheque.payee.should == 'IRAS'
          cheque.amount.should == 1160
          cheque.description.should == '201012345D'
          cheque.date.should == Date.new(2011, 11, 4)
        }.should change(ChequeRun, :count).by 1
      end

      it "sets the owner" do
        cheque_run = ChequeRun.from_csv_string @csv_string, user
        cheque_run.reload.owner.should == user
      end
    end
  end


  describe "#to_tempfile" do
    subject { cheque_run.to_tempfile }

    let(:cheque_run) { ChequeRun.from_csv_file Rails.root.join('spec', 'fixtures', 'cheques.csv'), user }
    let(:a_lot_of) { cheque_run.cheques.size }

    it { should be_a(Tempfile) }

    it "uses tempfiles of all its cheques" do
      Zip::ZipFile.open(subject).should have(a_lot_of).cheques
    end
  end
end
