source 'https://rubygems.org'
ruby "2.2.0"

gem 'rails', '4.2.0'
gem 'pg'
gem 'puma'
gem 'haml-rails'
gem 'friendly_id'
gem 'turbolinks'

# assets
gem 'sass-rails', '~> 5.0'
gem 'bootstrap-sass'
gem 'will_paginate-bootstrap'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

# authentication 
gem 'devise'

# Active Admin
gem 'activeadmin', github: 'activeadmin'
gem 'active_admin-sortable_tree'

# Ancestry
gem 'ancestry'
gem 'ancestry_uniqueness'

# API key managment
gem 'figaro'

# API wrappers
gem 'youtube_it'

# Elasticsearch
gem 'elasticsearch-model'
gem 'elasticsearch-rails'

# Database dump/restore
gem 'yaml_db'
group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'rspec-rails'
  gem 'rspec-its'
  gem 'guard-rspec'
  gem 'spring-commands-rspec'
  gem 'rb-fsevent'
end

group :test do
  gem 'factory_girl_rails'
  gem 'terminal-notifier'
  gem 'terminal-notifier-guard'
  gem 'capybara'
  gem 'vcr'
  gem 'webmock'
end

group :production do
  gem 'rails_12factor'
  gem 'bonsai-elasticsearch-rails'
end

