require File.expand_path(File.dirname(__FILE__) + '/../../lib/rubyhaze')

class RubyHaze::Set

  include RubyHaze::BaseMixin

  def initialize(name)
    @name = name.to_s
    @hco = Hazelcast.get_set @name
  end

end
