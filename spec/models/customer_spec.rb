require 'spec_helper'

describe Customer do

  let(:customer) { create(:customer) }

  subject { customer }

  it { should validate_presence_of(:full_name) }
  it { should allow_value('').for(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should allow_value('robert@gmail.com').for(:email) }
  it { should_not allow_value('gmail.com').for(:email) }

  it "allows blank email" do
    2.times do |n|
      u = build(:customer, email: "")
      expect(u.valid?).to be_true
    end
  end
end
