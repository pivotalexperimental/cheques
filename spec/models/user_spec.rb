require 'spec_helper'

describe User do

  it "must belong to an organization" do
    user = FactoryGirl.build(:user, :organization => nil)

    user.should_not be_valid
    user.organization = FactoryGirl.create :organization
    user.should be_valid
  end
end
