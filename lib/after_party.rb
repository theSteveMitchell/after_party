module AfterParty
  require "after_party/railtie.rb" if defined?(Rails)

  mattr_accessor :enable_pretasks

  def self.setup
    yield self
  end

  def self.enable_pretasks?
    enable_pretasks
  end

end
