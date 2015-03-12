require 'rails_helper'

RSpec.describe Topic, type: :model do
  describe "class" do
    subject { Topic }

    it { should respond_to :top_level }

    describe "top level scope" do
      
      it "should return only top level comments" do
        3.times { create :topic }
        3.times { create :topic, parent: Topic.last }
        Topic.top_level.each do |topic|
          expect(topic.parent).to be_nil
        end
      end
    end
  end
  describe "instance" do
    subject(:topic) { Topic.new name: "topic", description: "description" }

    it { should respond_to :description }
    it { should respond_to :name }
    it { should respond_to :parent }
    it { should respond_to :parent_id }
    it { should respond_to :parent_name }
    it { should respond_to :subtopics }
    it { should respond_to :top_level? }

    describe "name" do
      
      it "should be present" do
        topic.name = " "
        expect(topic).not_to be_valid
      end

      it "should not be nil" do
        topic.name = nil
        expect(topic).not_to be_valid
      end

      it "should be unique for the parent topic" do
        topic.save
        subtopic = topic.subtopics.build(name: "topic", description: "topic")
        dup = subtopic.dup
        dup.save
        subtopic.name.upcase!
        expect(subtopic).not_to be_valid
      end
    end

    describe "description" do
      
      it "should not be blank" do
        topic.description = " "
        expect(topic).not_to be_valid
      end

      it "should not be nil" do
        topic.description = nil
        expect(topic).not_to be_valid
      end
    end

    describe "top level" do
      before do
        topic.parent_id = nil  
        topic.save
      end

      it { should be_top_level }

      its(:parent) { should be_nil }
    end
  end

end
