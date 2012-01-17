require 'spec_helper'

describe Organization do

  it "should have a name" do
    organization = FactoryGirl.build :organization, :name => nil
    organization.should be_invalid
    organization.name = "The Good Guys"
    organization.should be_valid
  end

end
