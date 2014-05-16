Gem::Specification.new do |gem|
  gem.name = 'after_party'
  gem.version = '1.3'
  gem.date = Date.today.to_s

  gem.authors = "Steve Mitchell"
  gem.summary = "Automated post-deploy tasks for Ruby/Rails. Your deployment is the party. This is the after party"
  gem.homepage = "http://github.com/theSteveMitchell/after_party"

  gem.files = Dir['lib/**/**']
  gem.require_path = 'lib'
end
