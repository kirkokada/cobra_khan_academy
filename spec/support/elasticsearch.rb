RSpec.configure do |config|
  config.before(:each, elasticsearch: true) do
    Instructional.__elasticsearch__.create_index!(force: true)
  end
end