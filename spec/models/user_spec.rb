require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.new(email: "user@email.com",
                        password: "password",
                        password_confirmation: "password")}

  subject { user }

  it { should respond_to :email }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }
  it { should respond_to :encrypted_password }
  it { should respond_to :admin }
  it { should respond_to :is_admin? }

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
