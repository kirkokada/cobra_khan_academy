require 'rails_helper'

RSpec.describe "Instructional Pages", type: :request do
    subject { page }
    let(:topic) { create :topic }
    let(:uid) { "9bZkp7q19f0" } # Gangman Style!
    let(:url) { "http://youtu.be/#{uid}" }
    let(:user) { create :user }
  
  describe "new" do

    before do
      sign_in create :user, admin: true
      visit new_admin_topic_instructional_path(topic)
    end

    it "should create a new instructional" do
      fill_in "Url", with: url
      expect do
        VCR.use_cassette "instructional_save" do
          click_button "Create Instructional"
        end
      end.to change(topic.instructionals, :count).by 1
    end

    it { should have_selector "input#instructional_url"}
    it { should have_selector "input#instructional_title" }
    it { should have_selector "textarea#instructional_description" }

    it { should_not have_selector "input#instructional_author" }
    it { should_not have_selector "input#instructional_uid" }
    it { should_not have_selector "input#instructional_duration" }
    it { should_not have_selector "input#instructional_topic" }
  end

  describe "show" do
    let(:instructional) do
      VCR.use_cassette "instructional_save" do
        topic.instructionals.create(url: url)
      end
    end

    before do 
      sign_in user
      VCR.use_cassette "instructionals_show" do
        visit instructional_path(instructional)
      end
    end

    describe "page elements" do
      
      it { should have_link instructional.title, instructional.url }
      it { should have_text instructional.description }
      it { should have_link instructional.author, "http://youtube.com/user/#{instructional.author}" }
      it { should have_selector "iframe" }
    end
  end
end
