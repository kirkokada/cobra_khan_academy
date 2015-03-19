require 'rails_helper'

RSpec.describe "Instructional Pages", type: :request do
    subject { page }
    let(:topic) { create :topic }
    let(:uid) { "9bZkp7q19f0" } # Gangman Style!
    let(:url) { "http://youtu.be/#{uid}" }
    let(:user) { create :user }

  describe "admin" do

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

  describe "new" do
    
    context "when an unauthenticated user visits" do
      
      before { visit new_topic_instructional_path(topic) }

      it "should redirect to sign in" do
        expect(page.current_path).to eq(new_user_session_path)
      end
    end

    context "when an authenticated user visits" do
      
      before do
        sign_in user
        visit new_topic_instructional_path(topic)
      end

      its(:current_path) { should eq new_topic_instructional_path(topic) }

      context "and inputs an invalid url" do
        
        before { fill_in "Url", with: "invalid.url" }

        it "should not create an instructional" do
          expect do
            VCR.use_cassette "invalid_instructional_save" do
              click_button "Submit"
            end
          end.not_to change(topic.instructionals, :count)
        end

        it "should show error messages" do
          VCR.use_cassette "invalid_instructional_save" do
            click_button "Submit"
          end
          expect(page).to have_selector "div#error_messages"
        end
      end

      context "and inputs a valid url" do
        before do
          fill_in "Url", with: url
        end

        it "should create an instructional" do
          expect do
            VCR.use_cassette "instructional_save" do
              click_button "Submit"
            end
          end.to change(topic.instructionals, :count).by(1)
        end

        it "should redirect to topic page" do
          VCR.use_cassette "instructional_save" do
            click_button "Submit"
          end
          expect(page.current_path).to eq topic_path(topic)
        end
      end
    end
  end
end
