require 'rails_helper'

RSpec.describe "Sign up and sign in", type: :request do
  subject { page }

  before do
    visit root_path
    click_link "Create account"
  end

  describe "with invalid information" do
    before do
      fill_in "Email", with: " "
      fill_in "Password", with: " "
      fill_in "Password confirmation", with: " "
    end

    it "should not create a new user" do
      expect { click_button "Sign up"}.not_to change(User, :count)
    end

    it "should display errors" do
      click_button "Sign up" 
      expect(page).to have_selector "div#error_explanation"
    end
  end

  describe "with valid information" do
    before do
      fill_in "Email", with: "user@email.com"
      fill_in "Password", with: "password" 
      fill_in "Password confirmation", with: "password"
    end

    it "should create a new user" do
      expect { click_button "Sign up" }.to change(User, :count)
    end

    it "should display a success message" do
      click_button "Sign up"
      expect(page).to have_selector "div.alert-success"
      expect(page).to have_link "Sign out", href: destroy_user_session_path
    end
  end
  
end
