require 'rails_helper'

RSpec.describe Instructional, type: :model do
  let(:topic) { create :topic }
  subject(:instructional) { topic.instructionals.build }

  it { should respond_to :url }
  it { should respond_to :title }
  it { should respond_to :author }
  it { should respond_to :description }
  it { should respond_to :duration }
  it { should respond_to :uid }
  it { should respond_to :topic }
  it { should respond_to :topic_id }

  describe "when url" do
    
    describe "is formatted correctly" do
      
      it "should be valid" do
        valid_urls = %w[http://www.youtube.com/watch?v=0zM3nApSvMg&feature=feedrecgrecindex 
                        http://www.youtube.com/user/IngridMichaelsonVEVO#p/a/u/1/QdK8U-VIH_o
                        http://www.youtube.com/v/0zM3nApSvMg?fs=1&hl=en_US&rel=0
                        http://www.youtube.com/embed/0zM3nApSvMg?rel=0
                        http://www.youtube.com/watch?v=0zM3nApSvMg
                        http://youtu.be/0zM3nApSvMg
                        http://www.youtube.com/watch?v=0zM3nApSvMg#t=0m10s]
        valid_urls.each do |url|
          subject.url = url 
          expect(subject).to be_valid 
        end
      end
    end

    describe "is formatted incorrectly" do
      
      it "should not be valid" do
        invalid_urls = %w[http://www.ytube.com/watch?v=inv@lid
                          http://www.vimeo.com
                          http://youtu.bee]
        invalid_urls.each do |url|
          subject.url = url
          expect(subject).not_to be_valid
        end
      end
    end
  end

  describe "when saved" do
    let(:uid) { "9bZkp7q19f0" } # Gangman Style!
    let(:url) { "http://youtu.be/#{uid}" }

    before do
      subject.url = url
      VCR.use_cassette "instructional_save" do 
        subject.save
      end
    end

    its(:uid)      { should eq uid }
    its(:author)   { should_not be_blank }
    its(:duration) { should_not be_blank }
    its(:title)    { should_not be_blank }
  end
end
