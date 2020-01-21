source 'https://rubygems.org'

# specify gem dependencies in activerecord-postgres-hstore.gemspec
# except the platform-specific dependencies below

gem "activerecord", "~>4.2"

gem "mongoid"
gem "rspec"
gem "rspec-rails", "~> 3.4"
gem "generator_spec"
gem "factory_bot"
gem "sqlite3",'~> 1.3.8'
gem "rake", "0.8.7"
gem "rack-cache", "1.2"