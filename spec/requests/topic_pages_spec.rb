require 'rails_helper'

RSpec.describe "Topic pages", type: :request do
  subject { page }
  let(:user) { create :user }

  describe "show" do
    let!(:topic) { create :topic }

    describe "without logging in" do
      
      it "should redirect to sign in" do
        visit topic_path(topic)
        expect(page.current_path).to eq(new_user_session_path)
      end
    end

    describe "after logging in" do
      
      it "should allow access" do
        sign_in user
        visit topic_path(topic)
        expect(page.current_path).to eq(topic_path(topic))
      end
    end

    describe "elements" do

      before do 
        3.times { create :topic, parent_id: topic.id }
        sign_in user
        visit topic_path(topic)
      end
      
      it { should have_text topic.name.titleize }
      it { should have_text topic.description }

      it "should have links to child topics" do
        topic.children.each do |t|
          expect(page).to have_link t.name, topic_url(t)
        end
      end
    end
  end

  describe "admin" do
    before do
      user.toggle(:admin).save
      sign_in user
    end

    describe "index" do
      before do
        3.times { create :topic }
        visit admin_topics_path
      end

      it "should show a list of topics" do
        Topic.all.each do |topic|
          expect(page).to have_text topic.name
          expect(page).to have_link "New Child", new_admin_child_topic_path(topic)
        end
      end
    end

    describe "new topic" do

      before do 
        visit new_admin_topic_path
        fill_in "Name", with: "Topix"
        fill_in "Description", with: "Description"
      end

      it "should create a new topic" do
        expect { click_button "Create Topic" }.to change(Topic, :count).by 1 
      end
    end

    describe "new child topic" do
      let(:topic) { create :topic }
      
      before do
        visit new_admin_child_topic_path(topic)
        fill_in "Name", with: "Child Topic"
        fill_in "Description", with: "Child of a topic"
      end

      it { should have_selector "input#topic_ancestry", visible: false }

      it "should create a new child topic" do
        expect do
          click_button "Create Topic"
        end.to change(topic.children, :count).by 1
      end
    end
  end
end
