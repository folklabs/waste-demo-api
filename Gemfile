source 'https://rubygems.org'

ruby '2.2.2'

gem "sinatra"
gem "sinatra-contrib"
gem "tilt-jbuilder", ">= 0.4.0", :require => "sinatra/jbuilder"

gem "hashie"
gem 'dotenv'
gem 'savon', '~> 2.0'
gem "sinatra-cross_origin", "~> 0.3.1"
gem 'log_buddy'

gem 'oat'
gem 'oat_hydra', :git => 'https://github.com/pmackay/oat_hydra.git'

group :development do
  gem "better_errors"
  gem "binding_of_caller"
end

group :test, :development do
  gem 'rspec'
  gem 'airborne'
end

group :test do
  gem 'rack-test'
end
