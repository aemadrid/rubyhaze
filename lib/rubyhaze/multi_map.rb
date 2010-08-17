require File.expand_path(File.dirname(__FILE__) + '/../../lib/rubyhaze')

class RubyHaze::MultiMap

  include RubyHaze::Mixins::DOProxy

  def initialize(name)
    @name = name.to_s
    @proxy_object = Hazelcast.get_multi_map @name
  end

end
