require 'rails_helper'

RSpec.describe Topic, type: :model do
  subject(:topic) { Topic.new name: "topic", description: "description" }

  it { should respond_to :name }
  it { should respond_to :description }
  it { should respond_to :subtopics }
  it { should respond_to :parent_id }
  it { should respond_to :parent }

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
end
