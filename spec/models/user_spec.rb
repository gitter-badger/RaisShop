require 'spec_helper'

describe User do

  let(:user) { build(:user) }

  subject { user }

  it { should be_valid }
  it { should_not be_admin }
  it { should_not be_guest }

  describe "validators" do

    it { should validate_presence_of(:email) }
  end
end
