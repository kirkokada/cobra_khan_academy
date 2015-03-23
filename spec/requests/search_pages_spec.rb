require 'rails_helper'
require "support/elasticsearch"

RSpec.describe "Search pages", type: :request do
  subject { page }
  let(:user) { create :user }
  let!(:topic) { create :topic }
  let!(:unrelated_topic) { create :topic, name: "Unrelated" }
  let!(:instructional) { create_instructional topic: topic }
  let(:query) { instructional.title.split(" ").first } # "PSY" 

  context "as an unauthenticated user" do
    before do
      visit root_path
      fill_in "navbar_search", with: "stuff"
    end

    it "should redirect to sign in" do
      click_button "search_submit"
      expect(page.current_path).to eq(new_user_session_path)
    end
  end

  context "as an authenticated user" do
    before do
      sign_in user
      visit root_path
      Instructional.import # Update the elastic search index
      sleep 1 # Allow elastic search to catch up
      fill_in "navbar_search", with: query
      click_button "search_submit"
    end

    it "should have the correct results", elasticsearch: true do 
      expect(page).to have_link instructional.title, instructional_path(instructional)
      expect(page).to have_link topic.name, topic_path(topic)
    end
    
    it "should not have unrelated results", elasticsearch: true do
      expect(page).not_to have_selector "div##{unrelated_topic.slug}"
    end
  end
end
