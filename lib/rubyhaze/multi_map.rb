require File.expand_path(File.dirname(__FILE__) + '/../../lib/rubyhaze')

class RubyHaze::MultiMap

  include RubyHaze::BaseMixin

  def initialize(name)
    @name = name.to_s
    @hco = Hazelcast.get_multi_map @name
  end

end
