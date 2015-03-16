require 'rails_helper'
require 'support/controller_helpers'

RSpec.describe TopicsController, type: :controller do

  subject { response }

  describe "#show" do
    
    describe "without logging in" do
      before { get :show, id: 1 }

      it { should redirect_to new_user_session_url }
    end

    describe "after logging in" do
      before do
        sign_in create :user
        get :show, id: create(:topic).id
      end

      it { should have_http_status(:success) }
    end
  end
end
