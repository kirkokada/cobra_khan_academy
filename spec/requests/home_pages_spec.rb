require 'rails_helper'

RSpec.describe "Home page", type: :request do
  subject { page }

  describe "elements" do
    before { visit root_path }

    
    it { should have_link "Sign in" }
    it { should have_link "Create account" }  
  end
end
