require "spec_helper"

describe Cheque do
  let(:date)    { "5-Nov-2011" }
  let(:payee)   { "Winston Teo"}
  let(:amount)  { "1234.56" }

  before { @cheque = Cheque.new(date, payee, amount) }

  describe "initialize" do
    it { @cheque.instance_variable_get(:@date).should  == "051111" }
    it { @cheque.instance_variable_get(:@payee).should == "Winston Teo" }
    it { @cheque.instance_variable_get(:@amount_text).should   == "One Thousand Two Hundred And Thirty Four And Cents Fifty Six Only**" }
    it { @cheque.instance_variable_get(:@amount_number).should == "**1,234.56" }
  end

  describe "to_pdf" do
    before { @cheque = Cheque.new(date, payee, amount) }

    it "delegates to prawn" do
      Prawn::Document.should_receive(:generate)
      @cheque.to_pdf
    end
  end
end
