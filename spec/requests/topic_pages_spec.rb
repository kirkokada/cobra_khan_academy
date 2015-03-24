require 'rails_helper'

RSpec.describe "Topic pages", type: :request do
  subject { page }
  let(:user) { create :user }
  let!(:topic) { create :topic }

  describe "show" do

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

    describe "page" do
      let!(:low_priority) { create :topic, name: "a topic", 
                                           parent: topic, 
                                           priority: 10 }
      let!(:high_priority) { create :topic, name: "Z topic", 
                                            parent: topic, 
                                            priority: 1 }
      before do 
        create_instructional
        VCR.use_cassette "instructional_save_2" do
          create :instructional, url: "https://youtu.be/kffacxfA7G4", # Justin Bieber - Baby
                                 topic: topic.children.first
        end
        sign_in user
        visit topic_path(topic)
      end
      
      it { should have_text topic.name.titleize }
      it { should have_text topic.description }
      it { should have_link "Submit an instructional", new_topic_instructional_path(topic) }

      it "should have links to child topics" do
        topic.children.each do |t|
          expect(page).to have_link t.name, topic_url(t)
        end
      end

      it "should have links to child topics in the order of ascending priority" do
        expect(page).to have_selector "div.subtopics div:nth-child(2)", text: high_priority.name
        expect(page).to have_selector "div.subtopics div:nth-child(3)", text: low_priority.name
      end

      it "should have links to instructionals" do
        topic.descendant_instructionals.each do |i|
          expect(page).to have_link i.title, instructional_url(i)
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
          expect(page).to have_link "New Subtopic", new_admin_child_topic_path(topic)
          expect(page).to have_link "New Instructional", new_admin_topic_instructional_path(topic)
        end
      end
    end

    describe "show" do
      before do
        VCR.use_cassette "instructional_save" do
          create :instructional, topic: topic
        end
        visit admin_topic_path(topic)
      end
      
      describe "page" do
        
        it { should have_link "New Instructional", new_admin_topic_instructional_path(topic) }
        it { should have_content topic.name }
        it { should have_content topic.description }
        it { should have_content topic.slug }
        it { should have_content topic.ancestry }
        it { should have_content topic.priority }

        it "should display instructionals" do
          topic.instructionals.each do |instructional|
            expect(page).to have_text instructional.title
            expect(page).to have_link "Edit", 
                                       edit_admin_topic_instructional_path(topic, instructional)
            expect(page).to have_link "Delete",
                                      admin_topic_instructional_path(topic, instructional)
          end
        end
      end
    end

    describe "form" do

      before do 
        visit new_admin_topic_path
        fill_in "Name", with: "Topix"
        fill_in "Description", with: "Description"
        fill_in "Priority", with: "1"
      end

      it "should create a new topic" do
        expect { click_button "Create Topic" }.to change(Topic, :count).by 1 
      end

      it "should update an existing topic" do
        click_button "Create Topic"
        visit edit_admin_topic_path(Topic.last)
        fill_in "Name",       with: "Topicks"
        fill_in "Description", with: "Descripshun"
        fill_in "Priority",   with: "2"
        click_button "Update Topic"
        expect(Topic.last.name).to eq "Topicks"
        expect(Topic.last.description).to eq "Descripshun"
        expect(Topic.last.priority). to eq 2
      end
    end

    describe "new child topic" do
      let(:topic) { create :topic }
      
      before do
        visit new_admin_child_topic_path(topic)
        fill_in "Name", with: "Child Topic"
        fill_in "Description", with: "Child of a topic"
      end

      it { should have_selector "select#topic_parent_id" }

      it "should create a new child topic" do
        expect do
          click_button "Create Topic"
        end.to change(topic.children, :count).by 1
      end
    end
  end
end
