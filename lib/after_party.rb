# AfterParty is a moduke defined by gem after_party
module AfterParty
  require 'after_party/railtie.rb' if defined?(Rails)

  def self.setup
    yield self
  end
end