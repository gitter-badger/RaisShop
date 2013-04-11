require 'spec_helper'

describe User do

  let(:user) { build(:user) }

  subject { user }

  it { should be_valid }
  it { should_not be_admin }
  it { should_not be_guest }

  describe "associations" do
    it { should have_many(:orders).through(:addresses) }
    it { should have_many(:reviews).dependent(:nullify) }
    it { should accept_nested_attributes_for(:addresses) }
    #it { should have_db_index(:address_id) }
  end

  describe "validators" do

    it { should validate_presence_of(:full_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should allow_value('robert@gmail.com').for(:email) }
    it { should_not allow_value('gmail.com').for(:email) }
    it { should_not allow_mass_assignment_of(:guest) }

    context "when user is a guest" do
      subject { User.new_guest }

      it { should allow_value('').for(:password) }

      it "allows blank email" do
        2.times do |n|
          u = build(:guest, email: "")
          expect(u.valid?).to be_true
        end
      end
    end
  end
end
