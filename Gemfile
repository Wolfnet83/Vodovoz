source 'https://rubygems.org'

gem 'rails', '~> 5.2.4'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'
gem 'kaminari'
gem 'bootstrap-kaminari-views'

gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'newrelic_rpm'


gem 'devise'
gem "devise_ldap_authenticatable", :git => "git://github.com/cschiewek/devise_ldap_authenticatable.git", branch: 'default'
gem 'net-ldap'
gem 'net-ssh'

gem 'puma'

# Gems used only for assets and not required
# in production environments by default.
gem 'sass-rails'
gem 'bootstrap-sass'

gem 'coffee-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

gem 'haml-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer'
group :development do
  # Deploy with Capistrano
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-bundler', '~> 1.1'
  gem 'capistrano-rbenv', '~> 2.0'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'guard-rspec'
  gem 'pry-rails'
end

group :test do
  gem 'faker'
  gem 'capybara', '~> 3.3'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'spork'
  gem 'sqlite3'
end
