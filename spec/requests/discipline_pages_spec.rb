require 'rails_helper'

RSpec.describe "Discipline", type: :request do
  subject { page }
  let(:discipline) { create :discipline }
  let(:user) { create :user }

  describe "show page" do

    describe "without logging in" do
      
      it "should redirect to sign in" do
        visit discipline_path(discipline)
        expect(page.current_path).to eq(new_user_session_path)
      end
    end

    describe "after logging in" do
      
      it "should allow access" do
        sign_in user
        visit discipline_path(discipline)
        expect(page.current_path).to eq(discipline_path(discipline))
      end
    end

    describe "elements" do

      before do 
        sign_in user
        visit discipline_path(discipline)
      end
      
      it { should have_text discipline.name.titleize }
      it { should have_text discipline.description }
    end
  end
end
