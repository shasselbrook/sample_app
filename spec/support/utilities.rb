include ApplicationHelper

def full_title(page_title)
  base_title = "Ruby on Rails Tutorial Sample App"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

def sign_in(user)
  visit signin_path
  fill_in "Email", with: user.email.upcase
  fill_in "Password", with: user.password
  click_button "Sign in"
  # sign in when not using Capybara as well
  cookies[:remember_token] = user.remember_token
end

def enter_valid_signup(email)
    fill_in "Name", with: "Example User"
    fill_in "Email", with: email
    fill_in "Password", with: "foobar"
    fill_in "Confirm Password", with: "foobar"
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-success', text: message)
  end
end
