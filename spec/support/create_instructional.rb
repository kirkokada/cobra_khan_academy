module CreateInstructional
  def create_instructional(options={})
    options = { topic: nil }.merge(options)
    VCR.use_cassette "instructional_save" do
      create :instructional, options
    end
  end
end

RSpec.configure do |config|
  config.include CreateInstructional
end