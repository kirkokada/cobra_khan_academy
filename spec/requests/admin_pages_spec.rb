require 'rails_helper'

RSpec.describe "Admin pages", type: :request do
  subject { page }

  describe "get /admin" do

    describe "without signing in" do
      
      it "should redirect to sign in page" do
        visit admin_root_path
        expect(page.current_path).to eq new_user_session_path
      end
    end

    describe "as a non-admin" do
      let(:user) { create :user, admin: false }

      it "should redirect to root" do
        sign_in user
        visit admin_root_path
        expect(page.current_path).not_to eq(admin_root_path)
        expect(page.current_path).to eq(root_path)
      end
    end

    describe "as an admin" do
      let(:user) { create :user, admin: true }

      it "should allow access" do
        sign_in user
        visit admin_root_path
        expect(page.current_path).to eq(admin_root_path)
      end
    end
  end

  describe "dashboard" do
    
    context "when instructional does not belong to a topic" do
      let(:user) { create :user, admin: true }
      let(:topic) { create :topic }
      let(:instructional) { create_instructional topic: topic }

      before do
        sign_in user 
        instructional.update_column(:topic_id, nil) 
      end

      it "should not raise an error" do
        expect { visit admin_root_path }.not_to raise_error
      end

      it "should indicate that no topic is set" do
        visit admin_root_path
        expect(page).to have_content "No topic set"
      end
    end
  end
end
