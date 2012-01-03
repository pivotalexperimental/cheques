require "spec_helper"

describe PrintableCheque do
  let(:date)    { "5-Nov-2011" }
  let(:payee)   { "Winston Teo"}
  let(:desc)    { "A jolly good fellow"}
  let(:amount)  { "1234.56" }

  let(:cheque) { PrintableCheque.new(date, payee, desc, amount) }

  describe "initialize" do
    it { cheque.instance_variable_get(:@date).should  == "051111" }
    it { cheque.instance_variable_get(:@payee).should == payee }
    it { cheque.instance_variable_get(:@desc).should  == desc }
    it { cheque.instance_variable_get(:@amount_text).should   == "One Thousand Two Hundred And Thirty Four And Cents Fifty Six Only" }
    it { cheque.instance_variable_get(:@amount_number).should == "1,234.56" }
  end


  describe "to_prawn" do
    subject { cheque.to_prawn }

    it "creates a new prawn document" do
      Prawn::Document.should_receive(:new)
      subject
    end
  end

end
