source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.0'
gem 'puma', '~> 3.0'
gem 'sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails'
gem 'sprockets-rails', require: 'sprockets/railtie'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'rserve-client'

gem 'narray'
gem 'cobravsmongoose'
gem 'bootstrap-sass'

group :development do
  gem 'annotate'
  gem 'byebug'
  gem 'ruby-netcdf'
  gem 'web-console'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'binding_of_caller'
  gem 'pry-rails'
  gem 'pry-awesome_print'
  gem 'pry-byebug'
  gem 'pry-coolline'
  gem 'pry-highlight'
  gem 'pry-state'
end
