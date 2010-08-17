require File.expand_path(File.dirname(__FILE__) + '/../../lib/rubyhaze')

class RubyHaze::Lock

  include RubyHaze::Mixins::DOProxy

  def initialize(name)
    @name = name.to_s
    @proxy_object = Hazelcast.get_lock @name
  end

end
