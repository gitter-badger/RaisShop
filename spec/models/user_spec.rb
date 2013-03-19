require 'spec_helper'

describe User do

  let(:user) { build(:user) }
  let(:guest) { build(:guest) }

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
    describe "presence of attribute" do
      [:full_name].each do |attr|
        it { should validate_presence_of(attr) }
      end
    end

    context "when user is a guest" do

      subject { guest }

      it "allows blank email" do
        2.times do |n|
          u = build(:guest, email: "")
          expect(u.save).to be_true
        end
      end

      describe "when email is already taken" do
        before do
          guest_with_same_email = build(:guest)
          guest_with_same_email.email = guest.email.upcase
          guest_with_same_email.save
        end
        it { should_not be_valid }
      end

      it { should allow_value('').for(:password) }
    end

    it { should_not allow_mass_assignment_of(:guest) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should allow_value('robert@gmail.com').for(:email) }
    it { should_not allow_value('gmail.com').for(:email) }
  end

  describe "makes user a guest" do
    context "with an address but without a password" do
      before do
        subject.addresses << create(:address)
        subject.password = ""
        subject.save
      end

      it { should be_guest }
      it { should be_valid }
    end
  end

  describe "doesn't make user a guest" do
    context "without an address but with a password" do
      before do
        subject.password = "password"
        subject.addresses = []
        subject.save
      end

      it { should_not be_guest }
      it { should be_valid }
    end
  end
end
