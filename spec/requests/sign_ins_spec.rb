require 'rails_helper'

RSpec.describe "Sign In", type: :request do

  subject { page }

  let(:user) { create :user }

  before do
    visit root_path
    click_link "Sign in"
  end

  describe "with invalid information" do
    before do
      fill_in "Email", with: " "
      fill_in "Password", with: " "
      click_button "Sign in"
    end

    it { should_not have_link "Sign out" }
    it { should have_selector "div.alert-danger" }
  end

  describe "with valid information" do
    before do
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Sign in"
    end

    it { should have_link "Sign out" }
    it { should have_selector "div.alert-success" }

    it "should redirect to root" do
      expect(page.current_path).to eq root_path
    end
  end
end
