source 'https://rubygems.org'

# Specify your gem's dependencies in hob.gemspec
gemspec

group :development do
  gem 'rspec', '~> 3.0'

  gem 'pry'

  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-rubocop', require: false
end

group :metrics do
  gem 'rubocop',                  require: false
  gem 'simplecov',                require: false
  gem 'reek',                     require: false
  gem 'mutant-rspec', '~> 0.5.3', require: false
end
