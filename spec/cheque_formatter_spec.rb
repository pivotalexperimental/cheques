require 'spec_helper'

describe ChequeFormatter do
  describe ".date_to_ddmmyy" do
    subject { ChequeFormatter.date_to_ddmmyy(date) }

    context "5-Nov-2011" do
      let(:date) { "5-Nov-2011" }
      it { should == '051111' }
    end

    context "2011-11-05" do
      let(:date) { "5-Nov-2011" }
      it { should == '051111' }
    end
  end

  describe ".amount_to_text" do
    # Source: http://www.moneysense.gov.sg/resource/publications/quick_tips/Graphicised%20cheque%20-%20FINAL.pdf

    subject { ChequeFormatter.amount_to_text(number) }

    context "handles negative numbers" do
      let(:number) { -1000 }
      it { should == 'One Thousand And Cents Zero Only' }
    end

    context "1000" do
      let(:number) { 1000 }
      it { should == 'One Thousand And Cents Zero Only' }
    end

    context "1001" do
      let(:number) { 1001 }
      it { should == 'One Thousand And One And Cents Zero Only' }
    end

    context "1010" do
      let(:number) { 1010 }
      it { should == 'One Thousand And Ten And Cents Zero Only' }
    end

    context "1100" do
      let(:number) { 1100 }
      it { should == 'One Thousand One Hundred And Cents Zero Only' }
    end

    context "1303.53" do
      let(:number) { 1303.53 }
      it { should == 'One Thousand Three Hundred And Three And Cents Fifty Three Only' }
    end
  end

  describe ".amount_to_number" do

    subject { ChequeFormatter.amount_to_number(number) }

    context "handles negative numbers" do
      let(:number) { -1000 }
      it { should == '1,000.00' }
    end

    context "1" do
      let(:number) { 1 }
      it { should == '1.00' }
    end

    context "10" do
      let(:number) { 10 }
      it { should == '10.00' }
    end

    context "100" do
      let(:number) { 100 }
      it { should == '100.00' }
    end

    context "1000" do
      let(:number) { 1000 }
      it { should == '1,000.00' }
    end

    context "1000000" do
      let(:number) { 1000000 }
      it { should == '1,000,000.00' }
    end

    context "1000000.50" do
      let(:number) { 1000000.50 }
      it { should == '1,000,000.50' }
    end
  end
end
