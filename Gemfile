source 'https://rubygems.org'

gem 'rails', '4.0.0'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'haml-rails'
gem 'mongo_mapper', '>= 0.13.0.beta2'
gem 'bson_ext'
gem 'less-rails-bootstrap'
gem 'honeybadger'
gem 'bcrypt-ruby', '~> 3.0.0'

group :doc do
  gem 'sdoc', require: false
end

group :production do
  gem 'unicorn'
end

group :development do
  gem 'thin'
  gem 'pry'
  gem 'capistrano', '~> 3.0'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.0'
  gem 'database_cleaner'
end
