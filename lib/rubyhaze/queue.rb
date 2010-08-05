require File.expand_path(File.dirname(__FILE__) + '/../../lib/rubyhaze')

class RubyHaze::Queue

  include RubyHaze::BaseMixin

  def initialize(name)
    @name = name.to_s
    @hco = Hazelcast.get_queue @name
  end

end
