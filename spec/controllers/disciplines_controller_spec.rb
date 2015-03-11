require 'rails_helper'
require "support/controller_helpers"

RSpec.describe DisciplinesController, type: :controller do
  describe "GET #show" do
    it "returns http redirect when not signed in" do
      get :show, id: 1
      expect(response).to have_http_status('302')
    end
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status('302')
    end
  end
end
