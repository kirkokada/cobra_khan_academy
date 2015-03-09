require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.new(email: "user@email.com",
                        password: "password",
                        password_confirmation: "password")}

  subject { user }

  describe "when email" do

    describe "is blank" do
      
      it "should not be valid" do
        user.email = ""
        expect(user).not_to be_valid
      end
    end

    describe "is nil" do
      
      it "should not be valid" do
        user.email = nil
        expect(user).not_to be_valid
      end
    end
  end

  describe "when password" do
    
    describe "is blank" do
      
      it "should not be valid" do
        user.password = ""
        expect(user).not_to be_valid
      end
    end

    describe "is nil" do
      
      it "should not be valid" do
        user.password = ""
        expect(user).not_to be_valid
      end
    end
  end

  describe "when password_confirmation" do
    
    describe "does not match password" do
      
      it "should not be valid" do
        user.password_confirmation = "mismatch"
        expect(user).not_to be_valid
      end
    end
  end
end
