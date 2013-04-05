include ApplicationHelper

def sign_in(user)
  visit new_user_session_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Login"
  visit root_path
end

RSpec::Matchers::define :have_title do |text|
  match do |page|
    Capybara.string(page.body).has_selector?('title', text: text)
  end
end
