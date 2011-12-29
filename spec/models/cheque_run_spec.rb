require 'spec_helper'

describe ChequeRun do
  describe "ChequeRun.from_csv_string" do
    before do
      @csv_string = <<CSV_DATA
Date,Chq No,Name,Description,Amount

4-Nov-2011,788981,IRAS,201012345D,-1160
4-Nov-2011,788987,Abhaya Shenoy REIMB,,-67.4
4-Nov-2011,788979,BBH (Hachi),,-3250
CSV_DATA
    end

    it "creates a cheque_run" do
      lambda {
        ChequeRun.from_csv_string @csv_string
      }.should change(ChequeRun, :count).by 1
    end

    it "creates cheques from the csv string passed in " do
      lambda {
        ChequeRun.from_csv_string @csv_string
      }.should change(Cheque, :count).by 3
    end

  end
end
