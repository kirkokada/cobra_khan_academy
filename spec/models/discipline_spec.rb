require 'rails_helper'

RSpec.describe Discipline, type: :model do
  let(:discipline) { Discipline.new(name: "Wrasslin", description: "A sweaty good time") }

  it { should respond_to :name }
  it { should respond_to :description }

  describe "when name" do

    describe "is nil" do
      
      it "should not be valid" do
        discipline.name = nil
        expect(discipline).not_to be_valid
      end      
    end

    describe "is blank" do
      
      it "should not be valid" do
        discipline.name = " "
        expect(discipline).not_to be_valid
      end
    end

    describe "is not unique" do
      
      it "should not be valid" do
        dup = discipline.dup
        dup.name.upcase!
        dup.save
        expect(discipline).not_to be_valid
      end
    end

    describe "is saved" do
      
      it "should be downcased" do
        upcase_name = discipline.name.upcase
        discipline.name.upcase!
        discipline.save
        expect(discipline.reload.name).to eq(upcase_name.downcase)
      end
    end
  end

  describe "when description" do

    describe "is nil" do
      
      it "should not be valid" do
        discipline.description = nil
        expect(discipline).not_to be_valid
      end 
    end

    describe "is blank" do
      
      it "should not be valid" do
        discipline.description = " "
        expect(discipline).not_to be_valid
      end
    end
  end
end
