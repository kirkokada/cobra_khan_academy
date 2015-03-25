require 'rails_helper'
require 'support/controller_helpers'

RSpec.describe InstructionalsController, type: :controller do

  describe "GET #show" do
    let(:topic) { create :topic }
    let(:instructional) do
      VCR.use_cassette "instructional_save" do
        create :instructional, topic: topic
      end
    end

    it "redirects unauthenticated users" do
      get :show, id: instructional.id
      expect(response).to have_http_status(:redirect)
    end

    it "allows authenticated users" do
      sign_in create :user
      get :show, id: instructional.id
      expect(response).to have_http_status(:success)
    end
  end
end
