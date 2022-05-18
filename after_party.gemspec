require_relative 'lib/version'

Gem::Specification.new do |gem|
  gem.name = 'after_party'
  gem.version = Version::VERSION
  gem.date = '2019-03-25'

  gem.authors = 'Steve Mitchell'
  gem.description = 'Automated post-deploy tasks for Ruby/Rails. Your deployment is the party. This is the after party'
  gem.summary = 'A rails engine that manages deploy tasks and versions using activeRecord or mongoid'
  gem.homepage = 'http://github.com/theSteveMitchell/after_party'
  gem.email = 'thestevemitchell@gmail.com'
  gem.license = 'MIT'

  gem.files = Dir['lib/**/**']
  gem.require_path = 'lib'

  gem.add_development_dependency 'activerecord', '~> 7'
  gem.add_development_dependency 'factory_bot', '~> 6'
  gem.add_development_dependency 'generator_spec', '~> 0'
  gem.add_development_dependency 'mongoid', '~> 7'
  gem.add_development_dependency 'rspec', '~> 3'
  gem.add_development_dependency 'rspec-rails', '~> 5'
  gem.add_development_dependency 'rubocop', '~> 1'
  gem.add_development_dependency 'sqlite3', '~> 1'
end
