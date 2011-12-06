require "spec_helper"

describe Cheque do
  let(:date)    { "5-Nov-2011" }
  let(:payee)   { "Winston Teo"}
  let(:amount)  { "1234.56" }

  describe "initialize" do
    subject { Cheque.new(date, payee, amount) }

    its(:date)   { should == "051111" }
    its(:payee)  { should == "Winston Teo" }
    its(:amount_text)    { should == "One Thousand Two Hundred And Thirty Four And Cents Fifty Six Only" }
    its(:amount_number)  { should == "**1,234.56" }
  end

  describe "to_pdf" do
    before { @cheque = Cheque.new(date, payee, amount) }

    it "delegates to prawn" do
      Prawn::Document.should_receive(:generate)
      @cheque.to_pdf
    end
  end
end
