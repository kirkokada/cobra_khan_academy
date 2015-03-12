require 'rails_helper'

RSpec.describe "Topic", type: :request do
  subject { page }
  let!(:topic) { create :topic }
  let(:user) { create :user }

  describe "show page" do

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

      it "should have links to subtopics" do
        topic.subtopics.each do |t|
          expect(page).to have_link t.name, topic_url(t)
        end
      end
    end
  end
end
