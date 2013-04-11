require 'spec_helper'

describe "User pages" do

  let(:admin) { create(:admin) }

  subject { page }

  describe "profile page" do
    let(:user) { create(:user) }

    before do
      sign_in user
      visit edit_user_registration_path
    end

    it { should have_title(full_title(user.full_name)) }
    it { should have_selector('h2', text: user.full_name) }

    context "edit user" do
      describe "with invalid information" do
        before { click_button "Save changes" }

        it { should have_content('error') }
      end

      describe "with valid information", broken: true do
        let(:new_email) { "new@example.com" }
        let(:new_password) { "asdfqwert2" }
        before do
          fill_in "Email",                 with: new_email
          fill_in "Current password",      with: user.password
          fill_in "Password",              with: new_password
          fill_in "Password confirmation", with: new_password
          click_button "Save changes"
        end

        it { should have_selector('div.alert') }
        specify { user.reload.password.should  == new_password }
        specify { user.reload.email.should == new_email }
      end
    end
  end
end
