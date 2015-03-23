require 'rails_helper'

RSpec.describe Topic, type: :model do

  subject(:topic) { Topic.new name: "topic", description: "description" }

  it { should respond_to :description }
  it { should respond_to :name }
  it { should respond_to :parent }
  it { should respond_to :priority }

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
      child_topic = topic.children.build(name: "topic", description: "topic")
      dup = child_topic.dup
      dup.save
      expect(child_topic).not_to be_valid
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

  describe "slug" do
    let(:child) { topic.children.build(name: "child", description: "Child topic") }
    let(:grandchild) { child.children.build(name: "grandchild", 
                                            description: "Grandchild topic") }
    let(:expected_sequence) do 
      expected_sequence = topic.name + " " + child.name + " " + grandchild.name
    end
    before do
      topic.save
      child.save
      grandchild.save
    end
    
    it "should contain the names of its ancestors" do
      expect(grandchild.slug).to eq(expected_sequence.parameterize) 
    end

    context "when updated" do
      
      it "should update the slugs of its descendents" do
        topic.update_attribute(:name, "topik")
        expect(grandchild.reload.slug).to eq(expected_sequence.parameterize)
      end
    end
  end
end
