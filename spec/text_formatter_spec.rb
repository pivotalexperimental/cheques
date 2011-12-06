require 'spec_helper'

describe TextFormatter do
  describe ".number_to_words" do
    # Source: http://www.moneysense.gov.sg/resource/publications/quick_tips/Graphicised%20cheque%20-%20FINAL.pdf

    subject { TextFormatter.number_to_words(number) }

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
end
