require 'spec_helper'

describe Cheque do

  let(:cheque) { Cheque.create(
    payee: 'wei',
    description: 'bonus!',
    date: 1.day.ago,
    amount: 2_000_000
  ) }

  describe "#to_prawn" do
    subject { cheque.to_prawn }

    it "creates a PrintableCheque" do
      PrintableCheque.should_receive(:new)
                      .with(cheque.date.to_s, cheque.payee, cheque.description, cheque.amount)
                      .and_return double('PrintableCheque', to_prawn: 'foo')
      subject
    end

    it "is a PrawnDocument" do
      subject.should be_a(Prawn::Document)
    end
  end

  describe "#to_tempfile" do
    subject { cheque.to_tempfile }

    it "wraps up the output stream" do
      subject.read.should == cheque.to_prawn.render.force_encoding("UTF-8")
    end
    
  end

end