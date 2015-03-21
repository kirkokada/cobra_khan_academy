require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock
  config.filter_sensitive_data("ENV['google_api_key']") { ENV["google_api_key"]}
  config.ignore_localhost = true
end