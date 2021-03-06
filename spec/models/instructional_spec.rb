require 'rails_helper'

RSpec.describe Instructional, type: :model do
  let(:topic) { create :topic }
  let(:uid) { "9bZkp7q19f0" } # Gangman Style!
  let(:url) { "http://youtu.be/#{uid}" }
  subject(:instructional) { topic.instructionals.build }

  it { should respond_to :url }
  it { should respond_to :title }
  it { should respond_to :author }
  it { should respond_to :description }
  it { should respond_to :duration }
  it { should respond_to :uid }
  it { should respond_to :topic }
  it { should respond_to :topic_id }
  it { should respond_to :slug }

  describe "when url" do
    
    describe "is formatted correctly" do
      
      it "should be valid" do
        valid_urls = %w[http://www.youtube.com/watch?v=9bZkp7q19f0&feature=feedrecgrecindex 
                        http://www.youtube.com/user/IngridMichaelsonVEVO#p/a/u/1/QdK8U-VIH_o
                        http://www.youtube.com/v/9bZkp7q19f0?fs=1&hl=en_US&rel=0
                        http://www.youtube.com/embed/9bZkp7q19f0?rel=0
                        http://www.youtube.com/watch?v=9bZkp7q19f0
                        http://youtu.be/9bZkp7q19f0
                        http://www.youtube.com/watch?v=9bZkp7q19f0#t=0m10s]
        valid_urls.each do |url|
          subject.url = url 
          VCR.use_cassette "instructional_save" do
            expect(subject).to be_valid 
          end
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
          VCR.use_cassette "invalid_instructional_save" do
            expect(subject).not_to be_valid
          end
        end
      end
    end
  end

  describe "when saved" do

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
    its(:slug)     { should_not be_blank }
    its(:slug)     { should eq subject.title.parameterize }
  end

  context "when uid is not unique" do
    before do
      VCR.use_cassette "instructional_save" do
        topic.instructionals.create(url: url)
      end
    end

    it "should not be saved" do
      instructional.url = url
      VCR.use_cassette "instructional_save" do
        expect { instructional.save }.not_to change(Instructional, :count)
      end
    end
  end
end
