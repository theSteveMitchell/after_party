Gem::Specification.new do |gem|
  gem.name = 'after_party'
  gem.version = '1.8'
  gem.date = Date.today.to_s

  gem.authors = "Steve Mitchell"
  gem.description = "Automated post-deploy tasks for Ruby/Rails. Your deployment is the party. This is the after party"
  gem.summary = "A rails engine that manages deploy tasks and versions using activeRecord or mongoid"
  gem.homepage = "http://github.com/theSteveMitchell/after_party"
  gem.email = "thestevemitchell@gmail.com"
  gem.license = "MIT"

  gem.files = Dir['lib/**/**']
  gem.require_path = 'lib'

  gem.add_development_dependency "activerecord"
  gem.add_development_dependency "mongoid"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rspec-rails", "~> 2.0"
  gem.add_development_dependency "generator_spec"
  gem.add_development_dependency "factory_girl_rails"
  gem.add_development_dependency "sqlite3"
end
