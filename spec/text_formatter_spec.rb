require 'spec_helper'

describe TextFormatter do
  describe ".amount_to_words" do
    it "returns the dollar amount in words" do
      TextFormatter.amount_to_words("1000").should == 'One Thousand Dollars'
      TextFormatter.amount_to_words("1050").should == 'One Thousand and Fifty Dollars'
      TextFormatter.amount_to_words("1350").should == 'One Thousand Three Hundred and Fifty Dollars'
      TextFormatter.amount_to_words("1050.01").should == 'One Thousand and Fifty Dollars and One Cent'
    end
  end
end
