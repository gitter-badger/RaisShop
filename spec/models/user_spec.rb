require 'spec_helper'

describe User do

  let(:user) { build(:user) }

  subject { user }

  it { should be_valid }
  it { should_not be_admin }
  it { should_not be_guest }

  describe "associations" do
    it { should have_many(:reviews).dependent(:nullify) }
  end

  describe "validators" do

    it { should validate_presence_of(:email) }
    it { should_not allow_mass_assignment_of(:guest) }
  end
end
